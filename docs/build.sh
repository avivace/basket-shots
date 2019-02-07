#!/bin/bash

xelatex -8bit -shell-escape index
bibtex index
xelatex -8bit -shell-escape index
xelatex -8bit -shell-escape index
