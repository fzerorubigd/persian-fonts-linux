Persian fonts for linux
=======================

This script, download and install persian fonts on any linux distro.

There is two version available :

   - farsifont.sh : simple cli version
   - zfarsifont.sh : GUI version (require zenity)

See http://fzerorubigd.github.com/persian-fonts-linux

# Available fonts

1) Vazir
2) FarsiFonts
3) BFonts
4) IranianSans
5) IranNastaliq
6) FPF
7) Lalezar
8) NotoNaskh
9) NotoKufi
10) XBZar
11) XBNilufar
12) XBKhoramshahr
13) XBKayhan
14) XBYaghout
15) XBRiyaz
16) XBRoya
17) XBShafigh
18) XBShafighKurd
19) XBShafighUzbek
20) XBShiraz
21) XBSols
22) XBTitr
23) XBTabriz
24) XBTraffic
25) XBVahid
26) XBVosta
27) XBYermook
28) XBYas
29) XBZiba
30) Tahoma
31) Samim
32) Shabnam
33) Sahel
34) VazirCode
35) Tanha
36) Nahid
37) Parastoo

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
