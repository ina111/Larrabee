%-------------------------------
%	計算部分
%-------------------------------
%-----初期計算
Omega = rpm / 60 * 2 * pi;		%回転数Ω[rad/s]（rpmから求まる）
xi = r./R;
lambda = V/Omega/R;

W = sqrt(V^2 + (xi.*R.*Omega).^2);
tanphi = (1 + zeta0(1,:)/2) .* lambda./xi;

%-----翼型性能読み込み
Relist = [10000 20000 30000 40000 50000 100000 	150000 200000 250000 300000 350000 400000];
alpha_list = linspace(0,10,100);
tic
for i = 1:12
	Cl_mat(i,:) = interp1(data_mat(:,1,i),data_mat(:,2,i),alpha_list,'linear',0);
	Cd_mat(i,:) = interp1(data_mat(:,1,i),data_mat(:,3,i),alpha_list,'linear',0);
%	Cd_mat(i,:) = interp1(data_mat(:,1,i),data_mat(:,3,i),alpha_list,'nearest');
end
%data = interp2(Relist,alpha_list,Cl_mat',Re,alpha);
toc

%-----収束計算
for i = 1:5
	phi = atan(tanphi);
	F = 2/pi .* acos( exp(-B/2.*(1-xi) ./ sin(lambda.*atan(1+zeta0(i,:)/2))) );
	
	Re = W.*chord / nu;
	alpha = beta - phi;
	alpha_deg = alpha *180/pi;
	
	%Cl = linspace(0.7,0.7,length(r));
	%Cd = linspace(0.01,0.01,length(r));
	tic
	for j = 1:length(r)
		Cl(j) = interp2(Relist,alpha_list,Cl_mat',Re(j),alpha_deg(j),'linear',0.1);
		Cd(j) = interp2(Relist,alpha_list,Cd_mat',Re(j),alpha_deg(j),'linear',0);
	end
	toc
	
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
dTdr = 0.5*rho.*W.^2*B.*chord.*Cy;
T = trapz(r,dTdr)
dQdr = 0.5*rho.*W.^2*B.*chord.*Cx.*r;
Q = trapz(r,dQdr)
Power = Q * Omega
eta = T*V/Power
