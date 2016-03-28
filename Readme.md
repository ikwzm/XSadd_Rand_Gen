XORSHIFT-ADD (xsadd) Pseudo Random Number Generator VHDL Package and RTL.
-------------------------------------------------------------------------

###概要###
XORSHIFT-ADD(xsadd)法による擬似乱数生成パッケージと論理合成可能なサンプル回路です。

こちらを参考に書いてみました。
XORSHIFT_ADD(XSadd): A variant of XORSHIFT(<http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/XSADD/index-jp.html>)

単精度の浮動小数点はサポートしていません。32ビット整数か実数のみです。

xsadd.vhd は擬似乱数生成パッケージです。

xsadd_gen.vhd は論理合成可能なサンプルの擬似乱数生成回路です。

###シミュレーション###

シミュレーションには GHDL (<http://ghdl.free.fr/>) を使いました。    
Makefile を用意したので、make コマンド一発でシミュレーションが走ります。もしかしたら他のシミュレーションでは走らないかもしれません。その際はご一報ください。

###論理合成###

xsadd_gen.vhd は論理合成可能な擬似乱数生成回路です。

テーブルはリセット時にデフォルトの値がセットされます。

また、外部からの書き込みによるテーブルの初期化も可能です。

論理合成は Xilinx 社 ISE13.1 使いました。

###ライセンス###

二条項BSDライセンス (2-clause BSD license) で公開しています。

###謝辞###

このような貴重なアルゴリズムを惜しげもなく公開してくださった方々にはひたすら感謝です。
