---
layout: post
title: "Java 8 预览之Lambda表达式"
comments: true
description: "我在和别人结对写C#代码的时候，只要有可能，我都会用list的forEach方法写循环，而不是用for-loop。同伴很不解，我打趣地说：“这完全是一个Java程序员的恶趣味，因为在Java的世界里没有Lambda”。说实话，我非常喜欢Lambda表达式，它简洁、明确、非常优雅。幸运的是，经历了Java 7的跳票之后，Java 8终于很有诚意的包含Lambda了。"
category: Tech
tags: [Java, Java8, Lambda]
---

我在和别人结对写C#代码的时候，只要有可能，我都会用list的forEach方法写循环，而不是用for-loop。同伴很不解，我打趣地说：“这完全是一个Java程序员的恶趣味，因为在Java的世界里没有Lambda”。说实话，我非常喜欢Lambda表达式，它简洁、明确、非常优雅。幸运的是，经历了Java 7的跳票之后，Java 8终于很有诚意的包含Lambda了。

[Lambda表达式](http://en.wikipedia.org/wiki/Lambda_expression)其实就是匿名函数，它可以作为参数传递给[高阶函数](http://en.wikipedia.org/wiki/Higher-order_function)供其调用。

<!-- more -->

Lambda表达式由三部分组成:

- 参数列表
- Lambda操作符
- 表达式或语句块

