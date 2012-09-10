---
layout: post
title: "nHibernate Mapping By Code - Introduction"
description: "nHibernate 3.2新增了一种mapping by code的映射策略，很有意思。你可以自定义约定，并且按照约定定制自动映射策略，面对遗留数据库时这个功能往往很有用，另外，由于mapping by code是基于代码的（而不是xml文件），对domain object进行重命名的重构操作会非常方便，不用跑到xml映射文件查找字符串了。"
category: "Tech"
tags: [nHibernate, Mapping By Code]
---
{% include JB/setup %}

nHibernate 3.2新增了一种mapping by code的映射策略，很有意思。你可以自定义约定，并且按照约定定制自动映射策略，
面对遗留数据库时这个功能往往很有用，另外，由于mapping by code是基于代码的（而不是xml文件），
对domain object进行重命名的重构操作会非常方便，不用跑到xml映射文件查找字符串了。

要使用Mapping by Code很简单，

### 第一步，配置SessionFactory，使nhibernate自动扫描项目中所有继承ClassMapping的类，并将其解释为映射

{% highlight csharp %}
public class NHibernateHelper
{
    private static ISessionFactory _sessionFactory;

    public static ISessionFactory SessionFactory
    {
        get
        {
            if (_sessionFactory == null)
            {
                var configuration = new Configuration();
                configuration.Configure();

                var mappers = new ModelMapper();
                mappers.AddMappings(Assembly.GetExecutingAssembly().GetExportedTypes());

                var hbmMapping = mappers.CompileMappingForAllExplicitlyAddedEntities();
                Console.WriteLine(hbmMapping.AsString());

                configuration.AddDeserializedMapping(hbmMapping, "");

                _sessionFactory = configuration.BuildSessionFactory();
            }
            return _sessionFactory;
        }
    }

    public static ISession OpenSession()
    {
        return SessionFactory.OpenSession();
    }
}
{% endhighlight %}
 

### 第二步，为每个实体类编写映射类，映射类只需继承ClassMapping就可以被nhibernate识别。

关于如何编写映射类，参考以下文章：

* [nHibernate Mapping By Code - One to One](/blog/2012/07/01/nHibernateMappingByCode-OneToOne)
* [nHibernate Mapping By Code - One to Many and Many to One](/blog/2012/07/01/nHibernateMappingByCode-OneToManyandManyToOne)
* [nHibernate Mapping By Code - Many to Many](/blog/2012/07/01/nHibernateMappingByCode-ManyToMany)

### 参考文章：

* [NH Mapping by code VS the Untouchable DB](http://nhforge.org/blogs/nhibernate/archive/2011/09/12/nh-mapping-by-code-vs-the-untouchable-db.aspx)
* [Using NH3.2 mapping by code for Automatic Mapping](http://nhforge.org/blogs/nhibernate/archive/2011/09/05/using-nh3-2-mapping-by-code-for-automatic-mapping.aspx)
* [NHibernate剖析：Mapping篇之Mapping-By-Code(2):运用ModelMapper](http://www.cnblogs.com/lyj/archive/2011/04/10/inside-nh-mapping-by-code-apply.html)

