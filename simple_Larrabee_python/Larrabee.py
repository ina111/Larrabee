import numpy as np
import matplotlib.pyplot as plt

# 入力===============================
# プロペラ設計条件
num_blade = 2       # ブレード数B
num_div = 100       # 分割数n
dia = 3.2           # ペラ直径D[m]
rpm = 130           # 回転数[rpm]
vel = 7.2           # 機速[m/s]
thrust = 30         # 必要推力thrust[N]

# 翼型データ。Clを決めて、それに対応するCdとalphaを入力
coef_lift = 0.8     # 局所揚力係数Cl
coef_drag = 0.014   # 局所抗力係数Cd
alpha_deg = 3       # 迎角α[deg]

# 環境条件
rho = 1.184         # 空気密度ρ[kg/m^3]
nu = 1.540e-5       # 動粘性係数ν[m^2/s]
# 入力ここまで===============================

radius = dia / 2.0  # ペラ半径R[m]
dr = dia / 2.0 / num_div    # 分割幅Δr[m]
r = np.arange(0.1, radius + dr, dr)  # ペラ位置r[m]
omega = rpm / 60 * 2 * np.pi    # 回転数Ω[rad/s]
alpha = alpha_deg * np.pi / 180  # 迎角α[rad]
drag_lift_ratio = coef_drag / coef_lift  # 揚抗比L/Dの逆数
Tc = 2 * thrust / (rho * vel**2 * np.pi * radius**2)  # 推力係数Tc

# ================================
# 	Betz & Prandtlの式
# ================================
# --------------------------------
# 	x		:局所進行率の逆数x
# 	sinphi	:sin(phi)
# 	cosphi	:cos8phi)
# 	lambda	:進行率λ（スカラー）
# 	f		:渦面間隔パラメータf(vortex sheet spacing parameter)
# 	F		:Plandtlの渦間隔パラメータF
# 	G		:Betz & Prandtlの最小誘導損失のプロペラの循環関数G

# 	xi		:無次元ペラ位置ξ
# 	dxi		:Δξ（スカラー）
# --------------------------------

# ----論文(3)to(5)
x = omega * r / vel
sinphi = np.sqrt(1 + x**2)**(-1)
cosphi = x * np.sqrt(1 + x**2)**(-1)

# ----論文(6)to(9)
lambda_val = vel / omega / radius
f = num_blade / 2 * np.sqrt(lambda_val**2 + 1) / lambda_val * (1 - r / radius)
F = 2 / np.pi * np.arccos(np.clip(np.exp(-f), -1, 1))
G = F * x**2 / (1 + x**2)

# ----論文(17)
xi = r / radius
dxi = 1 / num_div

# ================================
# 	Larrabeeの設計法(論文の式順序に従う)
# ================================
# --------------------------------
# 	I1,I2	:ζを出すための積分式
# 	dI1dxi	:dI1/dξ
# 	dI2dxi	:dI2/dξ
# 	zeta	:渦面移動速度比ζ（スカラー）
# 	vd		:渦面移動速度v'（スカラー）

# 	Gamma	:循環分布Γ（論文(6)式から）
# 	ad		:a'
# 	planform:平面図関数（=(c/R)*Cl/zeta）planform function
# 	chord	:コード長c
# 	phi		:らせん角度Φ
# 	beta	:ピッチ角β[rad]
# 	beta_deg:ピッチ角β[deg]

# 	dTdrL	:流入速度による局所推力(dT/dr)_L
# 	dTdr	:誘導速度考慮した局所推力（誘導速度成分によって局所推力が減少）dT/dr
# 	dT		:ΔT（使わない)
# 	T		:推力T

# 	epsilon	:揚力vs抗力の角度ε[rad]
# 	etae	:ブレード要素での効率ηe
# 	dTcdxi	:dTc/dξ（論文(16)式）
# 	eta		:効率η(<1)
# 	dQdr	:局所トルクdQ/dr[Nm]
# 	Q		:トルクQ[Nm]
# 	W		:必要パワーW[W]
# 	Re		:レイノルズ数Re
# --------------------------------

