t = 0:2:8;
t_step = 0:0.005:8;

q1_vect = [0 30 45 150 180];
q2_vect = [0 -10 130 10 0];
q3_vect = [90 70 -85 70 -90];

q1_spline = ppval(t_step, spline(t, [0, q1_vect, 0]));
q2_spline = ppval(t_step, spline(t, [0, q2_vect, 0]));
q3_spline = ppval(t_step, spline(t, [0, q3_vect, 0]));

q1spline = [t_step', q1_spline'];
q2spline = [t_step', q2_spline'];
q3spline = [t_step', q3_spline'];
plot(t, q1_vect,'or', t, q2_vect,'og', t, q3_vect,'ob')
hold on
grid on
plot(t_step, q1_spline,'-r',t_step, q2_spline,'-g',t_step, q3_spline,'-b')