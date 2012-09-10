---
layout: post
title: "Github Pages + Jekyll搭建博客之SEO"
description: "在用Github Pages + Jekyll搭建博客的过程中，学到了不少SEO（Search Engine Optimization）的知识，比如如何让博客被搜索引擎收录，需要注意哪些以提高排名等等。于是，便有了下面几条简单的总结。"
category: Tech
tags: [Github Pages, Jekyll, SEO]
---
{% include JB/setup %}

对我自己的博客而言，有些内容仅仅是自娱自乐，有没有人看不重要；而有的内容我希望能分享出去被更多的人看到，比如nHibernate Mapping By Code的一系列文章，
都是项目中实际总结出来的，那时候nHibernate刚刚增加Mapping By Code的方式，官方文档内容几乎没有，google搜索很少能找到精确的结果。所以，如果这些文章能
被更广泛的传播会帮助更多的人。

在用[Github Pages](http://pages.github.com) + [Jekyll](http://jekyllrb.com)搭建博客的过程中，
学到了不少[SEO（Search Engine Optimization）](http://en.wikipedia.org/wiki/Search_engine_optimization)
的知识，比如如何让博客被搜索引擎收录，需要注意哪些以提高排名等等。于是，便有了下面几条简单的总结。

### 让搜索引擎收录

* 如果没有任何超链接指向你的站点，在internet这个浩大的有向图中，站点就成了孤岛，不可能被搜索引擎收录。所以尽一切可能在其他网站上引用你的站点，比如友情链接，
或者在原博客上添加新博客的超链接。

* [Google Webmasters - Google站长工具](http://www.google.com/webmasters/)和[百度站长工具](http://zhanzhang.baidu.com/welcome)都提供了提交sitemap，
提交网站URL要求搜索引擎收录，索引状态查询等功能

### 为每个页面添加描述性的信息

* 在`<head>`标签中包含描述性强的title

{% highlight %}
<title>Github Pages + Jekyll搭建博客之SEO</title>
{% endhighlight %}

* 在`<meta>`标签中指定准确并且可读性强的描述(description)，它会在搜索结果中显示。

{% highlight %}
<meta content="在用Github Pages + Jekyll搭建博客的过程中，学到了不少SEO（Search Engine Optimization）的知识，比如如何让博客被搜索引擎收录，如何提高排名等等。 于是，便有了下面几条简单的总结。" name="description">
{% endhighlight %}

* [Jekyll-Bootstrap](http://jekyllbootstrap.com)已经帮你做好这个了，只需在每个page和post的开头指定title和description就可以了:

{% highlight %}
---
layout: post
title: "Github Pages + Jekyll搭建博客之SEO"
description: "在用Github Pages + Jekyll搭建博客的过程中，学到了不少SEO（Search Engine Optimization）的知识，比如如何让博客被搜索引擎收录，需要注意哪些以提高排名等等。于是，便有了下面几条简单的总结。"
category: Tech
tags: [Github Pages, Jekyll, SEO]
---
{% endhighlight %}

关于[Github Pages](http://pages.github.com)，[Jekyll](http://jekyllrb.com)和[Jekyll-Bootstrap](http://jekyllbootstrap.com)，
请参考我的另一篇文章[像极客一样写博客](/blog/2012/08/29/像极客一样写博客)

### 多用内部链接

内部链接指的是同一个网站的内容页面之间的互相链接，比如下面引文中的“[像极客一样写博客](/blog/2012/08/29/像极客一样写博客)”。

> 关于[Github Pages](http://pages.github.com)，[Jekyll](http://jekyllrb.com)和[Jekyll-Bootstrap](http://jekyllbootstrap.com)，
> 请参考我的另一篇文章[像极客一样写博客](/blog/2012/08/29/像极客一样写博客)

相关性高的内部链接除了有助于提高用户体验外，还有助于提高搜索引擎的索引效率，控制站内权重分布，并提升网站的收录率。
[这个文章](http://bbs.chinaz.com/Shuiba/thread-1683921-1-1.html)对内部链接总结的挺好。

### 避免死链接

[死链接](http://baike.baidu.com/view/1880779.htm)即无效链接，不仅用户体验不好，还会降低网站在搜索引擎中的权重。

[Jekyll-Bootstrap](http://jekyllbootstrap.com)默认的permalink就是一个造成死链接的隐患：

`permalink: /:categories/:year/:month/:day/:title`

Jekyll会按照这个格式为每篇文章生成URL，例如： 

`zyzhang.github.com/tech/2012/01/01/helloworld` 

一旦你重新组织或修改了category，所有的内部链接都要修改，否则就成了死链接，另外，之前被搜索引擎收录的页面也全部失效了。

所以，我把permalink修改成了：

`permalink: /blog/:year/:month/:day/:title`


