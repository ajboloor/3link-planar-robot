% Each link is only allowed to have 1 degree of freedom.
%ESE446_project(10,20,30,4,3,2)

function [output] = project_animate(input)
    th1 = input(1);
    th2 = input(2);
    th3 = input(3);
    L1 = 4;
    L2 = 3;
    L3 = 2;
    P = L1+L2+L3; % work envelope/ perimeter
%     th1 = theta1*pi/180;
%     th2 = theta2*pi/180;
%     th3 = theta3*pi/180;

    base.z = 0:0.1:1;
    base.x = base.z*0;
    base.y = base.z*0;
    
    plot(base.x,base.y)
    hold on;
    grid on;
    %axis([-P*1.1 P*1.1 -P*1.1 P*1.1]);

    T01 = TRANS(0, 0, 0, th1);
    T12 = TRANS(0, L1, 0, th2);
    T23 = TRANS(0, L2, 0, th3);
    T34 = TRANS(0, L3, 0, 0);
    
%     T04 = T01*T12*T23*T34
%     alpha = atan2(T04(2,1),T04(1,1))*180/pi;
%     if alpha < 0
%         alpha = alpha + 360
%     else
%         alpha = alpha
%     end
% %     
%     P01 = T01(1:3,4);
%     P12 = T12(1:3,4);
%     P23 = T23(1:3,4);
%     P34 = T34(1:3,4);
% 
%     R01 = T01(1:3,1:3);
%     R12 = T01(1:3,1:3);
%     R23 = T01(1:3,1:3);
%     R34 = T01(1:3,1:3);
    %T04 = T01*T12*T23*T34;
    q1 = th1;
    q2 = th2; 
    q3 = th3;
    
    X = L1*cos(q1) + L2*cos(q1 + q2) + L3*cos(q1 + q2 + q3);
    Y = L1*sin(q1) + L2*sin(q1 + q2) + L3*sin(q1 + q2 + q3);
    ALPHA = wrapToPi(q1+q2+q3);
    
    link1.a = T01*[0 0 0 1]';
    link1.b = T01*[L1 0 0 1]';

    link2.a = T01*T12*[0 0 0 1]';
    link2.b = T01*T12*[L2 0 0 1]';

    link3.a = T01*T12*T23*[0 0 0 1]';
    link3.b = T01*T12*T23*[L3 0 0 1]';

    link1.X = [link1.a(1) link1.b(1)];
    link1.Y = [link1.a(2) link1.b(2)];
    link1.plot = plot(link1.X, link1.Y,'-or','LineWidth',3);

    link2.X = [link2.a(1) link2.b(1)];
    link2.Y = [link2.a(2) link2.b(2)];
    link2.plot = plot(link2.X, link2.Y,'-og','LineWidth',3);

    link3.X = [link3.a(1) link3.b(1)];
    link3.Y = [link3.a(2) link3.b(2)];
    link3.plot = plot(link3.X, link3.Y,'-ob','LineWidth',3);
    

    axis([-P*1.1 P*1.1 -P*1.1 P*1.1]);
    

    %plot(T04(4,1),T04(4,2));
    %legend([link1.plot link2.plot link3.plot], strcat('\theta1= ',num2str(th1*180/pi)),strcat('\theta2= ',num2str(th2*180/pi,3)),strcat('\theta3= ',num2str(th3*180/pi)));
    %title('\fontsize{12}NO actuator torque, NO gravity')
    %     pause(0.001);
    
    hold off;
    output = [th1, th2, th3, X, Y, ALPHA];
    %output = [th1, th2, th3];
end

function T = TRANS(alpha ,a, d, th)
    T = [cos(th) -sin(th) 0 a;
        sin(th)*cos(alpha) cos(th)*cos(alpha) -sin(alpha) -sin(alpha)*d;
        sin(th)*sin(alpha) cos(th)*sin(alpha) cos(alpha) cos(alpha)*d;
        0 0 0 1];
end