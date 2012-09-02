---
layout: page
title: Zhenyu's Blog
description: "张振宇的博客"
---
{% include JB/setup %}
<!--
<ul class="posts">
  {% for post in site.posts %}
    <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>
-->
{% for post in site.posts limit:5 %}
<div class="home-page-post">
  	<div class="post-header">
  		<div class="date">{{ post.date | date_to_string }}</div>
  		<div class="tags"> 
  			<label>Tags: </label>{{ post.tags | array_to_sentence_string }}
  		</div>
  		<div class="category"> 
  			<label>Category: </label>
  			<span>{{ post.category }}</span>
  		</div>
  	</div>
    <div class="post-content">
    	<div class="title"><a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></div>
    	<div class="abstract">{{ post.description | markdownify }}</div>
    	<div style="float:right;"><a href="{{ BASE_PATH }}{{ post.url }}">阅读全文</a></div>
    </div>
    <div class="post-footer">&nbsp;</div>
</div>
{% endfor %}

<div style="width:50%;margin-left:auto;margin-right:auto;text-align:center;">
	<a href="/archive.html">查看所有{{site.posts.size}}篇文章</a>
</div>