# ----論文(18)to(21)
dI1dxi = G * (1 - drag_lift_ratio / x) * xi
dI2dxi = G * (1 - drag_lift_ratio / x) * xi / (x**2 + 1)
I1 = 4 * np.trapz(dI1dxi, xi)
I2 = 2 * np.trapz(dI2dxi, xi)
zeta = I1 / (2 * I2) * (1 - np.sqrt(1 - (4 * I2 * Tc / I1**2)))
vd = zeta * vel

# ----論文(6),(11)
Gamma = 2 * np.pi * r * vd * sinphi * cosphi * F / num_blade
ad = 0.5 * vd / vel / (x**2 + 1)

# ----論文(24)to(26)
planform = 4 * np.pi / num_blade * lambda_val * G / np.sqrt(1 + x**2)
chord = planform * zeta / coef_lift * radius
phi = np.arctan(lambda_val / xi * (1 + zeta / 2))
beta = phi + alpha
beta_deg = beta * 180 / np.pi

# ----論文(12)to(14)
dTdrL = rho * omega * r * (1 - ad) * num_blade * Gamma
dTdr = dTdrL * (1 - drag_lift_ratio / x)
T = np.trapz(dTdr, r)

# ----論文(28),(29),(16)
epsilon = np.arctan(drag_lift_ratio)
etae = np.tan(phi) / np.tan(phi + epsilon) * (1 / (1 + 0.5 * zeta))
dTcdxi = 2*zeta * G * (1 - drag_lift_ratio / x) * xi * (2 - zeta / (x**2 + 1))
eta = np.trapz(etae * dTcdxi, xi) / Tc
dQdr = dTdr * vel / (eta * omega)
Q = T * vel / (eta * omega)
W = Q * omega

Re = np.sqrt(vel**2 + (omega * r * (1 - ad))**2) * chord / nu

# 出力================================
print("---- 入力値 ----")
print(f"ブレード数B = {num_blade} [本]")
print(f"プロペラ直径D = {2 * radius:.2f} [m]")
print(f"プロペラ回転数n = {rpm} [rpm]")
print(f"機体速度V = {vel:.2f} [m/s]")
print(f"空気密度ρ = {rho:.2f} [kg/m^3]")
print(f"動粘性係数μ = {nu:.2e} [m^2/s]")
print(f"必要推力Tc = {thrust:.2f} [N]")
print("---- 計算結果 ----")
print(f"推力T = {T:.2f} [N]")
print(f"トルクQ = {Q:.2f} [Nm]")
print(f"必要パワーW = {W:.1f} [W]")
print(f"効率η = {eta*100:.1f} [%]")

# コード長とピッチ角のグラフ
fig, (ax1, ax2) = plt.subplots(2, 1)
ax1.plot(r, chord * 1000)
ax1.set_ylabel('chord [mm]')
ax1.set_xlim([0, radius])
ax1.grid()

ax2.plot(r, beta_deg)
ax2.set_xlabel('r [m]')
ax2.set_ylabel('beta [deg]')
ax2.set_xlim([0, radius])
ax2.grid()

plt.tight_layout()
fig.savefig('chord_pitch.png')

# 推力とトルクのグラフ
plt.figure()
plt.plot(r, dTdr, label='Thrust [N]')
plt.plot(r, dQdr, label='Torque [Nm]')
plt.xlabel('r [m]')
plt.ylabel('Thrust [N] , Torque [Nm]')
plt.xlim(0, radius)
plt.legend()
plt.grid()
plt.tight_layout()
plt.savefig('thrust.png')

# レイノルズ数のグラフ
plt.figure()
plt.plot(r, Re)
plt.xlabel('r [m]')
plt.ylabel('Reinolds number [-]')
plt.xlim(0, radius)
plt.grid()
plt.tight_layout()
plt.savefig('Re.png')

plt.show()
