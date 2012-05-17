clear all
tic
%-----条件入力
Larrabee_input

%-----XFLR5で解析したデータの読み込み
%データファイルが無い場合はコメントアウト
readXFLR

%-----CL,CD,迎え角の読み込み
%XFLR5の解析ファイルがある場合はLarrabee_airfoil
%ない場合や全く違う条件の時は_iniを使う。どちらかは必ずコメントアウト
%Larrabee_airfoil
Larrabee_airfoil_ini

%-----計算ルーチン
Larrabee_culc

%-----出力
Larrabee_output_fig		%グラフ描写と書き出し
Larrabee_output_result	%ファイルへの出力
Larrabee_output_cad		%CAD用にcsv出力
toc
