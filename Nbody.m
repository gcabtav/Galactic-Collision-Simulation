function [t, pos] = Nbody(fn1, fn2, m, position, velocity, tmax, level, stars, spin, softening)
    
    %INPUT:
    % fn1: for computing particle acceleration in nbody system
    % fn2: for computing star positions around masses
    % m: length N row vector of non-zero particle masses
    % position: N x 3 array containing particles of masses' positions
    % velocity: N x 3 array containing particle initial velocities matching m
    % tmax: maximum time evolution
    % level: level parameter for scaling timemesh
    % stars: length N row vector of integers declaring how many zero mass 
    %         stars are in the system, with each element specifying what mass 
    %         they will orbit.
    % 
    % OUTPUT:
    % t = Vector of length nt = 2^level + 1 containing discrete times 
    % x = vector of length nt containing computed position at discreet times
    %     t(n). 

    nt = 2^level + 1;
    dt = tmax / (nt - 1); % discrete timestep
    t = 0 : dt : tmax;
    
    N = sum(stars) + length(m); % total number of bodies

    pos = zeros(N, 3, nt); % mesh set up
    
    [ri, vi] = fn2(m, position, velocity, stars, spin); % calculate all initial r, v of stars
    position = [position; ri]; % add random star positions to array
    velocity = [velocity; vi]; % add calculated star velocities to array

    a1 = fn1(m, position, softening); % intial acceleration

    for i = 1 : N % calculate the first and second inital displacements
        pos(i, :, 1) = position(i, :);
        pos(i, :, 2) = position(i, :) + velocity(i, :)*dt + (a1(i, :) * dt^2)/2;
    end

    
    for n = 2 : nt - 1 % calculates rest of timesteps
        a = fn1(m, pos(:, :, n), softening);
        pos(:, :, n+1) = 2 * pos(:, :, n) - pos(:, :, n-1) + a * dt^2; 
    end






