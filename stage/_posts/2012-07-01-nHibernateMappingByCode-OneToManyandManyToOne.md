---
layout: post
title: "nHibernate Mapping By Code - One to Many & Many to One"
description: "Mapping by code是nHibernate3.2新增的功能，网络上及官方doc相关的介绍都很少。下面是如何使用mapping by code的方式配置一对多和多对一关联的例子。"
category: "Tech"
tags: [nHibernate, Mapping By Code]
---
{% include JB/setup %}

Mapping by code是nHibernate3.2新增的功能，网络上及官方doc相关的介绍都很少。下面是如何使用mapping by code的方式配置一对多和多对一关联的例子。

关于如何配置nhibernate使用mapping by code，参考[nHibernate Mapping By Code - Introduction](/blog/2012/07/01/nHibernateMappingByCode-Introduction)

### 实体类

{% highlight csharp %}
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
    public virtual IList&lt;Employee&gt; Employees { get; set; }
}
{% endhighlight %}
 
### 数据库表（基于MS SQL Server 2012）

{% highlight sql %}
CREATE TABLE [dbo].[Department](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Department] PRIMARY KEY CLUSTERED ([Id] ASC)

CREATE TABLE [dbo].[Employee](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Name] [varchar](50) NOT NULL,
    [IdentityNumber] [varchar](50) NOT NULL,
    [DepartmentId] [int] NOT NULL,
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED ([Id] ASC)

ALTER TABLE [dbo].[Employee] ADD CONSTRAINT [FK_Employee_DepartmentId] FOREIGN KEY([DepartmentId])
REFERENCES [dbo].[Department] ([Id])
{% endhighlight %}

### 映射类

{% highlight csharp %}
public class DepartmentMapping : ClassMapping<Department>
{
    public DepartmentMapping()
    {
        Table("Department");
        Id(department => department.Id, map => map.Generator(Generators.Identity));
        Property(department => department.Name);
        Bag(department => department.Employees, map => map.Key(k => k.Column("DepartmentId")), rel=> rel.OneToMany());
    }
}

public class EmployeeMapping : ClassMapping<Employee>
{
    public EmployeeMapping()
    {
        Table("Employee");
        Id(employee => employee.Id, map => map.Generator(Generators.Identity));
        Property(employee => employee.Name);
        Property(employee => employee.IdentityNumber);
        ManyToOne(employee => employee.Department, map => map.Column("DepartmentId"));
    }
}
{% endhighlight %}

