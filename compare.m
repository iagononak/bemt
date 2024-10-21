clc; clear; close all
[Temp,a,~,cond.rho] = atmosisa(0);


load('Otimizacao2.4.mat')
% x   = [floor(x(1)) x(2) floor(x(3)) floor(x(4)) floor(x(5)) floor(x(6)) x(7) x(8) x(9) x(10) x(11) x(12) x(13) x(14)];
x   = [floor(x(1)) floor(x(2)) floor(x(3)) x(4) x(5) x(6) x(7) x(8) x(9) x(10) x(11)];
[prop] = propeller(x);
[eff1,T1,Q1, eff_v1, T_v1,Q_v1, B1] = bemt(prop);
r1 = 0.8;


% load('Otimizacao2.5.mat')
% x   = [floor(x(1)) floor(x(2)) floor(x(3)) x(4) x(5) x(6) x(7) x(8) x(9) x(10) x(11)];
% [prop] = propeller(x);
% [eff2,T2,Q2, eff_v2, T_v2,Q_v2, B2] = bemt(prop);
% r2 = 0.8;
% 
% load('Otimizacao2.6.mat')
% x   = [floor(x(1)) floor(x(2)) floor(x(3)) x(4) x(5) x(6) x(7) x(8) x(9) x(10) x(11)];
% % x   = [floor(x(1)) x(2) floor(x(3)) floor(x(4)) floor(x(5)) floor(x(6)) x(7) x(8) x(9) x(10) x(11) x(12) x(13) x(14)];
% [prop] = propeller(x);
% [eff3,T3,Q3, eff_v3, T_v3,Q_v3, B3] = bemt(prop);
% r3 = 0.8;



v = 10:1:45;            % 10:1:58; Range of speeds[m/s]
Omega = 1600;
Omega = Omega*2*pi/60;
rps = Omega/(2*pi);
J1 = v/(rps*r1*2);
% J2 = v/(rps*r2*2);
% J3 = v/(rps*r3*2);

CT = T_v1./(cond.rho*rps^2*(2*0.8)^4);
CQ = Q_v1./(cond.rho*rps^2*(2*0.8)^5);
CP = 2*pi*CQ;

load('JxCTxiang');
load('JxCPxiang');
load('JxCQxiang');
load('JxEffxiang');
load('vxthrust');
load('vxtorque');

vexp = JxCTxiang(:,1)*(rps*0.8*2);
Texp = JxCTxiang(:,2)*(cond.rho*rps^2*(2*0.8)^4);
Qexp = JxCQxiang(:,2)*(cond.rho*rps^2*(2*0.8)^5);

load('JxCTxiangana')
load('JxCQxiangana')
load('JxEffxiangana')

figure
plot(JxCTxiang(:,1),JxEffxiang(:,2),'k',JxEffxiangana(:,1),JxEffxiangana(:,2),'r',...
    J1,eff_v1,'b'); %JxEffxiang(:,1),JxEffxiang(:,2),'k'
axis([0 1.2 0 1.2]);
xlabel('Advance Ratio(J)');
ylabel('Efficiency');
legend('Experiment','Analytical','Developed'); %,'Xiangs propeller'
grid on; grid minor

figure
plot(JxCTxiang(:,1),JxCTxiang(:,2),'k',JxCQxiang(:,1),JxCQxiang(:,2),'kx-',...
    JxCTxiangana(:,1),JxCTxiangana(:,2),'r',JxCQxiangana(:,1),JxCQxiangana(:,2),'rx-',...
    J1,CT,'b',J1,CQ,'bo-');
xlabel('Velocity[m/s]');
ylabel('Thrust and Torque');
legend('Thrust[experiment]','Torque[experiment]','Thrust[analytical]','Torque[analytical]',...
    'Thrust[developed]','Torque[developed]');
grid on; grid minor


figure
plot(vexp,Texp,'k',vexp,Qexp,'kx-',...
    vxthrust(:,1),vxthrust(:,2),'r',vxtorque(:,1),vxtorque(:,2),'rx-',...
    v,T_v1,'b',v,Q_v1,'bo-');
xlabel('Velocity[m/s]');
ylabel('Thrust and Torque');
legend('Thrust[experiment]','Torque[experiment]','Thrust[analytical]','Torque[analytical]',...
    'Thrust[developed]','Torque[developed]');
grid on; grid minor


% figure
% plot(J1,eff_v1,'r',J2,eff_v2,'b+-',J3,eff_v3,'c'); %JxEffxiang(:,1),JxEffxiang(:,2),'k'
% axis([0 1.2 0 1]);
% xlabel('Advance Ratio(J)');
% ylabel('Efficiency');
% legend('Iter 1','Iter 2','Iter 3'); %,'Xiangs propeller'
% grid on; grid minor

% figure
% plot(v,T_v1,'r',v,Q_v1,'rx-',v,T_v2,'bo-',v,Q_v2,'b+-',v,T_v3,'c',v,Q_v3,'cx-');
% xlabel('Velocity[m/s]');
% ylabel('Thrust[N] and Torque[Nm]');
% legend('Thrust[Iter 1]','Torque[Iter 1]','Thrust[Iter 2]','Torque[Iter 2]','Thrust[Iter 3]','Torque[Iter 3]');
% grid on; grid minor
% ylim([0 2e4])