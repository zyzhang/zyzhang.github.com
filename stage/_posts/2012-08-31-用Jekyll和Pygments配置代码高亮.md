---
layout: post
title: "用Jekyll和Pygments配置代码高亮"
description: "Jekyll默认的代码段样式太丑了，而且不支持语法高亮。不过，Jekyll原生支持语法高亮工具Pygments。Pygments支持超过100种语言，
并且支持多种输出格式，比如HTML, RTF等等。"
category: 搭建博客
tags: [Jekyll, Pygments]
---
{% include JB/setup %}

[Jekyll](http://jekyllrb.com)默认的代码段样式太丑了，而且不支持语法高亮。不过，Jekyll原生支持语法高亮工具[Pygments](http://pygments.org)。Pygments支持超过100种语言，
并且支持多种输出格式，比如HTML, RTF等等。

### 修改\_config.yml

设置`pygments: true`

### 本地安装Pygments

* Pygments是基于Python的，所以机器上需要[安装Python](http://www.python.org/download/)，我用的是Mac，已默认安装Python。
* [下载](http://pypi.python.org/pypi/Pygments)最新的Pygments, 本文使用的是Pygments-1.5.tar.gz，下载完成后解压
* 在解压后的Pygments目录中，运行命令：`sudo python setup.py install`

### 选择一种喜欢的代码高亮样式

Pygments提供了多种样式，比如'native', 'emacs', 'vs'等等，可以在[Pygments Demo](http://pygments.org/demo)中选择某种语言的例子，体验不同的样式。

通过下面的命令可以查看当前支持的样式：

{% highlight python %}
>>> from pygments.styles import STYLE_MAP
>>> STYLE_MAP.keys()
['monokai', 'manni', 'rrt', 'perldoc', 'borland', 'colorful', 'default', 'murphy', 'vs', 'trac', 'tango', 'fruity', 'autumn', 'bw', 'emacs', 'vim', 'pastie', 'friendly', 'native']
{% endhighlight %}

### 选择一种样式，应用在Jekyll中

* `cd /dev/projects/zyzhang.github.com/assets/themes/abel/css`
* `pygmentize -S native -f html > pygments.css`, “native”是样式名，“html”是formatter
* 在layout中引用刚刚加的pygments.css

### 在文章中高亮代码

现在，可以在博客中高亮代码了：

{% highlight html %}

{{ "{% highlight java " }}%}
public class HelloWorld {
    public static void main(String args[]) {
      System.out.println("Hello World!");
    }
}
{{ "{% endhighlight " }}%}

{% endhighlight %}

效果如下：
{% highlight java %}
public class HelloWorld {
    public static void main(String args[]) {
      System.out.println("Hello World!");
    }
}
{% endhighlight %}


### 参考文章

* [Pygments Styles](http://pygments.org/docs/styles/)
* [Liquid Extensions](https://github.com/mojombo/jekyll/wiki/Liquid-Extensions/)