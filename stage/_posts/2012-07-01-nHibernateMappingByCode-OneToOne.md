---
layout: post
title: "nHibernate Mapping By Code - One to One"
description: "nHibernate提供两种one to one关联：

* primary key associations
* unique foreign key associations

下面分别用mapping by code的方式配置这两种关联。关于如何配置nhibernate使用mapping by code，
参考nHibernate Mapping By Code - Introduction"
category: "Tech"
tags: [nHibernate]
---
{% include JB/setup %}

nHibernate提供两种one to one关联：

* primary key associations
* unique foreign key associations

下面分别用mapping by code的方式配置这两种关联。
关于如何配置nhibernate使用mapping by code，参考[nHibernate Mapping By Code - Introduction](/blog/2012/07/01/nHibernateMappingByCode-Introduction)

### 1. primary key associations

####实体类

{% highlight csharp %}
public class Person
{
    public virtual int Id { get; set; }
    public virtual string Name { get; set; }
    public virtual PersonInfo PersonInfo { get; set; } 
}

public class PersonInfo
{
    public virtual int Id { get; set; }
    public virtual string PhoneNumber { get; set; }
    public virtual string Remarks { get; set; } 
    public virtual Person Person { get; set; } 
}
{% endhighlight %}

#### 数据库表（基于MS SQL Server 2012）

{% highlight sql %}
CREATE TABLE [dbo].[Person](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Name] [varchar](50) NOT NULL,    
 CONSTRAINT [PK_Person] PRIMARY KEY CLUSTERED ([Id] ASC)

CREATE TABLE [dbo].[PersonInfo](
    [Id] [int] NOT NULL,
    [PhoneNumber] [varchar](50) NOT NULL,
    [Remarks] [varchar](100) NOT NULL,
 CONSTRAINT [PK_PersonInfo] PRIMARY KEY CLUSTERED ([Id] ASC)
{% endhighlight %}

#### 映射类

{% highlight csharp %}
public class PersonMapping : ClassMapping<Person>;
{
    public PersonMapping()
    {
        Table("Person");
        Id(person => person.Id, map => map.Generator(Generators.Identity));
        Property(person => person.Name);
        OneToOne(person => person.PersonInfo, map => map.Cascade(Cascade.All));
    }
}

public class PersonInfoMapping : ClassMapping<PersonInfo>
{
    public PersonInfoMapping()
    {
        Table("PersonInfo");
        Id(personInfo => personInfo.Id, map => map.Generator(Generators.Foreign<PersonInfo>(personInfo => personInfo.Person)));
        Property(personInfo => personInfo.PhoneNumber);
        Property(personInfo => personInfo.Remarks);
        OneToOne(personInfo => personInfo.Person, map =&gt; map.Constrained(true));
    }
}
{% endhighlight %}

### 2. unique foreign key associations

#### 实体类

{% highlight csharp %}
public class Customer
{
    public virtual int Id { get; set; }
    public virtual string Name { get; set; }
    public virtual CustomerInfo CustomerInfo { get; set; } 
}

public class CustomerInfo
{
    public virtual int Id { get; set; }
    public virtual string PhoneNumber { get; set; }
    public virtual string Remarks { get; set; }
    public virtual Customer Customer { get; set; } 
}
{% endhighlight %}
 
#### 数据库表（基于MS SQL Server 2012）

{% highlight sql %}
CREATE TABLE [dbo].[CustomerInfo](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [PhoneNumber] [varchar](50) NOT NULL,
    [Remarks] [varchar](50) NOT NULL,
 CONSTRAINT [PK_CustomerInfo] PRIMARY KEY CLUSTERED ([Id] ASC)

CREATE TABLE [dbo].[Customer](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Name] [varchar](50) NOT NULL,
    [CustomerInfoId] [int] NOT NULL Unique,    
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED ([Id] ASC)

 ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [FK_Customer_CustomerInfoId] FOREIGN KEY([CustomerInfoId])
REFERENCES [dbo].[CustomerInfo] ([Id])
{% endhighlight %}

#### 映射类

{% highlight csharp %}

public CustomerMapping()
{
    Table("Customer");
    Id(customer => customer.Id, map => map.Generator(Generators.Identity));
    Property(customer => customer.Name);
    ManyToOne(customer => customer.CustomerInfo, map =>
        {
            map.Cascade(Cascade.All);
            map.Column("CustomerInfoId");
        });
}

public CustomerInfoMapping()
{
    Table("CustomerInfo");
    Id(customerInfo => customerInfo.Id, map => map.Generator(Generators.Identity));
    Property(customerInfo => customerInfo.PhoneNumber);
    Property(customerInfo => customerInfo.Remarks);
    OneToOne(customerInfo => customerInfo.Customer, map => map.PropertyReference(typeof(Customer).GetProperty("CustomerInfo")));
}
{% endhighlight %}


