function [pont] = pontuacao(eff,T, eff_v, T_v, Q_v, Q_eng)
% Estudo de pontuação 

pont = (2*T+sum(T_v));
% pont = (T*eff+sum(T_v.*eff_v));
% pont = (T+sum(T_v));

if mean(Q_v)>100
    pont = 1000;
end

if pont < -1000
    pont = -1000;
end

end