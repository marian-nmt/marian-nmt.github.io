#!/bin/bash
tail -n +2 | cat -s | sed -e 's/^$/```/' -re 's/^(.*options):$/\n## \1\n```/' -e 's/^  //' | sed '2d' | sed 's/Examples:/\n\rExamples:\n\r```\r/' | sed -re 's/Usage: (.*)/Usage: `\1`/'
echo '```'
