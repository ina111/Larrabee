%xflr5空力解析データの読込
Relist = {'0.010' '0.020' '0.030' '0.040' '0.050' '0.100'...
 '0.150' '0.200' '0.250' '0.300' '0.350' '0.400'};
for i=1:12
	%mはフィイル数
	
	%読み取るファイルの名前を定義
	foil_name = 'pelafoil';
	datafile_1 = '_T1_Re';
	datafile_2 = Relist{i};
	datafile_3 = '_M0.00_N9.0.txt';
	dataname = strcat(foil_name,datafile_1,datafile_2,datafile_3);
	
	fpr=fopen(dataname);		%ファイルオープン
	%解析データの部分までbufferで読み取ってスキップさせる
	while(true)
		buffer=fscanf(fpr,'%c',[1,1]);
		if buffer == '-';
			break;
		end
	end
	buffer=fgetl(fpr);
	%data_matの多次元配列に読み取ったものを入れている
	%data_mat(行,列,ファイル番号)
	if i == 1
		data_mat = (fscanf(fpr,'%f',[10,100]))';
	else
		data_mat(:,:,i) = (fscanf(fpr,'%f',[10,100]))';
	end
	fclose(fpr);
end