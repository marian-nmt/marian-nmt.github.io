---
layout: blog
title: Blog
permalink: /blog
icon: fa-pencil-square-o
menu: 7
---

  {% for post in site.posts %}
  <div class="blog-content">
    <a class="blog-title" href="{{ post.url }}"><h2>{{ post.title }}</h2></a>
    <div class="blog-date">{{ post.date | date_to_long_string }}</div>
    {{ post.excerpt }}
    <a class="blog-continue" href="{{ post.url }}">Continue ...</a>
  </div>
  {% endfor %}

