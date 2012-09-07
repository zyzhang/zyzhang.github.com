---
layout: post
title: "Hibernate N+1 问题"
description: "什么是Hibernate N+1问题，N+1问题应该如何解决，本文以nHibernate为例说明。"
category: "Tech"
tags: [nHibernate, N+1问题]
---
{% include JB/setup %}

考虑下面的一对多关系：一个Department包含多个Employee：

{% highlight %}
public class Employee
{
	public virtual int Id { get; set; }
	public virtual string Name { get; set; }
	public virtual string IdentityNumber { get; set; }
	public virtual Department Department { get; set; }
}

public class Department
{
	public virtual int Id { get; set; }
	public virtual string Name { get; set; }     
	public virtual IList<Employee> Employees { get; set; }
}
{% endhighlight %}

数据库中已有数据如下：

![nhibernate_n_1_db_data](/assets/image/posts/nhibernate_n_1_db_data.jpg)

默认情况下，Department.Employees是Lazy Load的，也就是说，当查询Department时，hibernate并不会将对应的employee也从数据库中加载进来，
而是在第一次调用Department.Employees时加载。

### N+1问题是如何出现的

当应用程序需要遍历多个Department及其Employee时，问题就出现了，看测试代码：

{% highlight %}
[Test]
public void show_n_plus_1_problem()
{
     var modelMapper = new ModelMapper();
     modelMapper.Class<Department>(cm =>
     {
          cm.Table("Department");
          cm.Id(x => x.Id, map => map.Generator(Generators.Identity));
          cm.Property(x => x.Name);
          cm.Bag(x => x.Employees, map => map.Key(k => k.Column("DepartmentId")), rel => rel.OneToMany());
     });
     MapEmployee(modelMapper);

     using (var sessionFactory = BuildSessionFactory(modelMapper))
     using(var session = sessionFactory.OpenSession())
     {
          // 1 query for retrieve all departments, got n departments
          // n query to retrieve all employees
          var departments = session.QueryOver<Department>().List<Department>();
          Assert.AreEqual(3, departments.Count);
          departments.ForEach(department => department.Employees.ForEach(employee => Console.WriteLine(employee.Name)));
     }
}
{% endhighlight %}
 
为了能在测试中动态改变nhibernate映射，这里使用了nHibernate 3.2新增的map by code特性。

{% highlight %}
private void MapEmployee(ModelMapper modelMapper)
{
     modelMapper.Class<Employee>(cm =>
         {
          　　 cm.Table("Employee");
              cm.Id(x => x.Id, map => map.Generator(Generators.Identity));
          　　 cm.Property(x => x.Name);
          　　 cm.Property(x => x.IdentityNumber);
              cm.ManyToOne(x => x.Department, map => map.Column("DepartmentId"));
　　　　　});
}

private ISessionFactory BuildSessionFactory(ModelMapper modelMapper)
{
     var configuration = new Configuration();
     configuration.Configure();

     HbmMapping hbmMapping = modelMapper.CompileMappingForAllExplicitlyAddedEntities();
     Console.WriteLine(hbmMapping.AsString());

     configuration.AddDeserializedMapping(hbmMapping, "");

     return configuration.BuildSessionFactory();
}
{% endhighlight %}

运行测试可以发现，hibernate实际执行了如下sql查询：

{% highlight sql %}
SELECT Id, Name FROM Department
SELECT Id, Name, IdentityNumber, DepartmentId FROM Employee WHERE DepartmentId=1
SELECT Id, Name, IdentityNumber, DepartmentId FROM Employee WHERE DepartmentId=2
SELECT Id, Name, IdentityNumber, DepartmentId FROM Employee WHERE DepartmentId=3
{% endhighlight %}

当执行`session.QueryOver<Department>().List<Department>()`时， nhibernate执行了1次查询`SELECT Id, Name FROM Department`，
此时*department.Employees*中并没有加载出对应的 *Employee*，而每次调用*department.Employees*时，nhibernate都会从*Employee*表中加载相应的Employee。

因此，对N个*Department*，实际会执行*N+1*次查询。这将对性能造成很大影响。

### 如何解决N+1问题

####（1）采用Batch Load批量加载

