---
layout: page
title: Zhenyu's Blog
---
{% include JB/setup %}
<!--
<ul class="posts">
  {% for post in site.posts %}
    <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>
-->
{% for post in site.posts %}
<div class="home-page-post">
  	<div class="post-header">
  		<div class="date">{{ post.date | date_to_string }}</div>
  		<div class="tags"> 
  			<label>Tags: </label>
  			{% for tag in post.tags %}
    			<span>{{ tag }}</span>;&nbsp;
  			{% endfor %}
  		</div>
  		<div class="category"> 
  			<label>Category: </label>
  			<span>{{ post.category }}</span>
  		</div>
  	</div>
    <div class="post-content">
    	<div class="title"><a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></div>
    	<div class="abstract">{{ post.abstract }}</div>......
    </div>
    <div class="post-footer">&nbsp;</div>
</div>
{% endfor %}



