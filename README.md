Larrabee
====

プロペラ設計プログラムです。誘導損失最小のプロペラが設計できます。

E.E.Larrabeeの設計法です。

Larrabeeの方法ではＰｒａｎｄｔｌの理論を用いていて、円盤荷重が０のときに厳密に成立し、
低円盤荷重のプロペラに適応しても誤差が生じないと言われています。

高円盤荷重の時には適さないので注意してください。



概要
----
Octaveで書いています。おそらくMatlabでも動くと思います。

Simple-Larrabeeフォルダに入っているのは簡単に計算するための.mファイルが入っています。

メインの方の使い方はOctave(Matlab)からLarrabee.mを読み込んでください。
$ Larrabee
とするだけです。Larrabee_***.mのファイルはLarrabee.mのサブルーチンです。
Larrabee.mのそれぞれのサブルーチンをコメントアウトすることによってそれぞれの機能の
有無を設定できます。
'Larrabee_input'、'Larrabee_airfoil_ini''Larrabee_culc'だけ回せば動きます。
Larrabee_input.mの中身がプロペラの設定値なので書き換えてください。

その他、そのうち書く予定

更新予定
----
* CAD出力部
* 翼型の解析データをフォルダに置いて読み込み
* ソースと翼型と結果出力のフォルダは分けるべき？

参考文献
----
Larrabee.E.,"Practical Design of Minimum Induced Loss Propellers,"SAE Technical Paper 790585, 1979, doi:10.4271/790585

