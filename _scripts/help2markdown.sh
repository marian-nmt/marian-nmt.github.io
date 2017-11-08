#!/bin/bash
tail -n +4 | sed -e 's/^$/```/' -re 's/^(.*options):$/\n## \1\n```/' -e 's/^  //'
