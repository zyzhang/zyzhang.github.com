---
layout: post
title: "Java 8 预览之Method Reference"
description: "Lambda表达式实际上是一种匿名函数，其接受者只是调用该函数并传递适当的参数而已。很多场景下，我们其实只需要将已有的函数传递给接受者就可以了，完全不需要Lambda表达式。方法引用（Method Reference）便是为此而生。"
category: Tech
tags: [Java, Java8, Lambda]
---
{% include JB/setup %}

Lambda表达式实际上相当于匿名函数，其接受者只是调用该函数并传递适当的参数而已。如果已存在某个函数能够完成匿名函数的功能，那么直接使用该函数更利于代码重用。于是Java 8顺理成章的支持方法引用（Method Reference）。

{% highlight java %}
// 打印所有姓名
List<String> names = Arrays.asList("Zhenyu", "Kaifeng", "kaifu")

// 使用Lambda表达式
names.forEach(name -> System.out.println(name));
// 使用Method Reference
names.forEach(System.out::println);
{% endhighlight %}

方法引用可以分为以下几类：

### 静态方法引用