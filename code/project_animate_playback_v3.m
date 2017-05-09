% Each link is only allowed to have 1 degree of freedom.
% Playback function to plot the robot and other parameters

record = 0; % set to 1 to record
FPS = 30;
vid_name = 'sample.avi';

line_width = 1; % default 1
marker_size = 5; % default 10

if record == 1
    gcf = figure(1);
end
set(findall(gcf,'-property','FontSize'),'FontSize',14)
% subplot position [left bottom width height]
s1_pos = [0.07 0.6 0.4 0.38]; % robot 
s2_pos = [0.07 0.34 0.4 0.2]; % XY
s3_pos = [0.07 0.05 0.4 0.2]; % tau
s4_pos = [0.55 0.7 0.4 0.26]; % q & alpha
s5_pos = [0.55 0.375 0.4 0.22]; % qp
s6_pos = [0.55 0.05 0.4 0.22]; % qpp

% robot
s1 = subplot('Position',s1_pos);
hold off
plot(NaN)
hold on
%title('3 Link Robot')

% XY
s2 = subplot('Position',s2_pos);
hold off
plot(NaN)
hold on
title('X - red; Y - blue')
xlabel(s2, 'Time (in seconds)')
ylabel(s2, 'Distance (in meters)')

% tau
s3 = subplot('Position',s3_pos);
hold off
plot(NaN)
hold on
title('[tau1, tau2, tau3] - [R, G, B]')
xlabel(s3, 'Time (in seconds)')
ylabel(s3, 'Force (in Newtons)')

% q & alpha
s4 = subplot('Position',s4_pos);
hold off
plot(0,0)
hold on
title('[q1, q2, q3] - [R, G, B]; [act,des - points,lines]; ALPHA - magenta')
xlabel(s4, 'Time (in seconds)')
ylabel(s4, 'Angle (in degrees)')

% qp
s5 = subplot('Position',s5_pos);
hold off
plot(NaN)
hold on
title('[q1p, q2p, q3p] - [R, G, B]')
xlabel(s5, 'Time (in seconds)')
ylabel(s5, 'Angular velocity (rad/s)')

% qpp
s6 = subplot('Position',s6_pos);
hold off
plot(NaN)
hold on
title('[q1pp, q2pp, q3pp] - [R, G, B]')
xlabel(s6, 'Time (in seconds)')
ylabel(s6, 'Angular acceleration (rad/s^2)')

t = simout.time;
N = length(t);
t_max = max(simout.time);
trail = 25;
endX_vect = zeros(N+trail,1);
endY_vect = zeros(N+trail,1);
%t = 0:t_max/N:t_max;

% the following is merely to set appropiate axes lengths
tau1_max = max(simout.signals.values(:,7,:));
tau2_max = max(simout.signals.values(:,8,:));
tau3_max = max(simout.signals.values(:,9,:));
tau_max = max([tau1_max tau2_max tau3_max]);
tau1_min = min(simout.signals.values(:,7,:));
tau2_min = min(simout.signals.values(:,8,:));
tau3_min = min(simout.signals.values(:,9,:));
tau_min = min([tau1_min tau2_min tau3_min]);

q1_p_max = max(simout.signals.values(:,10,:));
q2_p_max = max(simout.signals.values(:,11,:));
q3_p_max = max(simout.signals.values(:,12,:));
qp_max = max([q1_p_max q2_p_max q3_p_max]);
q1_p_min = min(simout.signals.values(:,10,:));
q2_p_min = min(simout.signals.values(:,11,:));
q3_p_min = min(simout.signals.values(:,12,:));
qp_min = min([q1_p_min q2_p_min q3_p_min]);

q1_pp_max = max(simout.signals.values(:,13,:));
q2_pp_max = max(simout.signals.values(:,14,:));
q3_pp_max = max(simout.signals.values(:,15,:));
qpp_max = max([q1_pp_max q2_pp_max q3_pp_max]);
q1_pp_min = min(simout.signals.values(:,13,:));
q2_pp_min = min(simout.signals.values(:,14,:));
q3_pp_min = min(simout.signals.values(:,15,:));
qpp_min = min([q1_pp_min q2_pp_min q3_pp_min]);

if tau_max == 0
    tau_max = 100;
end
if qp_max == 0
    qp_max = 1;
end
if qpp_max == 0
    qpp_max = 1;
end

if tau_min == 0
    tau_min = -100;
end
if qp_min == 0
    qp_min = -1;
end
if qpp_min == 0
    qpp_min = -1;
end

% data = q1 q2 q3 X Y ALPHA tau1 tau2 tau3
data = simout.signals.values(1,:,1);
q1 = data(1)*pi/180;
q2 = data(2)*pi/180;
q3 = data(3)*pi/180;

X = data(4);
Y = data(5);
ALPHA = data(6);

tau1 = data(7);
tau2 = data(8);
tau3 = data(9);

q1_p = data(10);
q2_p = data(11);
q3_p = data(12);

q1_pp = data(13);
q2_pp = data(14);
q3_pp = data(15);

q1_d = data(16);
q2_d = data(17);
q3_d = data(18);


i = 1;
L1 = 4;
L2 = 3;
L3 = 2;
P = L1+L2+L3; 
if record == 1
    writerObj = VideoWriter(vid_name); % Name it.   
    writerObj.FrameRate = FPS; % How many frames per second.
    open(writerObj);
end
q1d_vect = zeros(N,1);
q2d_vect = zeros(N,1);
q3d_vect = zeros(N,1);

