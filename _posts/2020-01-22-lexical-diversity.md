---
layout: posts
title: "Is MT really lexically less diverse than human translation?"
published: true
excerpt: This blog post describes my journey into the rabbit hole that is lexical diversity of machine translation outputs. We take a look at lexical diversity of WMT19 systems and test sets.
---

## What got me interested in lexical diversity of MT outputs?

This blog post describes my journey into the rabbit hole that is lexical diversity of machine translation outputs. I got interested in the topic after attending MT Summit 2019 in Dublin last year and listening to two intriguing talks, one by Eva Vanmassenhove ([Vanmassenhove et al. 2019](https://www.aclweb.org/anthology/W19-6622/){:target="_blank"} ) and one by Antonio Toral ([Toral 2019](https://www.aclweb.org/anthology/W19-6627/){:target="_blank"})  -- which then went on to win the best paper award at that conference for his talk. 

Both papers conclude -- among other observations -- that machine translation outputs demonstrate lower lexical diversity as measured by various existing metrics than human translations. Machine translation and human translations in turn demonstrate lower lexical diversity than human-written text that was naturally composed in the same target language. I like both papers a lot for the approaches they take in analyzing their data, but both have problems in their choice of analyzed MT systems and modeling decisions.  [Vanmassenhove et al. (2019)](https://www.aclweb.org/anthology/W19-6622/){:target="_blank"} create MT systems that due to small data and lack of subword segmentation are likely to show lower lexical diversity. [Toral (2019)](https://www.aclweb.org/anthology/W19-6627/){:target="_blank"} includes a number of state-of-the-art systems (at their time of creation), but in my opinion too few to be able to infer that MT is generally lexically less diverse than human translations (the main focus of that work is Post-Editese though). 
[Vanmassenhove et al. (2019)](https://www.aclweb.org/anthology/W19-6622/){:target="_blank"}  look at two translation directions (en-fr, en-es) with small training corpora (ca. 100K sentences) and three MT flavors (SMT, NMT-RNN, NMT-Transformer) with and without back-translation, 12 systems altogether. [Toral (2019)](https://www.aclweb.org/anthology/W19-6627/){:target="_blank"} compares 18 systems on 6 language pairs, one of them can be considered close to current state-of-the-art (zh-en). Both use type-token ration (TTR) as one of their metrics. I will do the same in this post. Type-token ratio is just the number of unique lexical item in the text divided by the number of running tokens. For data sets of the same length this is probably a reasonable diversity measure. In my repository I also have code for using MTLD, but I saw no strongly differing results while MTLD feels unreasonably complicated and numerically ill-defined (+inf for perfect LD?). 

The research questions in these two papers sparked my interest, but I am mostly curious if lexical diversity (LD) -- this apparently easily measurable property -- can be used for something practical. If LD indeed reliably separates natural text from human translationese and human translationese from machine translationese as these works suggest then there might be applications to identifying machine-translated content in large parallel corpora or at least the directionality of human translations (looking at gradients of LD on both sides compared to other document pairs with gradients pointing in other directions). Or we might be able to subselect training corpora to have larger LD, potentially increasing the LD of our MT systems if that is actually a desired property. To get a better feeling for LD, let's go large-scale!

## WMT or it didn't happen!

I have been vocally critical of work that uses artificially small data for testing research hypotheses. By "artificially small" I mean cases where lots of data is actually available, but only a small corpus is chosen for experiments with little to no justification. I am also of the opinion that question about capabilities of MT have to be measured on capable MT models. Toy models trained on toy data result in toy answers. 

For this analysis, I reached for [WMT19](https://www.aclweb.org/anthology/W19-5301/){:target="_blank"} outputs  which give us a good mix of high and low-resource systems, including current large MT online engines. For WMT19 alone, I am looking at 14 translation directions and over 180 MT systems. It also gives me lots of test sets, results of human evaluation and even more historical data from previous years. We can assume that the best of the best is taking part in WMT. So much for the good part. We also have to be careful with overstating the results that we will gain from this. We are looking at only one domain (news) and WMT has a specific way of creating their test sets. There has been quite a bit of a debate concerning the quality of WMT test sets and the process involved. This needs to be emphasized as potential problems.

## On the lexical diversity of WMT19 systems

The [GitHub repository](https://github.com/emjotde/diversity){:target="_blank"} contains all the code required to repeat the experiments and to recreate the figures in this post. To compute TTR, I extract all continuous Unicode letter strings as tokens and lowercase them. Punctuation and numbers are ignored. For Chinese as a target language I separate them into single glyphs, that might be suboptimal.

So, let's first look at TTR for all the WMT19 translation directions and the human-created references. Below (click for full size) you can see one box plot per translation direction. The red dot marks the LD of the human reference set. The box plot spans multiple MT systems from most to least lexically diverse as measured by TTR. 

[![lexical diversity for WMT19]({{ "/assets/images/blog/ld/fig1.ttr.png" }})](/assets/images/blog/ld/fig1.ttr.png){:target="_blank"}

What we can see immediately that in not a single case the human reference is the most lexically diverse (although it comes close a few times). There is always a couple of MT systems in the competition that display more lexical diversity than the human reference. I some cases the majority of MT systems is more diverse than the reference; for LT-EN, the reference is actually the lexically least diverse one. This is interesting. For WMT19 at least, it seems there would be no way to successfully tell apart MT from the human translated test set using TTR as a measure. 

## Does lexical diversity correlate with human-perceived quality?

During the discussion time after the mentioned talks, the question of the meaning of lexical diversity was raised. Is higher LD actually better? Does lower LD stand for more consistency etc. Can we draw conclusions about lexical diversity and translation quality? Are more diverse MT outputs better than less diverse ones? Luckily, we can use WMT19 data to shed some light at that question as well. The system-level human judgments are available for download and we are looking at normalized z-Scores (x-axis) versus TTR (y-axis) for all language pairs in the figure below (click for full size). 

[![correlation with human judgement]({{ "/assets/images/blog/ld/fig2.ttr.png" }})](/assets/images/blog/ld/fig2.ttr.png){:target="_blank"}

Green marks are MT systems, the red mark is the reference. For about half the translation directions the reference was included as a system to-be-judged by humans, for the rest the red mark is missing. We plot regression lines to indicate Pearson correlation between the two measures. Across all the language pairs it seems there is no visible correlation between LD and direct assessment of MT quality. Pearson correlation across all pairs is about 0.06, essentially random. For plots with the red marks of the human reference we can now clearly see that it is never the most lexically diverse. In the few cases where MT systems are close or better than the reference in terms of MT quality their lexical diversity can be higher and lower. As before, there are enough reasons to be critical about the WMT evaluation methods, but it seems that using LD for QE is not going to happen very soon (unless of course we discover that the human judgments are wrong).

## What are the trends over time?

Until now we have collected a number of negative results for our WMT19 data. However, we are using much stronger and technologically newer systems than the papers we discussed earlier. Maybe MT systems have only recently reached their degree of lexical diversity? 

Let's take a look at a couple of years back. WMT19 is the first year where all the test sets are translated with the correct directionality. Between WMT15 and WMT18, half the test set would have the correct direction, and half would have translationese source text with natural target text. The situation seems to be less clear before WMT15. Based on that, I separated the English-German test sets and the MT outputs from WMT15-18 into corresponding halves and calculate LD for MT vs translationese target text over the past five years, WMT15 to WMT19, in the figure below. In WMT15 only one system ([Jean et al. 2015](https://www.aclweb.org/anthology/W15-3014/){:target="_blank"}) was a neural system, the rest was SMT or syntax-based. In the following years we can expect a mixed field of competitors, becoming fully neural towards WMT19. Looking at the figure below (click for full size) however we can see, that there is no trend. Even five years ago, LD would not have been a MT vs Human discriminator. The picture is similarly random for other languages (plots can be generated with my Makefile by replacing language ids).

[![Trend on natural reference]({{ "/assets/images/blog/ld/fig3.ttr.png" }})](/assets/images/blog/ld/fig3.ttr.png){:target="_blank"}

For the years WMT15 to WMT18 we also have the other half of the test sets, the halves with the translationese input and natural target text. Let's have a look at the figure below (click for full size) what is going on there. 

[![Trend on natural reference]({{ "/assets/images/blog/ld/fig3.ttr.inv.png" }})](/assets/images/blog/ld/fig3.ttr.inv.png){:target="_blank"}

Here we finally see something quite significant: over all four years the natural target is lexically more diverse than all the MT systems, by quite some margin. I verified that this is the case for a number more translation pairs and the results is the same. Unfortunately, in this setup we do not have human-created translations in the mix, so we can only compare apples to slightly different apples across the different time-based plots. 


## Conclusions?

What can we conclude? A few things: For WMT data and systems specifically there seems to be no indication that WMT test sets created by humans are lexically more diverse than WMT systems. They actually seem to fall into the same ballpark. There seems to be no larger difference or change in trend across the years while moving from SMT to NMT. There seems to be no meaningful correlation between the lexical richness of MT and its human-judged quality, whether in source-based or reference-based human-eval scenarios. 

Natural text is clearly more diverse than MT output, but this comes with a BIG gotcha for WMT: These MT systems translated from source translationese which is likely to be less diverse than natural text, so that would possibly result in a double loss of lexical richness, first by human, next by machine. It might be unfair to judge the MT systems based on that. 

So, can LD be useful for anything? Hard to say for now. I see some hope for identifying natural text versus translationese, whether it comes from machines or humans. 

As for the main question from the post title: I think we need to be precise that the lexical diversity of WMT outputs is similar to that of WMT test set references. There is the very real possibility that WMT translations are of a lower quality than other translations although they have been ordered from professional agencies etc. I have no evidence for or against that. However, these results also mean that claims of generally lower lexical diversity for MT are potentially doubtful. For one of the most important and biggest MT competitions and its test sets they would be wrong. 