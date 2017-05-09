function output  = xyalpha_to_q(input)
    syms q1 q2 q3 real
    X = input(1);
    Y = input(2);
    ALPHA = input(3)*pi/180;
    L1 = 4;
    L2 = 3;
    L3 = 2;
    sol = vpasolve([X == L2*cos(q1 + q2) + L1*cos(q1) + L3*cos(q1 + q2 + q3),Y == L2*sin(q1 + q2) + L1*sin(q1) + L3*sin(q1 + q2 + q3), ALPHA == (q1+q2+q3)],[q1,q2,q3]);
    Q1 = wrapToPi(double(sol.q1))*180/pi;
    Q2 = wrapToPi(double(sol.q2))*180/pi;
    Q3 = wrapToPi(double(sol.q3))*180/pi;
%     q1 = atan2(sin(q1),cos(q1));
%     q2 = atan2(sin(q2),cos(q2));
%     q3 = atan2(sin(q3),cos(q3));
    %output = [q1, q2, q3, q1_p, q2_p, q3_p];
    output = [Q1, Q2, Q3];
end