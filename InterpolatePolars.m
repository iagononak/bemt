function [C_l, C_d] = InterpolatePolars (UpReUpM, LoReUpM, UpReLoM, LoReLoM, dist, alfa)

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

end