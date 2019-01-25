---
layout: home
title: Home
permalink: /
---

<div class="intro">
  <p>
  <b>Marian</b> is an efficient Neural Machine Translation framework written
  in pure C++ with minimal dependencies. It has mainly been developed at the
  Adam Mickiewicz University in Poznań (AMU) and at the University of Edinburgh.
  </p>

  <p>
  It is currently being deployed in multiple European projects and is the main
  translation and training engine behind the neural MT launch at the
  <a href="http://www.wipo.int/pressroom/en/articles/2016/article_0014.html">World Intellectual Property Organization</a>.
  </p>

  <p>
  Main features:
  <ul>
    <li> Efficient pure C++ implementation </li>
    <li> Fast multi-GPU training and GPU/CPU translation </li>
    <li> State-of-the-art NMT architectures: deep RNN and transformer </li>
    <li> Permissive open source license (MIT) </li>
    <li> <a href="{{ site.baseurl }}../features"> more details... </a> </li>
  </ul>
  </p>

  <div class="cta-container buttons-wrapper row">
    <a class="col-md-6 btn btn-primary btn-cta btn-blue" href="{{ site.github }}/marian" target="_blank">
      <i class="fa fa-github"></i>
      Download from GitHub
    </a>
    <a class="col-md-6 btn btn-primary btn-cta btn-blue" href="https://twitter.com/marian_nmt?ref_src=twsrc%5Etfw" target="_blank">
      <i class="fa fa-twitter"></i>
      Follow Marian on Twitter
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

<h4> Acknowledgements </h4>
<div class="intro">
  <p>
The development of Marian received funding from the European Union's Horizon 2020
Research and Innovation Programme under grant agreements
688139 (<a href="http://www.summa-project.eu">SUMMA</a>; 2016-2019),
645487 (<a href="http://www.modernmt.eu">Modern MT</a>; 2015-2017),
644333 (<a href="http://tramooc.eu/">TraMOOC</a>; 2015-2017),
644402 (<a href="http://www.himl.eu/">HimL</a>; 2015-2017),

the Amazon Academic Research Awards program,
the World Intellectual Property Organization,

and is based upon work supported in part by the Office of the Director of
National Intelligence (ODNI), Intelligence Advanced Research Projects Activity
(IARPA), via contract #FA8650-17-C-9117.
  </p>
</div>
