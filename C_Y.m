function [C_y, C_L, C_D] = C_Y (geo, cond,alfa, i)


alfa =  geo.pitch(i) - geo.phi(i); % angle of attack from each element

if alfa > -8 && alfa < 20
   [UpReUpM, LoReUpM, UpReLoM, LoReLoM, dist] = SearchPolars (cond.Re, cond.M, geo.foil(i));
   [C_L, C_D] = InterpolatePolars (UpReUpM, LoReUpM, UpReLoM, LoReLoM, dist, alfa);
else
    [UpReUpM, LoReUpM, UpReLoM, LoReLoM, dist] = SearchPolars (cond.Re, cond.M, geo.foil(i));
    [C_L, C_D] = viternamethod (UpReUpM, LoReUpM, UpReLoM, LoReLoM, dist, alfa);
end


C_y = C_L*sind(geo.phi(i)) + C_D*cosd(geo.phi(i));
end