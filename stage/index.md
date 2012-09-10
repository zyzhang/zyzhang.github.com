---
layout: page
title: Zhenyu's Blog
description: "张振宇的博客"
---
{% include JB/setup %}

<table width="100%" rowspan="0" colspan="0">
<tr>
<td width="70%">
	<div class="home-page-content">
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
			{% if forloop.index != 5 %}
			<div class="post-footer">&nbsp;</div>
			{% endif %}
		</div>
		{% endfor %}
	</div>
</td>

<td width="30%" style="vertical-align:top;">
	<div class="home-page-sidebar">
		<div class="sidebar-title">文章分类</div>
		<div>
			<ul class="tag_box inline">
			{% assign categories_list = site.categories %}
			{% include JB/categories_list %}
			</ul>
		</div>
		<br>
		<div class="sidebar-title">标签</div>
		<div>
			<ul class="tag_box inline">
			{% assign tags_list = site.tags %}  
			{% include JB/tags_list %}
			</ul>
		</div>
	</div>
</td>
</tr>
</table>
<hr>
<div style="width:50%;margin-left:auto;margin-right:auto;text-align:center;clear:both;">
	<a href="/archive.html">查看所有{{site.posts.size}}篇文章...</a>
</div>



