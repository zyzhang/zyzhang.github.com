---
layout: post
comments: true
title: "Java 8 预览之Functional Interface"
description: "在JDK的类库中，有很多只声明了一个方法的接口，比如`java.lang.Iterable<T>`和`java.lang.Runnable`。这些接口被称为单抽象方法接口（Single Abstract Method interfaces），它表达了一种逻辑上的单一功能约定。Java 8为这样的接口引入了一个新概念——函数式接口（**Functional Interface**），同时引入注解`@FunctionalInterface`以帮助编译器检查函数式接口的合法性。"
category: Tech
tags: [Java, Java8, Lambda]
---

在JDK的类库中，有很多只声明了一个方法的接口，比如`java.lang.Iterable<T>`和`java.lang.Runnable`。这些接口被称为单抽象方法接口（Single Abstract Method interfaces），它表达了一种逻辑上的单一功能约定。

Java 8为这样的接口引入了一个新概念——函数式接口（**Functional Interface**），同时引入注解`@FunctionalInterface`以帮助编译器检查函数式接口的合法性。

<!-- more -->

### 何为函数式接口

[JSR 335](http://www.jcp.org/en/jsr/detail?id=335)中这样描述函数式接口:
> A functional interface is an interface that has just one abstract method, and thus represents a single function contract. (In some cases, this "single" method may take the form of multiple abstract methods with override-equivalent signatures (8.4.2) inherited from superinterfaces; in this case, the inherited methods logically represent a single method.)

函数式接口和所谓的Single Abstract Method interfaces一样，就是只包含一个抽象方法的接口，表达的是**逻辑上**的单一功能，例如：

* `java.lang.Runnable`就是一个函数式接口, 因为它只有一个抽象方法：
{% highlight java %}
public interface Runnable {
    public abstract void run();
}
{% endhighlight %}

* `java.lang.Iterable<T>`虽然有两个方法，但它仍然是函数式接口，因为forEach方法是一个[Default Method](/blog/2013/06/13/java8previewdefaultmethod/)，它有其默认实现，且不强制要求实现该接口的类或继承该接口的子接口重写（Override）该方法，因此，在逻辑上，`java.lang.Iterable<T>`仍然是只约定一个iterator方法的函数式接口。
{% highlight java %}
public interface Iterable<T> {
    Iterator<T> iterator();
    default void forEach(Consumer<? super T> action) {
        // 省略实现代码
    }
}
{% endhighlight %}

### 函数式接口与Lambda

函数式接口的一个非常重要的用途就是对Lambda提供支持，看下面的例子：

{% highlight java %}
public class Book {
    public String name;
    public String author;
    public double price;
}

public class BookStore {
    private List<Book> books = new ArrayList<>();
}
{% endhighlight %}

现在我希望BookStore能够筛选出BookStore中符合某种条件书籍，筛选条件可能多种多样，比如，所有Martin Fowler的著作，或者价格大于某个金额的所有书籍，于是，我们新增了BookFilter接口，并且为BookStore添加了list方法：

{% highlight java %}
public interface BookFilter {
    boolean test(Book book);
}

public class BookStore {
    private List<Book> books = new ArrayList<>();

    public List<Book> list(BookFilter filter) {
        List<Book> result = new ArrayList<>();
        books.forEach(book -> {
            if (filter.test(book)) {
                result.add(book);
            }
        });
        return result;
    }
}
{% endhighlight %}

现在，我们就可以在调用list方法时使用Lambda表达式了：
{% highlight java %}
// 筛选出所有价格大于15.0的书籍
bookStore.list(book -> book.price > 15.0) 
{% endhighlight %}

因为BookFilter是一个函数式接口，只具有一个抽象方法，所以在编译期可以很容易推断Lambda表达式和BookFilter是否匹配，于是Lambda表达式的实现就简单了。

### JDK提供的通用函数式接口

上面代码中的BookFilter实际上只是一个断言：如果Book符合某种条件则返回true，否则返回false。我们完全可以将这个概念抽象成**Predicate**供所有人使用，这样项目中就不会充斥过量的仅为Lambda服务的函数式接口了。Java 8的设计者同样考虑到了这个问题，于是新增了**java.util.function**包，提供通用的函数式接口。`Predicate<T>`就是其中之一。

于是，上面的list方法使用Predicate就足够了，我们可以痛快的把BookFilter扔进回收站了。
{% highlight java %}
public List<Book> list(Predicate<Book> predicate) {
    List<Book> result = new ArrayList<>();
    books.forEach(book -> {
        if (predicate.test(book)) {
            result.add(book);
        }
    });
    return result;
}
{% endhighlight %}