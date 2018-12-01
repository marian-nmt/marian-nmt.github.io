#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function

import sys
import re

COLUMN_WIDTH = 40
LINE_WIDTH = 100
DEBUG = False


for l, line in enumerate(sys.stdin):
    text = line.rstrip()
    if len(text) <= LINE_WIDTH:
        print(text)
    else:
        if DEBUG:
            print('>>> line {} has length {}'.format(l, len(text)))
        space_left = LINE_WIDTH
        prev_idx = 0
        breaks = [0]
        matches = [(m.start(), m.end() - m.start()) for m in re.finditer(r' +', text)] \
                + [(len(text), 0)]
        for idx, space_width in matches:
            word = text[prev_idx:idx]
            if DEBUG:
                print('>>> prev idx: {} idx: {} word width: {} space width: {} space left: {}'.format(prev_idx, idx, len(word), space_width, space_left))
            if len(word) + space_width >= space_left:
                if DEBUG:
                    print('>>> break!')
                breaks.append(prev_idx)
                space_left = LINE_WIDTH - COLUMN_WIDTH - len(word)
            else:
                space_left -= (len(word) + space_width)
            prev_idx = idx + space_width
        breaks.append(len(text))
        if DEBUG:
            print('>>> breaks: {}'.format(breaks))
        for i, (s, e) in enumerate(zip(breaks, breaks[1:])):
            if i > 0:
                print(" " * (COLUMN_WIDTH - 2), end='')
            print(text[s:e])

