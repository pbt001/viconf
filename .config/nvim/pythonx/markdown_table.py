#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Taken from markdown snippets.

Creates a table for a markdown file using UltiSnips.
"""
import os
import string

import vim


def create_table(snip):
    # retrieving single line from current string and treat it like tabstops count
    placeholders_string = snip.buffer[snip.line].strip()[2:].split("x",1)
    rows_amount = int(placeholders_string[0])
    columns_amount = int(placeholders_string[1])

    # erase current line
    snip.buffer[snip.line] = ''

    # create anonymous snippet with expected content and number of tabstops
    anon_snippet_title = ' | '.join(['$' + str(col) for col in range(1,columns_amount+1)]) + "\n"
    anon_snippet_delimiter = ':-|' * (columns_amount-1) + ":-\n"
    anon_snippet_body = ""
    for row in range(1,rows_amount+1):
        anon_snippet_body += ' | '.join(['$' + str(row*columns_amount+col) for col in range(1,columns_amount+1)]) + "\n"
    anon_snippet_table = anon_snippet_title + anon_snippet_delimiter + anon_snippet_body

    # expand anonymous snippet
    snip.expand_anon(anon_snippet_table)
