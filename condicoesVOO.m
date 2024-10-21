function [flc] = condicoesVOO()

    % flight conditions (flc)
    flc.h           = 1000;                                                 % [m]       altitude analisada (ISA)
    flc.g           = 9.78522;                                              % [m/s^2]   aceleracao da gravidade em 1000 metros e latitude 23deg
    [~,~,~,flc.rho] = atmosisa(flc.h);                                      % [kg/m^3]  Densidade do ar
    flc.visc        = 1.7603e-05;                                           % [m^2/s]   Viscosidade cinematica
    flc.mi          = 0.07;                                                 % [-]       Coeficiente de atrito das rodas;
    flc.Vsom        = 336.434106;                                           % [m/s]     Velocidade do som
    flc.v_vento     = 0.1;                                                    % [m/s]     Velocidade do vento de proa
    flc.Voo         = 10;
    flc.aoa         = [0];                                                  % [deg]     Angulo de ataque
    flc.aos         = [0];                                                  % [deg]     Angulo de derrapagem
    
    % Desempenho (dsp)
%     dsp.n           = 0.12;                                                  % [ ]   Carga relativa na bequilha

    % HELICE APC 12.25x3.75
%     dsp.mp.s30		= 0.02485;                                              % [m] Largura (Corda) da secao da helice pelo raio da mesma
%     dsp.mp.s60		= 0.0281;
%     dsp.mp.s90		= 0.01785;
%     dsp.mp.b		= 12.25*0.0254;                                         % [m]   Diametro da helice
%     dsp.mp.ang75	= 17*pi/180;                                            % [rad] angulo geometrico da pa em 75% do raio da helice
end
