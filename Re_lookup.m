function data = Re_lookup(Re,Cl,ask,data_mat)
%-------------------------------------------------
%Cd = f(Re,Cl), alpha = f(Re,Cl)を求めるための関数
%ask = 1の時はCd, ask = 2の時はalpha
%
%ZI = interp2(X,Y,Z,XI,YI,method)
%(XI,YI,ZI)補間される,求める場所
%X=1:n, Y=1:m, size(Z)=[m,n]
%X = Relist, Y = Cllist, Z = data_matのask行列
%XI = Re, YI = Cl, ZI = data
%interp1のdefaultでは外挿ができずにNAが出ることがあるので'cubic'にする（計算時間がかかる)
%-------------------------------------------------

Relist = [10000 20000 30000 40000 50000 100000 	150000 200000 250000 300000 350000 400000];
Cllist = linspace(0,1.5,100);
if ask == 1
	for i = 1:12
		% Cd_mat_new(i,:) = interp1(data_mat(:,2,i),data_mat(:,3,i),Cllist);
		Cd_mat_new(i,:) = interp1(data_mat(:,2,i),data_mat(:,3,i),Cllist,'cubic',0);		
	end
	data = interp2(Relist,Cllist,Cd_mat_new',Re,Cl);
elseif ask == 2
	for i = 1:12
		% alpha_mat_new(i,:) = interp1(data_mat(:,2,i),data_mat(:,1,i),Cllist);
		alpha_mat_new(i,:) = interp1(data_mat(:,2,i),data_mat(:,1,i),Cllist,'cubic',0);
	end
	data = interp2(Relist,Cllist,alpha_mat_new',Re,Cl);
end
