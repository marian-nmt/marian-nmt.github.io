#!/usr/bin/env python3

"""Marian CLI to markdown converter

This script populates a markdown template to document Marian commands.

It enables the follow tags:
  * command
  * description
  * version
  * options
  * examples
"""

from collections import defaultdict
import argparse
import os
import sys


class IgnoreMissing(dict):
    """Dict that returns an empty string for missing keys"""

    def __missing__(self, key):
        return ""


# Define markdown insertions
blockheading = "### "
codeblock = "```"


def parse_args():
    parser = argparse.ArgumentParser(description="Generate command documentation")

    parser.add_argument(
        "name", type=str, help="Name of marian comman (e.g. marian-decoder)"
    )
    parser.add_argument(
        "versionfile",
        type=argparse.FileType("r"),
        help="File containing the output of '--version' (e.g. marian-decoder --version)",
    )
    parser.add_argument(
        "helpfile",
        type=argparse.FileType("r"),
        help="File containing the output of '--help' (e.g. marian-decoder --help)",
    )

    parser.add_argument(
        "-o",
        "--output",
        metavar="OUTPUT.md",
        type=argparse.FileType("w"),
        default=sys.stdout,
        help="Location to emit markdown (Default: STDOUT)",
    )

    return parser.parse_args()


def parse_version(version_file):
    output = "".join(version_file.readlines()).strip()
    return output


def parse_help(help_file):
    output = defaultdict(list)
    modes = ["description", "usage", "options", "examples"]
    mode = 0  # default description mode

    is_block = lambda m: m == 2 or m == 3
    for line in help_file:
        # Set usage mode
        if line.startswith("Usage:"):
            mode = 1

        # Set options mode
        if line.strip().endswith("options:"):
            mode = 2
            line = f"{blockheading}{line.strip()[:-1]}\n{codeblock}"

        # Set example mode
        if line.startswith("Examples:"):
            mode = 3
            line = f"{blockheading}{line.strip()[:-1]}\n{codeblock}"

        # Empty line
        if not line.strip():
            # End block modes
            if is_block(mode):
                output[modes[mode]].append(codeblock)
                mode = -1
            # Skip empty
            continue

        # Append line to mode
        if mode >= 0:
            output[modes[mode]].append(line.strip())

    # Tidy up blocks
    if is_block(mode):
        output[modes[mode]].append(codeblock)

    # Join lines and return
    return {k: "\n".join(v) for k, v in output.items()}


def main():
    basepath = os.path.dirname(__file__)
    relative_template = "../docs/cmd/_template.tmp"

    args = parse_args()

    version = parse_version(args.versionfile)
    help = parse_help(args.helpfile)

    with open(os.path.join(basepath, relative_template), "r") as tpl:
        template = tpl.read()
        output = template.format_map(
            IgnoreMissing(command=args.name, version=version, **help)
        )
        print(output, file=args.output)


if __name__ == "__main__":
    main()
