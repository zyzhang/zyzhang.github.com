---
layout: post
comments: true
title: "避免依赖Github Pages和Jekyll生成静态文件"
description: "之前用Github Pages + Jekyll搭建了自己的博客，有一次玩Jekyll插件之后，博客里所有使用Pygments的代码高亮都不工作了，
即使revert代码也无济于事，更奇怪的是，本地运行jekyll完全没问题，折腾很久都没有解决... 最后，我只好采取了终极解决方案了。"
category: "搭建博客"
tags: [Github Pages, Jekyll, Jekyll-Bootstrap]
---

之前用Github Pages + Jekyll搭建了自己的博客，有一次玩Jekyll插件之后，博客里所有使用Pygments的代码高亮都不工作了，
即使revert代码也无济于事，更奇怪的是，本地运行jekyll完全没问题，折腾很久都没有解决... 最后，我只好采取了终极解决方案了。

[Github Pages的文档](https://help.github.com/articles/using-jekyll-with-pages)上说，当前（2012年9月）使用的是
Jekyll 0.11.0和Liquid 2.2.2，并且使用下面命令运行：

{% highlight bash %}
$ jekyll --pygments --no-lsi --safe
{% endhighlight %}

<!-- more -->

很可能是版本问题造成本地行为和Github Server行为不一致，但我已经不想深究真正的原因了，因为Github Pages如何运作，出了什么问题，
对我完全不可见。

最后，我采取了下面的方案
* 在repository根目录（`zyzhang.github.com`）下创建stage文件夹，所有jekyll相关的文件都在这个文件夹下
* 在根目录下添加`.nojekyll`文件，github pages会禁用Jekyll
* 每次都在stage中启动jekyll预览博客
* 发布时，将`stage/_site`中的所有文件copy到根目录下 （命令行中运行stage/publish）
* git push

这样，就完全解耦了对Github Pages运行环境的依赖，只要本地是work的，server上就一定是work的，另外，可以在本地随意的
使用和编写jekyll插件(Github Pages出于安全原因不会运行用户自定义的plugin)

具体文件结构参见[源代码](https://github.com/zyzhang/zyzhang.github.com)。