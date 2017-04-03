---
layout: docs
title: Documentation
permalink: /docs/
menu: 2
---

## Marian

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi nec imperdiet turpis. Curabitur aliquet pulvinar ultrices. Etiam at posuere leo. Proin ultrices ex et dapibus feugiat [link example](#) aenean purus leo, faucibus at elit vel, aliquet scelerisque dui. Etiam quis elit euismod, imperdiet augue sit amet, imperdiet odio. Aenean sem erat, hendrerit eu gravida id, dignissim ut ante. Nam consequat porttitor libero euismod congue.

[Download PrettyDocs](http://themes.3rdwavemedia.com){: .btn .btn-primary }

## Installation

### Step One

Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis.

### Step Two

Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa.

###### Un-ordered list example

*   Lorem ipsum dolor sit amet.
*   Aliquam tincidunt mauris.
*   Ultricies eget vel aliquam libero.
    *   Turpis pulvinar
    *   Feugiat scelerisque
    *   Ut tincidunt
*   Pellentesque habitant morbi.
*   Praesent dapibus, neque id.

###### Ordered list example

1.  Lorem ipsum dolor sit amet.
2.  Aliquam tincidunt mauris.
3.  Ultricies eget vel aliquam libero.
    *   Turpis pulvinar
    *   Feugiat scelerisque
    *   Ut tincidunt
4.  Pellentesque habitant morbi.
5.  Praesent dapibus, neque id.

### Step Three

Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis.

## Code

[PrismJS](http://prismjs.com/) is used as the syntax highlighter here. You can [build your own version](http://prismjs.com/download.html) via their website should you need to.

```c
#include <iostream>

// Hello World
int main()
{
    cout << "hello world" << endl;
    int a = 10;
}
```

```cpp
#pragma once
#include <memory>
#include "common/types.h"
#include "common/soft_alignment.h"

namespace amunmt {

class Hypothesis;

typedef std::shared_ptr<Hypothesis> HypothesisPtr;

class Hypothesis {
  public:
    Hypothesis()
     : prevHyp_(nullptr),
       prevIndex_(0),
       word_(0),
       cost_(0.0)
{}
```

###### Default code example:

`bower install <package>`
`npm install <package>`

## Math

When $a \ne 0$, there are two solutions to \\(ax^2 + bx + c = 0\\) and they are
$$x = {-b \pm \sqrt{b^2-4ac} \over 2a}.$$

## Links

Here's a link to [a website](http://foo.bar), to a [local
doc](local-doc.html), and to a [section heading in the current
doc](#an-h2-header). Here's a footnote [^1].

[^1]: Footnote text goes here.

## Tables

|---
| Default aligned | Left aligned | Center aligned | Right aligned
|-|:-|:-:|-:
| First body part | Second cell | Third cell | fourth cell
| Second line |foo | **strong** | baz
| Third line |quux | baz | bar
|---
| Second body
| 2 line
|===
| Footer row
{: .table }

## Buttons

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi nec imperdiet turpis. Curabitur aliquet pulvinar ultrices. Etiam at posuere leo. Proin ultrices ex et dapibus feugiat [link example](#) aenean purus leo, faucibus at elit vel, aliquet scelerisque dui. Etiam quis elit euismod, imperdiet augue sit amet, imperdiet odio. Aenean sem erat, hendrerit eu gravida id, dignissim ut ante. Nam consequat porttitor libero euismod congue.

###### Basic Buttons

*   [Primary Button](#){: .btn .btn-primary }
*   [Green Button](#){: .btn .btn-green }
*   [Blue Button](#){: .btn .btn-blue }
*   [Orange Button](#){: .btn .btn-orange }
*   [Red Button](#){: .btn .btn-red }
