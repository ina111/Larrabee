Larrabee
====

プロペラ設計プログラムです。誘導損失最小のプロペラが設計できます。
E.E.Larrabeeの設計法です。

Larrabeeの方法ではPrandtlの理論を用いていています。
円盤荷重が０のときに厳密に成立し、低円盤荷重のプロペラに適応しても
誤差が生じないと言われています。

高円盤荷重の時には適さないので注意してください。


概要
----
Octaveで書いています。おそらくMatlabでも動くと思います。

Simple-Larrabeeフォルダに入っているのは簡単に計算するための.mファイルが入っています。
ややこしいことせずに論文のまま素直に書き下したものです。自分でLarrabee.mファイルの中身を編集してOctave上から`$ Larrabee`と打ち込んでください。

メインの方の使い方もOctave(Matlab)からLarrabee.mを読み込んでください。
`$ Larrabee`
とするだけです。Larrabee_***.mのファイル群はLarrabee.mのサブルーチンです。
Larrabee.m内のそれぞれのサブルーチンをコメントアウトすることによってそれぞれの機能の
有無を設定できます。

* 'Larrabee_input'
* 'Larrabee_airfoil_ini'
* 'Larrabee_culc'

だけ回せば動きます。
Larrabee_input.mの中身がプロペラの設定値なので求めたい条件に書き換えてください。

ファイルの内容
----
#### Larrabee.m
 実行すべきmファイル。ここから以下の各々のサブルーチンを実行する。

#### Larrabee_input.m
: プロペラの設定値を決める。ここの値を変えることで様々な条件のプロペラが設計できる。

#### readXFLR
 XFLR５で解析したairfoilフォルダ内のtxtフィイルを読み込み、
data_matという多次元配列に代入する。
例えば、'pelafoil\_T1\_Re0.01\_M0.00\_N9.0.txt'のようなファイルが必要。
それぞれの翼型に変えたければ中身のfoil_nameの値を変える。
レイノルズ数の数や値を変えたければRelistを変える。レイノルズ数は使用する領域より幅広く取ってやるとエラーが少なくなる。

#### Larrabee_airfoil.m
 Larrabee\_airfoil_ini.mではCd（抗力係数）とalpha（迎え角）を自分で決めるが、readXFLR.mで翼型の解析データが読み込めればCdとalphaをCl（揚力係数）とRe（レイノルズ数）の2変数関数と置いて、(Cd = f(Re,Cl), alpha = f(Re,Cl))自分で決めたClの値と前回の計算から持ってきたReからCd、alphaを求める。

#### Larrabee\_airfoil_ini.m
 Reの範囲がreadXFLRで読み込んだ値を越える場合は外挿ができないためにエラーが出るので、こちらを用いる。自分でCdとalphaの値を指定する。

#### Larrabee_culc.m
 計算部分

#### Larrabee_output_fig.m
 図として出力する。出力された図はresultフォルダに保存される。

#### Larrabee_output_result.m
 計算された結果をresultフォルダのresult.txtに保存する。

#### Larrabee_output_cad.m
 設計されたプロペラを３DCAD上で表示するためにCADデータをcsvなどで保存する。
SolidWorksに対応予定。翼型はairfoil内にある翼型.datファイルを読み込む。
未実装。

#### Re_lookup.m
 Larrabee\_airfoil.mでCd、	alphaの値を補完するための関数。
interp1,interp2関数を用いて補完している。要改良。

更新予定
----
* CAD出力部
* Re_lookupを改良
* 翼型データを変更

参考文献
----
Larrabee.E.,"Practical Design of Minimum Induced Loss Propellers,"SAE Technical Paper 790585, 1979, doi:10.4271/790585

