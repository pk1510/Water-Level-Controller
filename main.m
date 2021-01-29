%script to interact with the simulink
clear
clc
close all

%input constants
%1)motor

J=0.01;                     %moment of inertia of the rotor
b=0.1;                      %motor viscous friction constant
Kt=0.1;                     %motor torque constant
Ke=0.01;                    %electromotive force constant
R=1;
L=0.5;

%2)Tank
Ar=0.5;                      %area
Rf=0.5;                     %flow resistance
%3)STH
Kf=1;                       %constant of proportionality between the speed and the incoming flow rate to the tank

%desired level
h0=1;

%PID parameters
Kp=9;
Ki=15;
Kd=2;
%Kp=12;
%Ki=15;
%Kd=3;

%Coefficients
%numerator
A=Kd*Kt*Rf;
B=Kt*Kp*Rf;
C=Ki*Kt*Rf;
%denominator
E=Kf*Rf*Ar*J*L;
F=J*L*Kf+(J*R+b*L)*Kf*Rf*Ar;
G=(J*R+b*L)*Kf + (R*b+Kt*Ke)*Kf*Rf*Ar + Kd*Kt*Rf;
H=Kf*(R*b+Kt*Ke)+Kt*Kp*Rf;
I=Ki*Kt*Rf;

% decay rate
lam=-1;

%without PID
Kp_=5;
%numerator
a0=Kt*Kp_*Rf;

%denominator
b0=E;
c0=F;
d0=(J*R+b*L)*Kf + (R*b+Kt*Ke)*Kf*Rf*Ar;
e0=Kf*(R*b+Kt*Ke);

sim("waterLevel.slx")

% get the outputs
out=yout.getElement('x');
t=out.Values.Time;
h_pid=out.Values.Data(:,2);
h_=out.Values.Data(:,1);

if lam<=0,
    figure 
    grid on
    plot(t, h_pid, '-r')
    hold on
    plot(t, h_,'-b')
    xlabel('t (sec)')
    ylabel('height (m)')
    legend('withoutPID', 'withPID')
    title("output generated by the two systems")
    grid on 
else
    figure 
    grid on
    plot(t, h_pid+(1-exp(-lam.*t).*(1+t))/lam.^2, '-r')
    hold on
    plot(t, h_+(1-exp(-lam.*t).*(1+t))/lam.^2,'-b')
    xlabel('t (sec)')
    ylabel('height (m)')
    legend('withoutPID', 'withPID')
    title("output generated by the two systems")
    grid on 
end





