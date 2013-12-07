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

<section>
<h4>About me</h4>
<div>
 操作系统内核驱动工程师，主要从事驱动开发和内核开发。<a href="/about.html">更多信息</a> 
<br/>
<br/>
<strong><font color="red"><a href="/atom.xml" target="_blank">订阅本站</a></font></strong>
<br/><br/>
联系博主：Atwoodwang:wangatwood@gmail.com
</div>
</section>
