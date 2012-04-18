%--------------------------------
% 	Larrabeeグラフ描写と画像書き出し
%--------------------------------

%コード長とピッチ角のグラフ
figure(1);
	subplot(2,1,1);
		plot(r,chord*1000);
		xlabel('r');
		ylabel('chord[mm]');
		xlim([0 R]);
		grid on;

	subplot(2,1,2);
		plot(r,beta_deg);
		xlabel('r');
		ylabel('beta[deg]');
		xlim([0 R]);
		grid on;
	%-r100は解像度を100dpiにする。文字を大きくするために100dpi
	print -dpng -r100 result/chord_pitch.png;
	
%推力とトルクのグラフ
figure(2)
	plot(r,dTdr,r,dQdr);
	ylabel('Thrust[N] , Torque[Nm]');
	xlim([0 R]);
	legend('Thrust[N]','Torque[Nm]');
	grid on;
	print -dpng -r100 result/thrust.png

%レイノルズ数のグラフ
figure(3)
	plot(r,Re);
	ylabel('Reinolds number');
	xlim([0 R]);
	grid on;
	print -dpng -r100 result/Re.png
