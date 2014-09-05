---
layout: post
comments: true
title: "Java 8 预览之Method Reference"
description: "既然Lambda表达式相当于匿名函数，那么对于其使用者而言，传给它一个匿名函数还是有名字的函数其实没有区别，只要这个函数满足使用者的规约即可。而且很多时候有名字的函数反而可读性更好并且更利于代码重用。如此说来，Java 8 引入方法引用（Method Reference）也就顺理成章了。"
category: Tech
tags: [Java, Java8, Lambda]
---

先看一个Lambda表达式的例子：

{% highlight java %}
Arrays.asList("Windows", "Mac OSX").forEach(x -> System.out.println(x));
{% endhighlight %}

既然Lambda表达式`x->System.out.println(x)`相当于匿名函数（接受一个String类型的参数，无返回值），那么对于其使用者`forEach`而言，传给它一个匿名函数还是有名字的函数其实没有区别，只要这个函数满足`forEach`的参数规约即可。而且很多时候有名字的函数反而可读性更好并且更利于代码重用。如此说来，Java 8 引入方法引用（Method Reference）也就顺理成章了。上面的代码用方法引用可以写成：

{% highlight java %}
Arrays.asList("Windows", "Mac OSX").forEach(System.out::println);
{% endhighlight %}

<!-- more -->

下面列举了方法引用的几种使用方式，以书店（BookStore）作为示例：

{% highlight java %}
public class Book {
    public String name;
    public String author;
    public Double price;
    // 省略部分代码
}

public class BookStore {
    private List<Book> books = new ArrayList<>();
    
    public List<Book> list(Predicate<Book> filter) {
        List<Book> result = new ArrayList<>();
        books.forEach(book -> { if (filter.test(book)) result.add(book); });
        return result;
    }
    // 省略部分代码
}
{% endhighlight %}

### 静态方法引用

{% highlight java %}
class BookFilter {
    public static boolean booksOfMartinFowler(Book book) {
        return "Martin Fowler".equals(book.author);
    }
}

List<Book> books = bookStore.list(BookFilter::booksOfMartinFowler);
{% endhighlight %}

### 实例方法引用（instance method reference）

{% highlight java %}
class BookFilter {
    public boolean freeBooks(Book book) {
        return book.price == 0;
    }
}

BookFilter bookFilter = new BookFilter();
List<Book> books = bookStore.list(bookFilter::freeBooks);
{% endhighlight %}

### 一个有趣的例子

Java的[Tutorial](http://docs.oracle.com/javase/tutorial/java/javaOO/methodreferences.html)还提供了一个很有意思的例子，很是让我费解了半天。
{% highlight java %}
String[] stringArray = { "Barbara", "James", "Mary", "John",
    "Patricia", "Robert", "Michael", "Linda" };
Arrays.sort(stringArray, String::compareToIgnoreCase);
{% endhighlight %}

问题来了，`compareToIgnoreCase`方法和`compare`方法从签名上看完全不匹配啊，编译器在解析方法引用的时候，是怎么判断二者匹配的呢？
{% highlight java %}
// Arrays.sort
public static <T> void sort(T[] a, Comparator<? super T> c) 
// Comparator
public interface Comparator<T> {
    int compare(T o1, T o2);
}
// String::compareToIgnoreCase
public int compareToIgnoreCase(String str)
{% endhighlight %}

于是我展开了无耻的联想：）既然同样的方式可以用Lambda写也可以用方法引用写，那么编译器很可能将两种方式最终都转化成匿名函数，这样更简单。先把同样的功能用Lambda写一遍：
{% highlight java %}
Arrays.sort(stringArray, (name1, name2) -> name1.compareToIgnoreCase(name2));

// 更进一步
Comparator<String> comparator = (name1, name2) -> {
    return name1.compareToIgnoreCase(name2);
};
Arrays.sort(stringArray, comparator);
{% endhighlight %}

编译器最终交给`Arrays.sort`的很可能就是这样一个东西：
{% highlight java %}
class Foo implements Comparator<String>{
    int compare(String s1, String s2) {
        return s1.compareToIgnoreCase(s2);
    }
}
{% endhighlight %}

编译器在解析`String::compareToIgnoreCase`时，会试图将`compareToIgnoreCase`作为`Foo.compare`的实现体。参数类型和方法引用中指定的类型都是String，返回值都要求是int，恰好匹配！（以上内容纯属猜测，不过帮助我理解了它的行为）

同样的道理，下面的代码将会通过编译并且可以运行，只是结果不是我们期待的罢了：
{% highlight java %}
Arrays.sort(stringArray, String::indexOf);
{% endhighlight %}








