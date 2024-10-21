function [C_L, C_D] = viternamethod (UpReUpM, LoReUpM, UpReLoM, LoReLoM, dist, alfa)


Cl1 = polyfit(UpReUpM.pol.alpha,UpReUpM.pol.CL,3);
Cl2 = polyfit(UpReLoM.pol.alpha,UpReLoM.pol.CL,3);
Cl3 = polyfit(LoReUpM.pol.alpha,LoReUpM.pol.CL,3);
Cl4 = polyfit(LoReLoM.pol.alpha,LoReLoM.pol.CL,3);

Cd1 = polyfit(UpReUpM.pol.alpha,UpReUpM.pol.CD,3);
Cd2 = polyfit(UpReLoM.pol.alpha,UpReLoM.pol.CD,3);
Cd3 = polyfit(LoReUpM.pol.alpha,LoReUpM.pol.CD,3);
Cd4 = polyfit(LoReLoM.pol.alpha,LoReLoM.pol.CD,3);

Cl_alfa = Cl1*dist(1)*dist(2)+Cl2*dist(1)*(1-dist(2))+Cl3*(1-dist(1))*dist(2)+Cl4*(1-dist(1))*(1-dist(2));
Cd_alfa = Cd1*dist(1)*dist(2)+Cd2*dist(1)*(1-dist(2))+Cd3*(1-dist(1))*dist(2)+Cd4*(1-dist(1))*(1-dist(2));

C_l = polyval(Cl_alfa,alfa);
C_d = polyval(Cd_alfa,alfa);

xcrit = roots(polyder(Cl_alfa));  % set derivatives to 0
xcrit(imag(xcrit)~=0) = [];       % get rid of non-real solutions

j = 1;

if isempty(xcrit)
    alfa_s_aux(j) = 15;
else
    for i=1:length(xcrit)
        if alfa > 0 && xcrit(i) < 20
            alfa_s_aux(j) = xcrit(i);
            j = j+1;
        elseif alfa < 0 && xcrit(i) > -20
            alfa_s_aux(j) = xcrit(i);
            j = j+1;
        end
    end
end

if ~exist('alfa_s_aux','var')
    alfa_s_aux = 15;
end
    

for i = 1:length(alfa_s_aux)
    if alfa > 0
        alfa_s = max(alfa_s_aux);
    else
        alfa_s = min(alfa_s_aux);
    end
end

C_ls = polyval(Cl_alfa,alfa_s);
C_ds = polyval(Cd_alfa,alfa_s);
C_dm = polyval(Cd_alfa,alfa);

B1 = C_dm;
A1 = B1/2;
B2 = (C_ds-C_dm)*sind(alfa_s)^2/2;
A2 = (C_ls-C_dm*sind(alfa_s)*cosd(alfa_s))*sind(alfa_s)/(cosd(alfa_s)^2);

C_L = A1*sind(2*alfa)+A2*cosd(alfa)^2/sind(alfa);
C_D = B1*sind(alfa)^2+B2*cosd(alfa)^2;

end