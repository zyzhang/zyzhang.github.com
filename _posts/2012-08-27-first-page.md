---
layout: post
title: "First Page"
description: "This is an abstract for post"
category: Tech
tags: [first, page]
---
{% include JB/setup %}

First Post of Abel

{{ page.content | number_of_words }}

{% highlight ruby linenos table %}
def foo
  puts 'foo'
end
{% endhighlight %}
