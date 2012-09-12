---
layout: post
title: "像极客一样写博客"
description: "我以前用过csdn，iteye和cnblog的博客，始终不能令我满意。样式不喜欢，广告太多，富文本编辑器局限，等等等等问题，
所以每次更换博客后最终都是一个结果，太监了（好吧，我承认主要是因为懒惰...）。也想过学其他同事那样，买个酷酷的域名，
租个空间，再用WordPress搭个自己的博客，不过可惜，这种方式对我还是没啥驱动力... 日复一日，年复一年，直到有一天，
GitHub Pages和Jekyll横空出世，瞬间点亮了我辈以极客自诩的屌丝程序员的双眼！"
category: 搭建博客
tags: [Github Pages, Jekyll, Jekyll-Bootstrap]
---
{% include JB/setup %}

![blogging](/assets/image/posts/blogging.jpg)

我以前用过csdn，iteye和cnblog的博客，始终不能令我满意。样式不喜欢，广告太多，富文本编辑器局限，等等等等问题，
所以每次更换博客后最终都是一个结果，太监了（好吧，我承认主要是因为懒惰...）。

也想过学其他同事那样，买个酷酷的域名，租个空间，再用WordPress搭个自己的博客，不过可惜，这种方式对我还是没啥驱动力... 

日复一日，年复一年，直到有一天，GitHub Pages和Jekyll横空出世，瞬间点亮了我辈以极客自诩的屌丝程序员的双眼！

最近一周的业余时间都花在了在GitHub上玩博客，并且乐此不疲，为什么这货如此吸引我呢？

* __DIY的乐趣__：作为一个会写HTML、Javascript、css的程序员，在自己的地盘不能把页面改成喜欢的样式简直是...抓心挠肝啊。
* __安全无广告__
* __GitHub空间无极限__：早些时候，GitHub的Public Repository空间已经Unlimited了，给力！
* __域名够酷__：你可能觉得`zhenyu.im`之类的域名酷，可偶是程序员，就喜欢`zhenyu.github.com` (可惜这个已经被人抢先了，偶只好用`zyzhang.github.com`了)
* __像写代码一样写博客__：版本控制的思想早已深深印在程序员的骨子里了，commit啦，push啦，pull啦，diff啦，git有的，你都有！
* __真正动手实践一些以前不了解的技术__：参考我的另一篇文章[Github Pages + Jekyll搭建博客之SEO](/blog/2012/09/03/blog-with-github-pages-and-jekyll-seo)
* __只有你想不到，没有你做不到__：平时用Markdown写博客，简单又方便，需要特殊效果时，有什么是HTML+Javascript+css做不到的呢？

回到正题，如果你和我一样喜欢这种崭新的博客方式，完成下面几个任务，然后尽情享受写博客的乐趣吧。

### 在Github上创建Repository

名字必须为${USERNAME}.github.com，${USERNAME}替换为你自己的用户名。

现在，你可以向这个repository提交静态文件（比如index.html）, 稍等一会你就可以在浏览器地址栏输入${USERNAME}.github.com访问你的页面了。

### 在刚建好的repository中创建Jekyll格式的文件结构

这里，我们借助[Jekyll-Bootstrap](http://jekyllbootstrap.com)，这是一个基于Jekyll的解析引擎，支持模块化的主题(modular theming)。

{% highlight bash %}
$ git clone https://github.com/plusjade/jekyll-bootstrap.git USERNAME.github.com
$ cd USERNAME.github.com
$ git remote set-url origin git@github.com:USERNAME/USERNAME.github.com.git
$ git push origin master
{% endhighlight %}

![jekyll-bootstrap-dir-structure](/assets/image/posts/jekyll-bootstrap-dir-structure.png)

上面代码创建了如左图的Jekyll-Bootstrap标准目录结构，各个文件夹的用途在[Jekyll Introduction](http://jekyllbootstrap.com/lessons/jekyll-introduction.html)中介绍的很清楚了，这里不再多说。

**需要注意的是：**

1. \_includes下的themes文件夹，这是定义主题的地方。
2. Jekyll支持[Markdown](http://en.wikipedia.org/wiki/Markdown)等轻量级标记语言，所以有很多文件以.md为后缀名。
3. 文章都放在\_posts文件夹下，post的文件名必须遵循`YEAR-MONTH-DATE-title.后缀名`的格式，例如：2012-08-29-像极客一样写博客.md

这时候访问你的博客页面，会看到默认的twitter主题样式，更多主题可以访问 [http://themes.jekyllbootstrap.com](http://themes.jekyllbootstrap.com)。

### 安装Jekyll

安装Jekyll后，可以很方便的在发布文章之前进行本地预览。下面是安装步骤：

* Jekyll是基于Ruby的，所以，要先[安装Ruby](http://www.ruby-lang.org/en/downloads)。
* 通过ruby gem安装：` gem install jekyll`

安装完毕后，在${USERNAME}.github.com目录下运行`jekyll --server`启动server，然后就可以在本地访问http://localhost:4000预览博客了。

### 自定义主题

Jekyll-Bootstrap的主题管理很简单，有两种方式，一种是安装官方提供的主题，一种是自定义主题，详细内容参考[Using Themes](http://jekyllbootstrap.com/usage/jekyll-theming.html)

### 发布博客

发布博客和管理代码库一样，可以利用到git的强大功能，只要push上去了，本地更改就发布了。

### 例子

本博客就是依照上述步骤搭建起来的，你可以访问完整[源代码](https://github.com/zyzhang/zyzhang.github.com), 另外，由于Github Pages出于安全原因不支持用户自定义Jekyll插件，并且有时候Pygments代码高亮也有些问题，所以我改变了发布策略，只发布静态文件，详情见
[避免依赖Github Pages和Jekyll生成静态文件](http://zyzhang.github.com/blog/2012/09/10/avoid-dependency-of-github-pages-jekyll)。
如果你不关心上述问题，仍然可以按照上面的步骤搭建标准的Github博客。

### 参考文章
* [Jekyll Introduction](http://jekyllbootstrap.com/lessons/jekyll-introduction.html)
* [Jekyll Quick Start](http://jekyllbootstrap.com/usage/jekyll-quick-start.html)