while i <= N 
    if i == 1
        t0 = 0;
    else
        t0 = t(i-1);
    end
    data = simout.signals.values(1,:,i);
    q1 = data(1)*pi/180;
    q2 = data(2)*pi/180;
    q3 = data(3)*pi/180;
    X = data(4);
    Y = data(5);
    ALPHA = data(6)*pi/180;
    tau1 = data(7);
    tau2 = data(8);
    tau3 = data(9);
    q1_p = data(10);
    q2_p = data(11);
    q3_p = data(12);
    q1_pp = data(13);
    q2_pp = data(14);
    q3_pp = data(15);
    q1d_vect(i) = data(16);
    q2d_vect(i) = data(17);
    q3d_vect(i) = data(18);
%     
    endX_vect(i) = X;
    endY_vect(i) = Y;
    %axis([-P*1.1 P*1.1 -P*1.1 P*1.1]);

    T01 = TRANS(0, 0, 0, q1);
    T12 = TRANS(0, L1, 0, q2);
    T23 = TRANS(0, L2, 0, q3);
    T34 = TRANS(0, L3, 0, 0);

    link1.a = T01*[0 0 0 1]';
    link1.b = T01*[L1 0 0 1]';

    link2.a = T01*T12*[0 0 0 1]';
    link2.b = T01*T12*[L2 0 0 1]';

    link3.a = T01*T12*T23*[0 0 0 1]';
    link3.b = T01*T12*T23*[L3 0 0 1]';
    
    % robot
    s1 = subplot('Position',s1_pos);
    plot(endX_vect(1:i), endY_vect(1:i),'-k','LineWidth',2);
    grid on
    hold on
    link1.X = [link1.a(1) link1.b(1)];
    link1.Y = [link1.a(2) link1.b(2)];
    link1.plot = plot(link1.X, link1.Y,'-or','LineWidth',3);
    link2.X = [link2.a(1) link2.b(1)];
    link2.Y = [link2.a(2) link2.b(2)];
    link2.plot = plot(link2.X, link2.Y,'-og','LineWidth',3);
    hold on
    link3.X = [link3.a(1) link3.b(1)];
    link3.Y = [link3.a(2) link3.b(2)];
    link3.plot = plot(link3.X, link3.Y,'-ob','LineWidth',3);
    axis([-(P+1) (P+1) -(P+1) (P+1)]);
    hold off
    
    % X Y
    s2 = subplot('Position',s2_pos);
    grid on
    plot(t(i),X,'.r','MarkerSize',marker_size)
    hold on
    plot(t(i),Y,'.b','MarkerSize',marker_size)
    axis([0 t_max -P*1.1 P*1.1])
    
    % q and alpha
    s3 = subplot('Position',s3_pos);
    grid on
    plot(t(i),tau1,'.r','MarkerSize',marker_size)
    hold on
    plot(t(i),tau2,'.g','MarkerSize',marker_size)
    plot(t(i),tau3,'.b','MarkerSize',marker_size)
    axis([0 t_max (tau_min-100) tau_max*1.1])    
    
    % tau
    s4 = subplot('Position',s4_pos);
    grid on
    plot(t(i),q1*180/pi,'.r','MarkerSize', marker_size)
    hold on
    plot(t(i),q2*180/pi,'.g','MarkerSize', marker_size)    
    plot(t(i),q3*180/pi,'.b','MarkerSize', marker_size)
    plot(t(i),wrapToPi(ALPHA)*180/pi,'.m','MarkerSize',marker_size)
    plot(t(1:i),q1d_vect(1:i),'-r','LineWidth',line_width)
    plot(t(1:i),q2d_vect(1:i),'-g','LineWidth',line_width)
    plot(t(1:i),q3d_vect(1:i),'-b','LineWidth',line_width)
    axis([0 t_max -180 180])
    
    % qp
    s5 = subplot('Position',s5_pos);
    grid on
    plot(t(i),q1_p,'.r','MarkerSize',marker_size)
    hold on
    plot(t(i),q2_p,'.g','MarkerSize',marker_size)
    plot(t(i),q3_p,'.b','MarkerSize',marker_size)
    axis([0 t_max qp_min*1.1 qp_max*1.1])
    
    % qpp
    s6 = subplot('Position',s6_pos);
    grid on
    plot(t(i),q1_pp,'.r','MarkerSize',marker_size)
    hold on
    plot(t(i),q2_pp,'.g','MarkerSize',marker_size)
    plot(t(i),q3_pp,'.b','MarkerSize',marker_size)
    axis([0 t_max qpp_min*1.1 qpp_max*1.1])
    
%     X = L2*cos(q1 + q2) + L1*cos(q1) + L3*cos(q1 + q2 + q3);
%     Y = L2*sin(q1 + q2) + L1*sin(q1) + L3*sin(q1 + q2 + q3);
%     ALPHA = q1+q2+q3;
    %plot(T04(4,1),T04(4,2));
    %legend([link1.plot link2.plot link3.plot], strcat('\theta1= ',num2str(round((q1(i)*180/pi),2))),strcat('\theta2= ',num2str(q2(i)*180/pi)),strcat('\theta3= ',num2str(q3(i)*180/pi)));
    %title('NO actuator torque, NO gravity')
    
    if record == 1
        frame = getframe(gcf); % 'gcf' can handle if you zoom in to take a movie.
        writeVideo(writerObj, frame);
    end
	pause(t(i)-t0);
    %pause(t_max/N);
    i = i + 1;
end
if record == 1
    close(writerObj);
end