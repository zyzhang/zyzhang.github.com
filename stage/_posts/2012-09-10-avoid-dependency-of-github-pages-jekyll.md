---
layout: post
title: "避免依赖Github Pages和Jekyll生成静态文件"
description: "之前用Github Pages + Jekyll搭建了自己的博客，有一次玩Jekyll插件之后，博客里所有使用Pygments的代码高亮都不工作了，
即使revert代码也无济于事，更奇怪的是，本地运行jekyll完全没问题，折腾很久都没有解决... 最后，我只好采取了终极解决方案了。"
category: "搭建博客"
tags: [Github Pages, Jekyll, Jekyll-Bootstrap]
---
{% include JB/setup %}

之前用Github Pages + Jekyll搭建了自己的博客，有一次玩Jekyll插件之后，博客里所有使用Pygments的代码高亮都不工作了，
即使revert代码也无济于事，更奇怪的是，本地运行jekyll完全没问题，折腾很久都没有解决... 最后，我只好采取了终极解决方案了。

[Github Pages的文档](https://help.github.com/articles/using-jekyll-with-pages)上说，当前（2012年9月）使用的是
Jekyll 0.11.0和Liquid 2.2.2，并且使用下面命令运行：

{% highlight bash %}
$ jekyll --pygments --no-lsi --safe
{% endhighlight %}

很可能是版本问题造成本地行为和Github Server行为不一致，我已经不想深究真正的原因了，Github Pages如何运作，出了什么问题，
对我完全不可见。

待续...
