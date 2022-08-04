Persian fonts for linux
=======================

This script downloads and installs Persian fonts on any linux distro.

There are two versions available :

   - farsifont.sh : simple CLI version
   - zfarsifont.sh : GUI version (requires zenity)

See http://fzerorubigd.github.com/persian-fonts-linux

## Installation 

You can run the script directly from your shell (it's wise to check the script before running the command) :

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/fzerorubigd/persian-fonts-linux/master/farsifonts.sh)"
```

## Available fonts

- Vazir
- FarsiFonts
- BFonts
- IranianSans
- IranNastaliq
- FPF
- Lalezar
- XBZar
- XBNilufar
- XBKhoramshahr
- XBKayhan
- XBYaghout
- XBRiyaz
- XBRoya
- XBShafigh
- XBShafighKurd
- XBShafighUzbek
- XBShiraz
- XBSols
- XBTitr
- XBTabriz
- XBTraffic
- XBVahid
- XBVosta
- XBYermook
- XBYas
- XBZiba
- Tahoma
- Samim
- Shabnam
- Sahel
- VazirCode
- Tanha
- Nahid
- Parastoo

## Getting started

In the TeX file, include:

```
\usepackage{xepersian}
\usepackage{fontspec}
\settextfont[Scale=1]{IranNastaliq}
\setlatintextfont[Scale=1]{TeX Gyre Termes}
```

```
xelatex <TeX file>
```
