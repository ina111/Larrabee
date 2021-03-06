%--------------------------------
% Larrabee計算結果のファイルへの保存
%--------------------------------

%次の計算にReを受け渡すためにReの値を'var_Re.mat'ファイルに保存
save var_Re.mat Re

% 出力ファイル名
result_filename = 'result/result.txt';

% 低レベルファイル入出力でファイル操作
fid = fopen(result_filename, 'wt');		%テキストモードで開く
fprintf(fid,'%s\n',datestr(now,31));	%時刻 nowの31番フォーマットyyyy-mm-dd...
fprintf(fid,'ブレード数\t:%d\n',B);
fprintf(fid,'分割数n\t\t:%d\n',n);
fprintf(fid,'ペラ半径\t:%.1f[m]\n',R);
fprintf(fid,'ペラ開始位置\t:%.1f[m]\n',r(1));
fprintf(fid,'回転数\t\t:%d[rpm]\n',rpm);
fprintf(fid,'機速\t\t:%.1f[m/s]\n',V);
fprintf(fid,'空気密度\t:%.2f[kg/m^3]\n',rho);
fprintf(fid,'動粘性係数\t:%.2e[m^2/s]\n',nu);
% fprintf(fid,'',); %CL,CD,alpha
% fprintf(fid,'',);
% fprintf(fid,'',);
fprintf(fid,'- - - - - - - - - - - - - - - - -\n');
fprintf(fid,'推力T\t\t= %.1f[N]\n',T);
fprintf(fid,'トルクQ\t\t= %.1f[Nm]\n',Q);
fprintf(fid,'必要パワーW\t= %.1f[W]\n',W);
fprintf(fid,'効率η\t\t= %.2f[%%]\n',eta*100);

fclose(fid);
