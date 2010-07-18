Accessible River Timetable
==========================

A parser/generator to turn the rather inaccessible PDF-formatted Thames Clippers timetable into HTML.

Usage
-----

Extract the text from the [commuter service PDF](http://www.thamesclippers.com/routes-times-prices-booking/timetables-prices.html)

    pdftotext -layout timetable.pdf

Convert to HTML

    ruby convert.rb < timetable.txt > index.html

Tweak `timetable.txt` to fix any columns that are out of alignment and repeat until happy.

Prerequisites
-------------

* `pdftotext` from the `xpdf` suite.
* `detabulator` (gem) to parse the tabular text into columns.
* `builder` (gem) to generate the tables.
* `haml` (gem) and one of the many Markdown parsers to format the page HTML.
