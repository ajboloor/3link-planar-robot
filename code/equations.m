clc
clear all

fprintf('Program Initializing... ');

tic;
syms q1 q2 q3 q1_p q2_p q3_p q1_pp q2_pp q3_pp m1 m2 m3 I1_zz I2_zz I3_zz L1 L2 L3 g tau1 tau2 tau3 D1 D2 D3 x y alpha real

fprintf('DONE');
fprintf('\nConstructing Transformation Matrices... ');

T01 = TRANS(0, 0, 0, q1);
T12 = TRANS(0, L1, 0, q2);
T23 = TRANS(0, L2, 0, q3);
T3E = TRANS(0, L3, 0, 0); % Endeffector

T02 = T01*T12;
T03 = T01*T12*T23;
T0E = T01*T12*T23*T3E;

P01 = T01(1:3,4);
P12 = T12(1:3,4);
P23 = T23(1:3,4);

R01 = T01(1:3,1:3);
R12 = T12(1:3,1:3);
R23 = T23(1:3,1:3);

P0C1 = T01*[L1/2 0 0 1]';
P0C2 = T02*[L2/2 0 0 1]';
P0C3 = T03*[L3/2 0 0 1]';

P0C1 = P0C1(1:3);
P0C2 = P0C2(1:3);
P0C3 = P0C3(1:3);

fprintf('DONE');
fprintf('\nCalculating Jacobians... ');

Jv1 = [diff(P0C1,q1) diff(P0C1,q2) diff(P0C1,q3)];
Jv2 = [diff(P0C2,q1) diff(P0C2,q2) diff(P0C2,q3)];
Jv3 = [diff(P0C3,q1) diff(P0C3,q2) diff(P0C3,q3)];

Jv1 = simplify(Jv1);
Jv2 = simplify(Jv2);
Jv3 = simplify(Jv3);

Jw1 = [T01(1,3) 0 0;
       T01(2,3) 0 0;
       T01(3,3) 0 0];
Jw2 = [T01(1,3) T02(1,3) 0;
       T01(2,3) T02(2,3) 0;
       T01(3,3) T02(3,3) 0];
Jw3 = [T01(1,3) T02(1,3) T03(1,3);
       T01(2,3) T02(2,3) T03(2,3);
       T01(3,3) T02(3,3) T03(3,3)]; 
   
fprintf('DONE');
fprintf('\nConstructing Mass Matrix... ');

IC1 = [0 0 0 ;
    0 0 0;
    0 0 I1_zz];
IC2 = [0 0 0 ;
    0 0 0;
    0 0 I2_zz];
IC3 = [0 0 0 ;
    0 0 0;
    0 0 I3_zz];

mv1 = Jv1'*Jv1*m1;
mv2 = Jv2'*Jv2*m2;
mv3 = Jv3'*Jv3*m3;

mw1 = Jw1'*IC1*Jw1;
mw2 = Jw2'*IC2*Jw2;
mw3 = Jw3'*IC3*Jw3;

M_q = mv1 + mv2 + mv3 + mw1+ mw2 + mw3;
M_q = simplify(M_q);

fprintf('DONE');
fprintf('\nConstructing Centrifugal and Coriolis Matrices... ');

q = [q1;q2;q3];
n = length(q);
for i = 1:1:n
    for j = 1:1:n
        for k = 1:1:n
            m_ijk = diff(M_q(i,j),q(k));
            m_ikj = diff(M_q(i,k),q(j));
            m_jki = diff(M_q(j,k),q(i));
            b(i,j,k) = 1/2*(m_ijk+m_ikj-m_jki);
            %C_q(i,j) = b(i,j,j); % Centrifugal matrix C(q)
            %B_q(i,j) = 2*b(i,j,j);
        end
    end
end
C_q = [b(1,1,1) b(1,2,2) b(1,3,3);
       b(2,1,1) b(2,2,2) b(2,3,3);
       b(3,1,1) b(3,2,2) b(3,3,3)];
B_q = 2*[b(1,1,2) b(1,1,3) b(1,2,3);
        b(2,1,2) b(2,1,3) b(2,2,3);
        b(3,1,2) b(3,1,3) b(3,2,3)];
    

C_q = simplify(C_q);
B_q = simplify(B_q);
V_q = C_q*[q1_p^2; q2_p^2; q3_p^2] + B_q*[q1_p*q2_p; q1_p*q3_p; q2_p*q3_p];
V_q = simplify(V_q);
fprintf('DONE');

% q1 = 10*pi/180;
% q2 = 20*pi/180;
% q3 = 30*pi/180;
L1 = 4;
L2 = 3;
L3 = 2;
m1 = 20;
m2 = 15;
m3 = 10;
I1_zz = 0.5;
I2_zz = 0.2;
I3_zz = 0.1;
%D = 1;
C = 1;
% m = simplify(m)
% m = simplify(subs(m))
fprintf('\nConstructing Gravity Matrix... ');
G_q = -(Jv1'*[0; -m1*g; 0] + Jv2'*[0; -m2*g; 0] + Jv3'*[0; -m3*g; 0]);
G_q = simplify(G_q);
fprintf('DONE');
fprintf('\nConstructing Friction Vector... ');
F_q = [D1; D2; D3].*[q1_p; q2_p; q3_p] ;%+ C*[sign(q1_p); sign(q2_p); sign(q3_p)];
F_q = simplify(F_q);
fprintf('DONE');
fprintf('\nCalculating Tau Vector... ');
eq_tau = [tau1; tau2; tau3] == M_q*[q1_pp; q2_pp; q3_pp] + V_q + G_q + F_q;
fprintf('DONE');
fprintf('\nSolving for q_pp''s... ');
sol = solve(eq_tau, q1_pp, q2_pp, q3_pp);
q1_pp = simplify(sol.q1_pp);
q2_pp = simplify(sol.q2_pp);
q3_pp = simplify(sol.q3_pp);
fprintf('DONE');
fprintf('\nSolving for tau''s... ');
sol = solve(eq_tau, tau1, tau2, tau3);
tau1 = simplify(sol.tau1);
tau2 = simplify(sol.tau2);
tau3 = simplify(sol.tau3);
fprintf('DONE');            
fprintf('\nProgram Completed in %0.4f seconds.\n', toc);
fprintf('\nAvailable outputs: M_q G_q F_q C_q B_q q1_pp q2_pp q3_pp tau1 tau2 tau3 q_xy\n')