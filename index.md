---
layout: home
title: Home
permalink: /
---

<div class="intro">
  <p>
  <b>Marian</b> is an efficient, free Neural Machine Translation framework written
  in pure C++ with minimal dependencies. It is mainly being developed by the <a target="_blank" href="http://translator.microsoft.com">Microsoft Translator</a> team. Many academic (most notably the University of Edinburgh and in the past the Adam Mickiewicz University in Poznań) and commercial <a target="_blank" href="https://github.com/marian-nmt/marian-dev/graphs/contributors">contributors</a> help with its development.
  </p>

  <p>
  It is currently the engine behind the <a href="http://translator.microsoft.com">Microsoft Translator</a> Neural Machine Translation services and being deployed by many companies, organizations and research projects (see <a href="#users">below</a> for an incomplete list).
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

<a name="users"/>
<h4> Companies and Organizations using Marian for Neural Machine Translation</h4>

<div class="logos-wrapper">
<div class="row">
  <a target="_blank" class="logos-link" href="http://www.microsoft.com">
    <img style="width: 400px" alt="Microsoft" title="Microsoft" src="{{ site.baseurl }}/../assets/logos/microsoft-alpha.png">
  </a>
  <a target="_blank" class="logos-link" href="http://translator.microsoft.com">
    <img style="width: 100px" alt="Microsoft Translator" title="Microsoft Translator" src="{{ site.baseurl }}/../assets/logos/ms-translator.png">
  </a>
</div>
  <br/>
  All other trademarks are the property of their respective owners.
</div>

<!--h4> Other companies, organizations and projects using Marian </h4-->
<div class="logos-wrapper row">
  {% assign logos = site.data.logos | sort: 'name' %}
  {% for logo in logos %}
  <div class="logos-item col-md-4 col-sm-6 col-xs-6">
    <a target="_blank" class="logos-link" href="http://{{ logo.url }}">
      <img class="logos-image" alt="{{ logo.name }}" title="{{ logo.name }}" src="{{ logo.img }}" />
    </a>
  </div>
  {% endfor %}
</div><!--//logos-->

<h4> Acknowledgements </h4>
<div class="intro">
<p>
Marian is mainly being developed by the <a target="_blank" href="http://translator.microsoft.com">Microsoft Translator</a> team and many academic and commercial contributors.
The development of Marian received funding from the European Union's Horizon 2020
Research and Innovation Programme under grant agreements
688139 (<a target="_blank" href="http://www.summa-project.eu">SUMMA</a>; 2016-2019),
645487 (<a target="_blank" href="http://www.modernmt.eu">Modern MT</a>; 2015-2017),
644333 (<a target="_blank" href="http://tramooc.eu/">TraMOOC</a>; 2015-2017),
644402 (<a target="_blank" href="http://www.himl.eu/">HimL</a>; 2015-2017),
825303 (<a target="_blank" href="https://browser.mt/">Bergamot</a>; 2019-2021),

the Amazon Academic Research Awards program,
the World Intellectual Property Organization,

and is based upon work supported in part by the Office of the Director of
National Intelligence (ODNI), Intelligence Advanced Research Projects Activity
(IARPA), via contract #FA8650-17-C-9117.
  </p>
</div>
