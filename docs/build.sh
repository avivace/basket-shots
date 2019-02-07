#!/bin/bash

rm *.aux
rm *.bbl
rm *.blg
rm *.log
rm *.out
rm *.toc

xelatex -8bit -shell-escape index
bibtex index
xelatex -8bit -shell-escape index
xelatex -8bit -shell-escape index
