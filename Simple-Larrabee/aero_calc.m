clear zeta0;
tic
%-------------------------------
%	条件入力
%-------------------------------
%R,B,r,chord,beta,は引き継ぎ
rpm = 150;						%回転数[rpm]
Omega = rpm / 60 * 2 * pi;		%回転数Ω[rad/s]（rpmから求まる）
V = 7.0;						%機速[m/s]
rho = 1.184;					%空気密度ρ[kg/m^3]
nu = 1.540 * 10^(-5);			%動粘性係数ν[m^2/s]
zeta0(1,:) = linspace(0.2,0.2,length(r));

%-----翼型性能読み込み(degで計算)
Cl0 = 0.47;
Cla = 0.1;
Mach =0;

Cd0 = 0.0105;
Cd2 = 0.004;
ClCd0 = 0.4;
Reref = 200000;
Reexp = -0.5;
%Cl = Cl0 + Cla*alpha /Prandl_Mayer
%Cd = Cd0 + Cd2*(Cl-ClCd0)^2 * (Re/Reref)^Reexp
Prandl_Mayer = sqrt(1-Mach^2);

%-------------------------------
%	計算部分
%-------------------------------
%-----初期計算
xi = r./R;
lambda = V/Omega/R;

W = sqrt(V^2 + (xi.*R.*Omega).^2);
tanphi = (1 + zeta0(1,:)/2) .* lambda./xi;



%-----収束計算
for i = 1:10
	phi = atan(tanphi);
	F = 2/pi .* acos( exp(-B/2.*(1-xi) ./ sin(lambda.*atan(1+zeta0(i,:)/2))) );
	
	Re = W.*chord / nu;
	alpha = beta - phi;
	alpha_deg = alpha *180/pi;
	
	%ClとCdを出す
	Cl = Cl0 + Cla*alpha_deg /Prandl_Mayer;
	Cd = Cd0 + Cd2.*(Cl-ClCd0).^2 .* (Re/Reref).^Reexp;
	
	epsilon = Cd ./ Cl;
	Cy = Cl .* (cos(phi) - epsilon.*sin(phi));
	Cx = Cl .* (sin(phi) + epsilon.*cos(phi));
	K  = Cy ./ (4*sin(phi).^2);
	Kd = Cx ./ (4*cos(phi).*sin(phi));
	sigma = B * chord ./ (2*pi.*xi*R);
	a  = sigma .* K  ./ (F - sigma.*K);
	ad = sigma .* Kd ./ (F + sigma.*Kd);
	
	W = sqrt(V^2 .*(1+a).^2 + (Omega.*xi*R).^2.*(1-ad).^2);
	tanphi = V.*(1+a) ./ (Omega.*xi.*R.*(1-ad));
	zeta0(i+1,:) = 2 .*a./cos(phi).^2 ./(1-epsilon.*tan(phi));
end

%-----推力・トルク・効率計算
dTdr = 0.5*rho.*W.^2.*chord.*Cy;
T = B * trapz(r,dTdr)
dQdr = 0.5*rho.*W.^2.*chord.*Cx.*r;
Q = B * trapz(r,dQdr)
Power = Q * Omega
eta = T*V/Power

toc
