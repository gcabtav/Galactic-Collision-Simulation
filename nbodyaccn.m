function [a] = nbodyaccn(m, r)

% INPUT:
% m: Vector of length N containing the particle masses
% r: N x 3 array containing the particle positions
%
% OUTPUT:
% a: N x 3 array containing the computed particle accelerations

bodies = length(r(1,:,:));
acceleration = zeros(3, bodies);
for i = 1:bodies % for every body in the system
    acc_j = zeros(3, 1); % reset acceleration due to all other particles
    for j = 1:length(m) % for every body of mass in the system
        if j~= i % don't include current body if i has mass
            rij = norm(abs(r(:,j) - r(:,i))); % magnitude of separation vector
            acc = m(j)/(rij^3) * (r(:,j) - r(:,i)); % acceleration due to one mass j
            acc_j = acc_j + acc; % add; final acceleration should be the sum of all j
        end
        
    end

    acceleration(:,i) = acc_j;
end
a = acceleration;
end



        










