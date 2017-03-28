---
layout: home
title: Home
permalink: /
---

<h2 class="title">Welcome to {{ site.title }}!</h2>
<div class="intro">
  <p>{{ site.description }}</p>
  <br/>
  <div class="cta-container">
    <a class="btn btn-primary btn-cta" href=" {{ site.github }} " target="_blank">
      <i class="fa fa-github"></i>
      Download from GitHub
    </a>
  </div><!--//cta-container-->
</div><!--//intro-->

<div id="cards-wrapper" class="cards-wrapper row">

  {% for card in site.data.cards %}
  <div class="item item-{{ card.color }} col-md-4 col-sm-6 col-xs-6">
    <div class="item-inner">
      <div class="icon-holder">
        <span aria-hidden="true" class="icon fa {{ card.icon }}"></span>
      </div><!--//icon-holder-->
      <h3 class="title">{{ card.title }}</h3>
      <p class="intro">{{ card.intro }}</p>
      <a class="link" href="{{ card.link }}"><span></span></a>
    </div><!--//item-inner-->
  </div><!--//item-->
  {% endfor %}

</div><!--//cards-->
