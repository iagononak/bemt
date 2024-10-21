function [eff, T, Q, eff_v, T_v,Q_v, B]  = bemt (geo)


% Universidade Federal de Uberlândia
% Faculdade de Engenharia Mecânica
% Graduação em Engenharia Aeronáutica
% ============= BEMT =============

%% PARÂMETROS DE INPUT
% Must input v_ax, Omega=rotational vel, height, Filename, B, 
V = 37.6;                 % Aircraft cruise speed[m/s]
v = 10:1:45; %[27.6 32.6 42.6]; %10:1:58; %[39 44 54];   %  Range of speeds[m/s::
Omega = 1600;           % Velocidade de rotação[RPM]
height = 0;          % height [m]

% Get propeller geometry
foils = ["NACA 0012", "NACA 4412","NACA 4415", "NACA 0015", "RAF 6X", "CLARK Y"];
for i=1:length(geo.section)
    geo.foil(i,1) = foils(geo.foil_n(i));
end
geo.r = geo.section(length(geo.section));
geo.Di = 2*geo.r;             % diameter [m]
B = geo.B;


% Conditions of flight
cond.height = height;
cond.V = V;
cond.Omega = Omega*2*pi/60;
[Temp,a,~,cond.rho] = atmosisa(height);
mi = (1.458e-6*Temp^(3/2))/(Temp+110.4);            % dynamic viscosity
cond.nu = mi/cond.rho;                                   % kinematic viscosity [m2/s]
cond.a = a;                                         % vel. Mach [m/s]

% Primeiros cálculos
%RPM = v_rot*2*pi/60;
%aero.v_rot = v_rot*pi*2*geo.section/60; %vel rot[m/s] % v_rot*pi*2*r/60*0.7; 0.7 pq o valor em polegadas
%aero.v = sqrt(aero.v_rot.^2+v_ax^2);
%Re = v*c/nu;
%v_Mach = v/a;

[J, eff, T, Q, CT, CQ, CP] = SinglePerformance (geo, cond); %(aero, geo, cond)

for i = 1:length(v)
    cond.V = v(i);
    [J_v(i), eff_v(i), T_v(i), Q_v(i), CT_v(i), CQ_v(i), CP_v(i)] = SinglePerformance (geo, cond); %(aero, geo, cond)
end

Jmax = max(J_v);
CTmax = max(CT_v);
Tmax = max(T);




end
