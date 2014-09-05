---
layout: post
comments: true
title: "Java 8 预览之Default Method"
description: "打开JDK 8的源代码，你会发现很多接口中多了一些标记为**default**的方法。在Java的早期版本中，**default**关键字只在swith语句中使用，在方法上使用代表什么含义呢？让我们一起来看一下Java 8新特性：**Default Method**"
category: Tech
tags: [Java, Java8, Lambda]
---

打开JDK 8的源代码，你会发现很多接口中多了一些标记为**default**的方法。在Java的早期版本中，**default**关键字只在switch语句中使用，在方法上使用代表什么含义呢？让我们一起来看一下Java 8新特性：**Default Method**。

### 何为Default Method

默认方法（Default Method），又称虚拟扩展方法（Virtual Extension Methods）或保卫者方法（Defender Method），是[JSR 335](http://www.jcp.org/en/jsr/detail?id=335)的一部分。让我们先看一下JDK中的实际例子：
{% highlight java %}
public interface Iterable<T> {
    Iterator<T> iterator();

    default void forEach(Consumer<? super T> action) {
        Objects.requireNonNull(action);
        for (T t : this) {
            action.accept(t);
        }
    }
}
{% endhighlight %}

<!-- more -->

default关键字标记的`forEach`方法即是所谓的Default Method，这里有几个有意思的地方：

+ `forEach`方法虽然定义在接口中，但是却有方法体和实现代码，这在Java 8 之前是无法通过编译的。
+ 即使`Iterable`接口定义了新方法`forEach`，其子接口`Collection`、以及实现这些接口的类（如ArrayList）却没有Override这个方法且无编译错误

### 为什么需要Default Method

看到了上面关于Default Method的描述，作为API设计者的你可能已经开始欢呼了。即使你的API已经发布出去了，你依然可以为接口添加新方法并且无需考虑向后兼容问题。Java 8引入Default Method也正是基于这个原因 <sup>注1</sup>。

### Default Method将带给我们什么

Ruby的创造者松本行弘在[《松本行弘的程序世界》](http://book.douban.com/subject/6756090/)中提到 <sup>注2</sup>：
> 其实继承包含两种含义。一种是“类都有哪些方法”，也就是说这个类都支持些什么操作，即规格的继承。
>
> 另外一种是，“类中都用了什么数据结构和什么算法”，也就是实现的继承。
>
> 静态语言中，这两者的区别很重要。Java就对这两者有很明确的区分，实现的继承用extends来继承父类，规格的继承用implements来实现接口。

引入Default Method后，Java接口就具有了“实现继承”的能力，从而更像是一种[mixin](http://en.wikipedia.org/wiki/Mixin)，增加了代码重用的能力，同时也使面向对象设计更加灵活。

-------------------

* 注1： 可以想象，Java 8对Lambda的支持必然会影响JDK API中的接口，上面的forEach就是很好的例子，如果直接在接口中添加方法，就会导致所有实现该接口的类或接口无法通过编译，而有了Default Method，一切都变得容易了。
* 注2： 摘自2.3.9 继承的两种含义