{% highlight %}
[Test]
public void resolve_n_plus_1_problem_by_batch_load()
{
     var modelMapper = new ModelMapper();
     modelMapper.Class<Department>(cm =>
     {
          cm.Table("Department");
          cm.Id(x => x.Id, map => map.Generator(Generators.Identity));
          cm.Property(x => x.Name);
          cm.Bag(x => x.Employees, map =>
          {
               map.Key(k => k.Column("DepartmentId"));
               map.BatchSize(2); // add batch size to batch load employees
          }, rel => rel.OneToMany());
     });
     MapEmployee(modelMapper);

     using (var sessionFactory = BuildSessionFactory(modelMapper))
     using (var session = sessionFactory.OpenSession())
     {
          // 1 query for retrieve all departments, got n departments
          // ceil(n/BatchSize) query to retrieve all employees
          var departments = session.QueryOver<Department>().List<Department>();
          Assert.AreEqual(3, departments.Count);
          departments.ForEach(department => department.Employees.ForEach(employee => Console.WriteLine(employee.Name)));
     }
}
{% endhighlight %}

nHibernate实际执行查询：

{% highlight %}
SELECT this_.Id as Id0_0_, this_.Name as Name0_0_ FROM Department this_
SELECT ... FROM Employee employees0_ WHERE employees0_.DepartmentId in (1, 2);
SELECT ... FROM Employee employees0_ WHERE employees0_.DepartmentId = 3 
{% endhighlight %}
 
这种方式并没有完全解决N+1查询问题，但显著减少了查询次数，实际查询为`ceil(n/BatchSize) + 1`次，BatchSize足够大时，查询次数为2次。

####（2）使用Join Fetch一次性加载所有数据

{% highlight %}
[Test]
public void resolve_n_plus_1_problem_by_join_fetch()
{
     var modelMapper = new ModelMapper();
     modelMapper.Class<Department>(cm =>
     {
          cm.Table("Department");
          cm.Id(x => x.Id, map => map.Generator(Generators.Identity));
          cm.Property(x => x.Name);
          cm.Bag(x => x.Employees, map =>
          {
               map.Key(k => k.Column("DepartmentId"));
               map.Fetch(CollectionFetchMode.Join); // eager load employees
          }, rel => rel.OneToMany());
     });
     MapEmployee(modelMapper);

     using (var sessionFactory = BuildSessionFactory(modelMapper))
     using (var session = sessionFactory.OpenSession())
     {
          // 1 query for retrieve all departments and employees
          var departments = new HashSet<Department>(session.QueryOver<Department>().List<Department>()).ToList();
          Assert.AreEqual(3, departments.Count);
          departments.ForEach(department => department.Employees.ForEach(employee => Console.WriteLine(employee.Name)));
     }
}
{% endhighlight %}
 
nHibernate实际执行查询：

{% highlight %}
SELECT ... FROM Department this_ left outer join Employee employees2_ on this_.Id=employees2_.DepartmentId
{% endhighlight %}
 
需要注意的是，这种join fetch会导致重复记录，比如本例中，因为Jim和Rechard同属于Finance部门，所以departments实际查询出4条记录，
还需用Set过一遍以保证departments集合元素的唯一性。

另外，这种在映射中直接配置join fetch的做法也不够灵活，在某些场景中，可能并不关心*Department.Employees*，join fetch没有必要。

####（3）*Department.Employees*映射仍然是Lazy的，仅在需要时通过join fetch加载

{% highlight %}
[Test]
public void resolve_n_plus_1_problem_by_join_fetch_when_necessary()
{
     var modelMapper = new ModelMapper();
     modelMapper.Class<Department>(cm =>
     {
          cm.Table("Department");
          cm.Id(x => x.Id, map => map.Generator(Generators.Identity));
          cm.Property(x => x.Name);
          cm.Bag(x => x.Employees, map => map.Key(k => k.Column("DepartmentId")), rel => rel.OneToMany());
     });
     MapEmployee(modelMapper);

     using (var sessionFactory = BuildSessionFactory(modelMapper))
     using (var session = sessionFactory.OpenSession())
     {
          // 1 query for retrieve all departments and all employees
          // Note: the retrieved departments will be duplicated if excluding the 'distinct' keyword
          var departments = session.CreateQuery("select distinct d from Department d left join fetch d.Employees").List<Department>();
          Assert.AreEqual(3, departments.Count);
          departments.ForEach(department => department.Employees.ForEach(employee => Console.WriteLine(employee.Name)));
     }
}
{% endhighlight %}

nHibernate实际执行查询：

{% highlight %}
select distinct d... from Department department0_ left outer join Employee employees1_ on department0_.Id=employees1_.DepartmentId
{% endhighlight %}
 
实际应用中，往往有些场景只关心department的数据，而不关心`department.Employees`; 而有些场景恰恰相反，关心`department.Employees`。
上面的例子就很有价值了，默认`department.Employees`为lazy load，在需要遍历`department.Employee`的场景使用另外的方法加载department，
例如：

{% highlight %}
public class DepartmentRepository 
{
    ....
    public IList<Department> FindAll()
    {
        return session.CreateQuery("select distinct d from Department d left join fetch d.Employees").List<Department>();
    }
}
{% endhighlight %}
