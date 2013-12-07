---
layout: page
title: Welcom to my blog!
tagline: Supporting tagline
---
{% include JB/setup %}

## 技术文章

<ul class="posts">
  {% for post in site.posts %}
    <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>

###About Me

 内核驱动工程师

<a href="/about.html">更多信息</a> 

###联系博主：

 wangjason@163.com
