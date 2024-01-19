function [r, v] = star_metrics(m, mp, mv0, stars, cw)
    
    % INPUT:
    % m:length N vector of mass values
    % mp: N x 3 matrix of the masses' positions
    % mv0: N x 3 matrix of the masses' initial velocities
    % stars: length N vector of number of stars to plot per mass
    % cw: length N vector of values 1 or 2, determines rotation of stars
    % (cw or ccw, respectively).
    %
    % OUTPUT:
    % r: randomized M x 3 array that gives position of stars relative
    %     to core location. 
    % v: M x 3 array of velocity needed to maintain circular orbit given
    %     the randomized radius

    v = zeros(sum(stars), 3);
    r = zeros(sum(stars), 3);
    a = 1 : stars(1);
    
    for i = 1 : length(m)
        mi = m(i);
        for j = a % for every star about some given core
            radius = randn;
            while (radius <= 0.2) || (radius >= 1)
                radius = randn;
            end
            theta = 2*pi*randn; % random angle between 0 to 2pi
    
            x = (radius * cos(theta)) + mp(i,1); % adding initial position of mass
            y = (radius * sin(theta)) + mp(i,2);
            z = 0;
    
            r(j, :) = [x, y, z]; 
    
            velocity = sqrt(mi/abs(radius));
    
            if cw == 1 % clockwise orbits
                if (theta <= pi/2) % quadrant 1
                    vx = velocity * sin(theta);
                    vy = velocity * -cos(theta);
                    vz = 0;
                elseif (theta >= pi/2) && (theta <= pi) % quadrant 2
                    vx = velocity * cos(theta-(pi/2));
                    vy = velocity * sin(theta-(pi/2));
                    vz = 0;
                elseif (theta >= pi) && (theta <= 3*pi/2) % quadrant 3
                    vx = velocity * -sin(theta-pi);
                    vy = velocity * cos(theta-pi);
                    vz = 0;
                elseif (theta >= 3*pi/2) && (theta <= 2*pi) % quadrant 4
                    vx = velocity * -cos(theta - (3*pi/2));
                    vy = velocity * -sin(theta - (3*pi/2));
                    vz = 0;
                end
            end
    
            if cw(i) == 2 % counterclockwise orbits
                if (theta <= pi/2) % Q1
                    vx = velocity * -sin(theta);
                    vy = velocity * cos(theta);
                    vz = 0;
                elseif (theta >= pi/2) && (theta <= pi)% Q2
                    vx = velocity * -cos(theta-(pi/2));
                    vy = velocity * -sin(theta-(pi/2));
                    vz = 0;
                elseif (theta >= pi) && (theta <= 3*pi/2) % Q3
                    vx = velocity * sin(theta-pi);
                    vy = velocity * -cos(theta-pi);
                    vz = 0;
                elseif (theta >= 3*pi/2) && (theta <= 2*pi) % Q4
                    vx = velocity * cos(theta - (3*pi/2));
                    vy = velocity * sin(theta - (3*pi/2));
                    vz = 0;
                end
            end
                
            % initial velocity of star
            v(j, :) = [vx + mv0(i, 1), vy + mv0(i, 2), vz + mv0(i, 3)];
    
        end
    
        if i + 1 <= length(m)
            a = a + stars(i);
        else
        end
    
    end
end


        



            
