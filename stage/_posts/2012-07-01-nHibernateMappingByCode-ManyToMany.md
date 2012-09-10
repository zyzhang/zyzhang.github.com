---
layout: post
title: "nHibernate Mapping By Code - Many to Many"
description: "Mapping by code是nHibernate3.2新增的功能，网络上及官方doc相关的介绍都很少。下面是如何使用mapping by code的方式配置多对多关联的例子。"
category: "Tech"
tags: [nHibernate, Mapping By Code]
---
{% include JB/setup %}

Mapping by code是nHibernate3.2新增的功能，网络上及官方doc相关的介绍都很少。下面是如何使用mapping by code的方式
配置多对多关联的例子。

关于如何配置nhibernate使用mapping by code，参考[nHibernate Mapping By Code - Introduction](/blog/2012/07/01/nHibernateMappingByCode-Introduction)

### 实体类

{% highlight csharp %}
public class Student
{
    public virtual int Id { get; set; }
    public virtual string Name { get; set; }
    public virtual IList<Course> Courses { get; set; }
}

public class Course
{
    public virtual int Id { get; set; }
    public virtual string Name { get; set; } 
    public virtual IList<Student> Students { get; set; } 
}
{% endhighlight %}

### 数据库表（基于MS SQL Server 2012）

{% highlight sql %}
CREATE TABLE [dbo].[Student](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Name] [varchar](50) NOT NULL,    
 CONSTRAINT [PK_Student] PRIMARY KEY CLUSTERED ([Id] ASC)

CREATE TABLE [dbo].[Course](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Name] [varchar](50) NOT NULL,    
 CONSTRAINT [PK_Course] PRIMARY KEY CLUSTERED ([Id] ASC)

CREATE TABLE [dbo].[Student_Course](
    [StudentId] [int] NOT NULL,
    [CourseId] [int] NOT NULL,    
 CONSTRAINT [PK_Student_Course] PRIMARY KEY CLUSTERED ([StudentId] ASC, [CourseId] ASC)

ALTER TABLE [dbo].[Student_Course] ADD CONSTRAINT [FK_Student_Course_StudentId] FOREIGN KEY([StudentId])
REFERENCES [dbo].[Student] ([Id])

ALTER TABLE [dbo].[Student_Course] ADD CONSTRAINT [FK_Student_Course_CourseId] FOREIGN KEY([CourseId])
REFERENCES [dbo].[Course] ([Id])
{% endhighlight %}
 
### 映射类

{% highlight csharp %}
public class CourseMapping : ClassMapping<Course>
{
    public CourseMapping()
    {
        Table("Course");
        Id(course => course.Id, map => map.Generator(Generators.Identity));
        Property(course => course.Name);
        Bag(course => course.Students, map =>
        {
            map.Table("Student_Course");
            map.Key(keyMapper => keyMapper.Column("CourseId"));
        }, rel => rel.ManyToMany(m => m.Column("StudentId")));
    }
}

public class StudentMapping : ClassMapping<Student>
{
    public StudentMapping()
    {
        Table("Student");
        Id(student => student.Id, map => map.Generator(Generators.Identity));
        Property(student => student.Name);
        Bag(student => student.Courses, map =>
            {
                map.Table("Student_Course");
                map.Key(keyMapper => keyMapper.Column("StudentId"));
            }, rel => rel.ManyToMany(m => m.Column("CourseId")));
    }
}
{% endhighlight %}


