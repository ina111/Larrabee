clear all
%--------------------------------
%	ペラ設定値
%--------------------------------
B = 2;							%ブレード数B
n = 100;						%分割数n
D = 3.2;						%ペラ直径D[m]
R = D / 2.0;					%ペラ半径R（Dから求まる）
dr = D / 2.0 / n;				%ペラ分割幅Δr（Dとnから求まる）
r = 0.1:dr:R;					%ペラ位置r（ベクトル）
rpm = 130;						%回転数[rpm]
Omega = rpm / 60 * 2 * pi;		%回転数Ω[rad/s]（rpmから求まる）
V = 7.2;						%機速[m/s]
rho = 1.184;					%空気密度ρ[kg/m^3]
nu = 1.540 * 10^(-5);			%動粘性係数ν[m^2/s]
T = 30;							%必要推力T[N]

%翼型のデータ。Clを決めて、それに対応するCdとalphaを入力
Cl = 0.8;							%（局所）揚力係数
Cd = 0.015;						%（局所）抗力係数
alpha_deg = 4;					%迎え角α[degree]

%-------------------------------
alpha = alpha_deg .* pi/180;		%迎え角α[rad]
DL = Cd ./ Cl;						%D/L：揚抗比の逆数
Tc = 2*T / (rho*V^2*pi*R^2);		%推力係数Tc

%--------------------------------
%	Betz & Prandtlの式
%--------------------------------
x = Omega .*r / V;					%局所進行率の逆数x(ベクトル）
sinphi = sqrt(1+x.^2).^(-1);		%sinphi :sin(phi)（ベクトル）
cosphi = x .* sqrt(1+x.^2).^(-1);	%cosphi :cos8phi)（ベクトル）
lambda = V / Omega / R;				%進行率λ（スカラー）
f = B/2 * sqrt(lambda^2 +1)/lambda *(1-r/R); %渦面間隔パラメータf(vortex sheet spacing parameter)（ベクトル）
F = 2/pi * acos(e.^(-f));			%Plandtlの渦間隔パラメータF（ベクトル）
G = F.*x.^2 ./ (1+x.^2);			%Betz & Prandtlの最小誘導損失のプロペラの循環関数G（ベクトル）

xi = r/R;							%無次元ペラ位置ξ（ベクトル）
dxi = 1/n;							%Δξ（スカラー）

%--------------------------------
%	Larrabeeの設計法(論文の式順序に従う)
%--------------------------------
%ζを出すための積分式I1,I2
% dI1 = G .* (1 - DL./x) .* xi * dxi;	
% dI2 = G .* (1 - DL./x) .*xi ./ (x.^2+1) * dxi;
% I1 = 4 * sum(dI1);
% I2 = 2 * sum(dI2);
dI1dxi = G .* (1 - DL./x) .* xi;
dI2dxi = G .* (1 - DL./x) .*xi ./ (x.^2+1);
I1 = 4 * trapz(xi,dI1dxi);
I2 = 2 * trapz(xi,dI2dxi);


%渦面移動速度比ζ（スカラー）
zeta = I1 / (2*I2) * (1 - sqrt(1 - (4*I2*Tc / I1^2)));	
%渦面移動速度v'（スカラー）vortex displacement velocity
vd = zeta * V;

%循環分布Γ（(6)式から）
Gamma = 2 * pi .*r * vd .* sinphi .* cosphi .* F / B;
ad = 0.5 * vd / V ./ (x.^2+1);		%a'

%平面図関数（=(c/R)*Cl/zeta）planform function
planform = 4*pi / B * lambda .*G ./ sqrt(1+x.^2);

chord = planform * zeta ./ Cl * R;	%コード長c
phi = atan(lambda ./xi * (1 + zeta/2));	%らせん角度Φ
beta = phi + alpha;					%ピッチ角β[rad]
beta_deg = beta *180/pi;			%ピッチ角β[deg]

dTdrL = rho * Omega .*r .* (1 - ad) * B .* Gamma;	%流入速度による局所推力
dTdr = dTdrL .* (1- DL./x);		%誘導速度考慮した局所推力（抗力方向の誘導速度成分によって局所推力が減少）
% dT = dTdr .*dr;					%ΔT
% T = sum(dT) * B					%推力T ブレード数考慮
T = trapz(r,dTdr)					%推力T 台形公式積分

epsilon = atan(DL);					%揚力vs抗力の角度ε[rad]
etae = tan(phi) ./ tan(phi+epsilon) .* (1/(1+0.5*zeta)); %ブレード要素での効率ηe

dTcdxi = 2 .* zeta * G .*(1-DL./x).*xi.*(2-zeta./(x.^2+1));	%dTc/dξ（(16)式）
% eta = sum(etae .* dTcdxi .*dxi / Tc);	%効率η
eta = trapz(xi,etae .* dTcdxi) /Tc		%効率η
dQdr = dTdr * V ./ (eta * Omega);		%局所トルク[Nm]
Q = T * V / (eta * Omega);				%トルク[Nm]
W = Q * Omega							%必要パワー[W]

Re = sqrt(V^2 + (Omega .*r .* (1-ad)).^2) .* chord /nu;	%レイノルズ数Re

%--------------------------------
% 	グラフ描写と画像書き出し
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
	print -dpng -r100 chord_pitch.png;
	
%推力とトルクのグラフ
figure(2)
	plot(r,dTdr,r,dQdr);
	ylabel('Thrust[N] , Torque[Nm]');
	xlim([0 R]);
	legend('Thrust[N]','Torque[Nm]');
	grid on;
	print -dpng -r100 thrust.png

%レイノルズ数のグラフ
figure(3)
	plot(r,Re);
	ylabel('Reinolds number');
	xlim([0 R]);
	grid on;
	print -dpng -r100 Re.png
