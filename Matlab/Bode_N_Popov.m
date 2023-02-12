%% import the TF as TF or State Space as SS
close all; 
clear all; 

% TF as minimum polynomial
% f(x) = s(s-7)(s-6) + (s+4)(s-9)(s-2) + s(s-8)(s+1) 
rts1 = [ 0  7  6];
rts1_d = [7 6 0 ];
rts2 = [-4  9  2];
rts3 = [ 0  8 -1];
trm1 = poly(rts1);
trm1_d = poly(rts1_d);
trm2 = poly(rts2);
trm3 = poly(rts3);
den = trm1 + trm2 + trm3;
den_d = trm1_d + trm2 + trm3;

a1 = 0;
a2 = 5;
a3 = 10;
% a1*s^2 + a2*s + a3
num = [a1 a2 a3]; 

% Ex2 
% G(s) = 10 * (1 + 100s ) / { ( 1 + 10s )^2 * (1 + 0.1s ) ^ 2 } 
poly1 = [10 1];   % (10s + 1 ) 
poly2 = [0.1 1]   % (0.1s + 1)
poly3 = 10*[100 1];   % 10*(100s + 1)
%poly1 = poly(poly1);
%poly2 = poly(poly2);
%poly3 = poly(poly3);
poly1=conv(poly1,poly1);
poly2=conv(poly2,poly2);  % (0.1s + 1)^2 :
% poly2=conv(poly2,poly2);  % (0.1s + 1)^3 for higher sqaures just repear
% the function
poly_den=conv(poly1,poly2)

poly_num = poly3

Ex_tf = tf(poly_num,poly_den)

A = [0 1 0;
     0 0 1;
     -1 -1 -5]
B=[0 0 1]'
C=[1 0 0]
D=[0]

%% num explain as an expanded vector
% 
% TF
 G_tf = tf(num,den)
 G_tf_d = tf(num,den_d)
% SS
 G_ss = ss(A,B,C,D)
 [n,d]=ss2tf(A,B,C,D);
 G=tf(n,d)

 %% draw Bode plot 
 figure;
 bode(G_tf);
 hold on;
 bode(G_ss);

 %% Draw Nyquist 
 figure;
 nyquist(G_tf);
 hold on;
 nyquist(G_ss);

 %% PLot Popov PLot and display Popov slope/line
%popov(sys,k,q)
%sys: Tf of the system to draw the Popov Plot
%K: coefficient of the k line at coordinates -1/k
%Q: slope of the line with intersection with x axis at -1/k
% If plot of Sys is on the right side of the Popoc line, the system is ASS
% stable ( sufficient condition ) 
popov(Ex_tf,5,0)
