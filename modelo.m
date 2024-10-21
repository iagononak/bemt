function [result] = modelo(x,~,individuo)
% MODELO DE OTIMIZACAO
% Autores: Iago Tetsuo Nonaka

% PARAMETROS DA SIMULACAO
tic;                % inicio da contagem de tempo
sim.paralelo  = 1;  % Indica se usa ou n√£o processamento paralelo
                    % OBS: Caso rodar paralelo, pre-definir o numero de
                    % processadores pelo comando parpool(n)
                    % Ex: 3 processadores - parpool(3)

% PARAMETROS GEOMETRICOS DA AERONAVE (VARIAVEIS DE OTIMIZACAO)
% 01 [ ] B [blade number]
% 02 [ ] radius
% 03 [ ] section qty
% 04 [ ] root wind foil selection
% 05 [ ] tip wind foil selection
% 06 [ ] section wind foil change
% 07 [ ] inflow angle A [x^2]
% 08 [ ] inflow angle B [x]
% 09 [ ] inflow angle C [n]
% 10 [ ] beta A [x^2]
% 11 [ ] beta B [x]
% 12 [ ] beta C [n]
% 13 [ ] chord A [x^2]
% 14 [ ] chord B [x]
% 15 [ ] chord C [n]


x   = [floor(x(1)) floor(x(2)) floor(x(3)) x(4) x(5) x(6) x(7) x(8) x(9) x(10) x(11)];


[prop] = propeller(x);


%% -------------------- AVALIA«√O GEOM…TRICA ---------------------------


%% -------------------------- PONTUACAO -----------------------------------
[eff,T,Q, eff_v, T_v,Q_v, B] = bemt(prop);

Q_eng = 100; %[N]
[Pontuacao] 		= pontuacao(eff,T,eff_v,T_v,Q_v,Q_eng);
result              = -Pontuacao;


%% -------------------------------- DISPLAY --------------------------------
fprintf('Aeronave n: %d; Iter: %d; Ind: %d\n\n', individuo(3), individuo(1), individuo(2))

fprintf('Thrust = %f\n', T);
fprintf('eff = %.2f\n', eff);
fprintf('Torque = %f\n\n', Q);
fprintf('PONTOS = %f\n', Pontuacao);

fprintf('Blade number = %d\n', B);

%fprintf('TEMPO = %.3f\n',tempo);
disp('===================================================================');

end
