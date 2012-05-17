%================================
%	Betz & Prandtlの式
%================================
%--------------------------------
%	x		:局所進行率の逆数x(ベクトル）
%	sinphi	:sin(phi)（ベクトル）
%	cosphi	:cos8phi)（ベクトル）
%	lambda	:進行率λ（スカラー）
%	f		:渦面間隔パラメータf(vortex sheet spacing parameter)（ベクトル）
%	F		:Plandtlの渦間隔パラメータF（ベクトル）
%	G		:Betz & Prandtlの最小誘導損失のプロペラの循環関数G（ベクトル）
%
%	xi		:無次元ペラ位置ξ（ベクトル）
%	dxi		:Δξ（スカラー）
%--------------------------------
%----論文(3)to(5)
x = Omega .*r / V;
sinphi = sqrt(1+x.^2).^(-1);
cosphi = x .* sqrt(1+x.^2).^(-1);

%----論文(6)to(9)
lambda = V / Omega / R;
f = B/2 * sqrt(lambda^2 +1)/lambda *(1-r/R);
F = 2/pi * acos(e.^(-f));
G = F.*x.^2 ./ (1+x.^2);

%----論文(17)
xi = r/R;
dxi = 1/n;

%================================
%	Larrabeeの設計法(論文の式順序に従う)
%================================
%--------------------------------
%	I1,I2	:ζを出すための積分式
%	dI1dxi	:dI1/dξ
%	dI2dxi	:dI2/dξ
%	zeta	:渦面移動速度比ζ（スカラー）
%	vd		:渦面移動速度v'（スカラー）
%
%	Gamma	:循環分布Γ（論文(6)式から）
%	ad		:a'
%	planform:平面図関数（=(c/R)*Cl/zeta）planform function
%	chord	:コード長c
%	phi		:らせん角度Φ
%	beta	:ピッチ角β[rad]
%	beta_deg:ピッチ角β[deg]
%
%	dTdrL	:流入速度による局所推力(dT/dr)_L
%	dTdr	:誘導速度考慮した局所推力（誘導速度成分によって局所推力が減少）dT/dr
%	dT		:ΔT（使わない)
%	T		:推力T
%
%	epsilon	:揚力vs抗力の角度ε[rad]
%	etae	:ブレード要素での効率ηe
%	dTcdxi	:dTc/dξ（論文(16)式）
%	eta		:効率η(<1)
%	dQdr	:局所トルクdQ/dr[Nm]
%	Q		:トルクQ[Nm]
%	W		:必要パワーW[W]
%	Re		:レイノルズ数Re
%--------------------------------
%----論文(18)to(21)
% dI1 = G .* (1 - DL./x) .* xi * dxi;	
% dI2 = G .* (1 - DL./x) .*xi ./ (x.^2+1) * dxi;
% I1 = 4 * sum(dI1);
% I2 = 2 * sum(dI2);
dI1dxi = G .* (1 - DL./x) .* xi;
dI2dxi = G .* (1 - DL./x) .*xi ./ (x.^2+1);
I1 = 4 * trapz(xi,dI1dxi);
I2 = 2 * trapz(xi,dI2dxi);
zeta = I1 / (2*I2) * (1 - sqrt(1 - (4*I2*Tc / I1^2)));	
vd = zeta * V;

%----論文(6),(11)
Gamma = 2 * pi .*r * vd .* sinphi .* cosphi .* F / B;
ad = 0.5 * vd / V ./ (x.^2+1);

%----論文(24)to(26)
planform = 4*pi / B * lambda .*G ./ sqrt(1+x.^2);
chord = planform * zeta ./ Cl * R;
phi = atan(lambda ./xi * (1 + zeta/2));
beta = phi + alpha;
beta_deg = beta *180/pi;

%----論文(12)to(14)
dTdrL = rho * Omega .*r .* (1 - ad) * B .* Gamma;
dTdr = dTdrL .* (1- DL./x);
% dT = dTdr .*dr;
% T = sum(dT) * B
T = trapz(r,dTdr)

%----論文(28),(29),(16)
epsilon = atan(DL);
etae = tan(phi) ./ tan(phi+epsilon) .* (1/(1+0.5*zeta));
dTcdxi = 2 .* zeta * G .*(1-DL./x).*xi.*(2-zeta./(x.^2+1));
% eta = sum(etae .* dTcdxi .*dxi / Tc);	%効率η
eta = trapz(xi,etae .* dTcdxi) /Tc;
dQdr = dTdr * V ./ (eta * Omega);
Q = T * V / (eta * Omega);
W = Q * Omega

Re = sqrt(V^2 + (Omega .*r .* (1-ad)).^2) .* chord /nu;
