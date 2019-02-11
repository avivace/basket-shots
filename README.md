# Basket Shots

### _Predicting Basket Shots outcomes using SVM_

By [Matteo Coppola](https://github.com/matteocoppola), [Luca Palazzi](https://github.com/lucapalazzi), [Antonio Vivace](https://github.com/avivace).

Data Technology and Machine Learning (CS MSc) exam final project. Academic year 2018/2019.

[Documentation](https://github.com/avivace/basket-shots/raw/master/docs/index.pdf)

[Slides](https://github.com/avivace/basket-shots/raw/master/Presentazione.pdf)

<br>

--- 

<br>

Datasets are hosted using Git LFS. Before cloning this repository, be sure to have it installed.

### Documentation

#### Requirements

A lot of additional TeX packages are used. Inkscape must be installed and available in the PATH.

On Debian systems: `sudo apt install texlive-full inkscape`.
The Python 3 package `Pygment` is needed and `pygmentize` must available in the PATH.

```
pip3 install Pygments
# Check if it's available
pygmentize -V
```

Build:

```bash
cd docs/
./build.sh
```
