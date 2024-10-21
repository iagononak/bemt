function [J, eff, T, Q, CT, CQ, CP] = SinglePerformance (geo, cond)

c_mean = max(geo.chord);
sigma = geo.B*c_mean/(2*pi*geo.r);                      % blade solidity
r = geo.r;
c = geo.chord;
xi = geo.section/r;
% m = xi(find(geo.chord==max(geo.chord)));
% n = length(geo.section);
H = geo.pitch;                                          % geometrical pitch
rps = cond.Omega/(2*pi);
J = cond.V/(rps*geo.r*2);
% cond.J = J;
% syms K K1 k_P

W_new = sqrt((cond.V^2+(geo.section'*cond.Omega).^2));
phi_old = ones(length(geo.chord),1);                      % Local airspeed old value
% phi = geo.phi';% Local airspeed new value
epsilon = sum(abs(phi_old-geo.phi));                        % Difference of local airspeed betweeen iterations


% Loop conditions
epsilon_max = 1e-3;                    % airspeed difference variable to stop the code
iter_max = 50;
iter = 1;
T = 0;
Q = 0;

while epsilon > epsilon_max && iter < iter_max
    for i = 1:length(geo.chord)-1
        cond.Re = W_new(i)*c(i)/cond.nu;
        cond.M = W_new(i)/cond.a;
%         k_P = 2/pi*acos(exp(-n/2*(1-xi(i))*sqrt(1+(cond.Omega*R/cond.V)^2)));
        phi_t = atand(xi(i)*tand(geo.phi(i)));
        f = geo.B/2*(1-xi(i))/sind(phi_t);
        
%         if iter == 1
        alfa =  geo.pitch(i) - geo.phi(i); % angle of attack from each element
        alfa_aux(i) = alfa;
%         else
%             alfa = atand(K(i)*sind(geo.phi(i))*cosd(geo.phi(i))/(1+K(i)*(cosd(geo.phi(i)^2))));
%         end
        [C_x] = C_X(geo,cond, alfa, i);
        [C_y, C_l(i), C_d(i)] = C_Y(geo,cond,alfa, i);
        
        F(i) = 2*acos(exp(-f))/pi;
        
        K(i) = C_y / (4*sind(geo.phi(i))^2);
        geo.K(i) = K(i);
        K1(i) = C_x / (4*cosd(geo.phi(i))*sind(geo.phi(i)));
        
        a_x(i) = sigma*K(i)/(F(i)-sigma*K(i));
        a_y(i) = sigma*K1(i)/(F(i)+sigma*K1(i));
        
%         geo.phi(i) = atan(J/xi(i)*(1+K(i)));
        geo.phi(i) = atand(cond.V*(1+a_x(i))/(geo.section(i)*cond.Omega*(1-a_y(i))));
    end
    geo.phi(length(geo.chord)) = phi_t;
    
%     W = W_new;
    a_x(length(geo.section)) = 1;
    a_y(length(geo.section)) = 0;
    C_l(length(geo.section)) = C_l(length(geo.section)-1);
    C_d(length(geo.section)) = C_d(length(geo.section)-1);
    
%     geo.phi(length(geo.section)) = geo.phi(length(geo.section)-1)/2;
    W_new = sqrt((cond.V*(1+a_x)).^2+((1-a_y).*geo.section'*cond.Omega).^2);   
    
    epsilon = sum(abs(geo.phi-phi_old));
    phi_old = geo.phi;
    iter = iter+1;
end

%C_d = abs(C_d);
dT = cond.rho*(W_new.^2/2).*(C_l.*cosd(geo.phi')-C_d.*sind(geo.phi'))*geo.B.*c';
dQ = cond.rho*(W_new.^2/2).*(C_l.*sind(geo.phi')+C_d.*cosd(geo.phi'))*geo.B.*c'.*geo.section';



%test


for i=1:length(dT)-1
    %if i == 1
        %parc_dQ =dQ(i)*2*geo.section(i)/2;
        %Q = Q + parc_dQ;
    %end
    parc_dT = (dT(i)+dT(i+1))*(geo.section(i+1)-geo.section(i))/2;
    T = T + parc_dT;
    parc_dQ = (dQ(i)+dQ(i+1))*(geo.section(i+1)-geo.section(i))/2;
    Q = Q + parc_dQ;
end



CT = T/(cond.rho*rps^2*(2*geo.r)^4);
CQ = Q/(cond.rho*rps^2*(2*geo.r)^5);
CP = 2*pi*CQ;


Power = Q*cond.Omega;
eff = T*cond.V/Power;

%eff2 = J*CT/CP;

end