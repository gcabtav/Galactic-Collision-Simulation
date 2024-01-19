stars = [0, 0];
tmax = 40; 
m = [1.0 0.5];
M = sum(m);
N = 2;
r = 4; % distance between mes

r_1 = m(2)*r/M;
r_2 = m(1)*r/M;

v_1 = sqrt(m(2)*r_1)/r;
v_2 = sqrt(m(1)*r_2)/r;

position = zeros(N, 3);
velocity = zeros(N, 3);

position(1, 1) = r_1;
position(2, 1) = -r_2;
velocity(1, 2) = v_1;
velocity(2, 2) = -v_2;

% to test convergence test function at different levels

level = 5; 
[t5, pos5] = Nbody0(@nbodyaccn0, m, position, velocity, tmax, level, stars, softening);
x5 = squeeze(pos5(1, 1, :));

level = 6; 
[t6, pos6] = Nbody0(@nbodyaccn0, m, position, velocity, tmax, level, stars, softening);
x6 = squeeze(pos6(1, 1, :));

level = 7; 
[t7, pos7] = Nbody0(@nbodyaccn0, m, position, velocity, tmax, level, stars, softening);
x7 = squeeze(pos7(1, 1, :));

level = 8; 
[t8, pos8] = Nbody0(@nbodyaccn0, m, position, velocity, tmax, level, stars, softening);
x8 = squeeze(pos8(1, 1, :));

% have it so that lengths match (downsample)
x6 = x6(1:2:end);
x7 = x7(1:4:end);
x8 = x8(1:8:end);

% find scaling factors 

dx5_6 = x5 - x6;
dx6_7 = x6 - x7;
dx7_8 = x7 - x8;

% scale by factor of 4 for second order testing (why?)
dx6_7 = (4^1) * dx6_7;
dx7_8 = (4^2) * dx7_8;


% plotting

clf; % clear figures 
hold on; 
plot(t5, dx5_6, 'r-.o'); 
plot(t5, dx6_7, 'g-.+');
plot(t5, dx7_8, 'b-.+');
xlabel('t')
ylabel('Error (between subsequent level parameters)')
legend('dx56', 'dx67', 'dx78')



