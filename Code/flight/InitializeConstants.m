%Initialize constants for the RCAM simulation
clear
clc
close all

%% Define constants
x0 = [85;             %approx 165 knots
     0;
     0;
     0;
     0;
     0;
     0;
     0.1;              %approx 5.73 deg
     0;
     0;
     0;
     0];
 
 u = [0;
     -0.1;             %approx -5.73 deg
     0;
     0;                %recall minimum for throttles are 0.5*pi/180 = 0.0087
     0.08];
 
 TF = 3*60;
 
%Define minimum/maximum control values
u1min = -25*pi/180;
u1max = 25*pi/180;

u2min = -25*pi/180;
u2max = 10*pi/180;

u3min = -30*pi/180;
u3max = 30*pi/180;

u4min = 0.5*pi/180;
u4max = 10*pi/180;

u5min = 0.5*pi/180;
u5max = 10*pi/180;

 %% Run the model
%  sim('RCAMSimulation.slx')
 
 %% Plot the results
%  t = ans.simX.Time;
%  
%  u1 = ans.simU.Data(:,1);
%  u2 = ans.simU.Data(:,2);
%  u3 = ans.simU.Data(:,3);
%  u4 = ans.simU.Data(:,4);
%  u5 = ans.simU.Data(:,5);
%  
%  x1 = ans.simX.Data(:,1);
%  x2 = ans.simX.Data(:,2);
%  x3 = ans.simX.Data(:,3);
%  x4 = ans.simX.Data(:,4);
%  x5 = ans.simX.Data(:,5);
%  x6 = ans.simX.Data(:,6);
%  x7 = ans.simX.Data(:,7);
%  x8 = ans.simX.Data(:,8);
%  x9 = ans.simX.Data(:,9);
%  x10 = ans.simX.Data(:,10);
%  x11 = ans.simX.Data(:,11);
%  x12 = ans.simX.Data(:,12);
%  
%  figure
%  subplot(5,1,1)
%  plot(t, u1)
%  legend('u_1')
%  grid on
%  
%  subplot(5,1,2)
%  plot(t, u2)
%  legend('u_2')
%  grid on
%  
%  subplot(5,1,3)
%  plot(t, u3)
%  legend('u_3')
%  grid on
%  
%  subplot(5,1,4)
%  plot(t, u4)
%  legend('u_4')
%  grid on
%  
%  subplot(5,1,5)
%  plot(t, u5)
%  legend('u_5')
%  grid on
%  
%  %Plot the states
%  figure
% 
%  %u, v, w
%  subplot(3,4,1)
%  plot(t, x1)
%  legend('x_1')
%  grid on
%  
%  subplot(3,4,4)
%  plot(t, x2)
%  legend('x_2')
%  grid on
%  
%  subplot(3,4,7)
%  plot(t, x3)
%  legend('x_3')
%  grid on
%  
%  %p, q, r
%  subplot(3,4,2)
%  plot(t, x4)
%  legend('x_4')
%  grid on
%  
%  subplot(3,4,5)
%  plot(t, x5)
%  legend('x_5')
%  grid on
%  
%  subplot(3,4,8)
%  plot(t, x6)
%  legend('x_6')
%  grid on
%  
%  %phi, theta, psi
%  subplot(3,4,3)
%  plot(t, x7)
%  legend('x_7')
%  grid on
%  
%  subplot(3,4,6)
%  plot(t, x8)
%  legend('x_8')
%  grid on
%  
%  subplot(3,4,9)
%  plot(t, x9)
%  legend('x_9')
%  grid on
%  
%  subplot(3,4,10)
%  plot(t, x10)
%  legend('x_10')
%  grid on
%  
%  subplot(3,4,11)
%  plot(t, x11)
%  legend('x_11')
%  grid on
%  
%  subplot(3,4,12)
%  plot(t, x12)
%  legend('x_12')
%  grid on

 
 
 
 
 
 
 
 
 
 
 