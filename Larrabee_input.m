%--------------------------------
%	ペラ設定値
%--------------------------------
B = 2;							%ブレード数B
n = 100;						%分割数n
D = 3.2;						%ペラ直径D[m]
R = D / 2.0;					%ペラ半径R（Dから求まる）
dr = D / 2.0 / n;				%ペラ分割幅Δr（Dとnから求まる）
r = 0.1:dr:R;					%ペラ位置r（ベクトル）
rpm = 120;						%回転数[rpm]
Omega = rpm / 60 * 2 * pi;		%回転数Ω[rad/s]（rpmから求まる）
V = 7.0;						%機速[m/s]
rho = 1.184;					%空気密度ρ[kg/m^3]
nu = 1.540 * 10^(-5);			%動粘性係数ν[m^2/s]
T = 26;							%必要推力T[N]

Cl = linspace(0.6,0.6,length(r));	%局所揚力係数Cl,数字2つは始点と終点の揚力係数