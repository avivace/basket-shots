# Basket Shots

### _Predicting Basket Shots outcomes using SVM_

By [Matteo Coppola](), [Luca Palazzi](), [Antonio Vivace](https://github.com/avivace).

Data Technology and Machine Learning (CS MSc) exam final project. Academic year 2018/2019.

[Documentation]()

[Slides]()

<br>

--- 

<br>

Datasets are hosted using Git LFS. Before cloning this repository, be sure to have it installed.

### Documentation

#### Requirements

A lot of additional TeX packages are used. On Debian systems: `sudo apt install texlive-full`.

The Python 3 package `Pygment` is needed and `pygmentize` must available in the PATH.

```
pip3 install Pygments
# Check if it's available
pygmentize -V
```

Build:

```bash
cd docs/
xelatex -8bit -shell-escape index.tex
```
