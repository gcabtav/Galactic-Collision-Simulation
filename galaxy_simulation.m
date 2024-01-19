% bounce: Bouncing ball animation with optional AVI 
% creation
%
% Presented here principally as an illustration of the 
% creation of AVI movies.  Search for 'avi' to locate 
% pertinent blocks of code.
%
%-----------------------------------------------------------
% Parameters defining discrete set of times.
%-----------------------------------------------------------
tmax = 5;
level = 8;
mass = [5, 2];
stars = [5000, 5000];
spin = [1, 1];
dlim = 15;
softening = 0.1;
%--------------------------------------------------
% Initial position and velocity of masses. 
%-----------------------------------------------------------

% Initial Position of cores
x1 = 8;
y1 = 8;
z1 = 0;

x2 = 2;
y2 = 8;
z2 = 0;

position = [x1, y1, z1; 
            x2, y2, z2];

% Initial Velocity of cores
vx1 = -1.25;
vy1 = -0.5;
vz1 = 0;

vx2 = 2;
vy2 = 2/3;
vz2 = 0;

velocity = [vx1 vy1 vz1;
            vx2 vy2 vz2];

[t, pos] = Nbody(@nbodyaccn0, @star_metrics, mass, position, velocity, tmax, level, stars, spin, softening);

%-----------------------------------------------------------
% Set plotenable to non-zero/zero to enable/disable plotting.
%-----------------------------------------------------------
plotenable = 1;

%-----------------------------------------------------------
% Parameter to control speed of animation.  Script execution
% will pause for pausesecs each time a new frame is drawn.
% 
% Setting this parameter to a "largish" value, say 0.1
% (seconds), will produce a slow-motion effect.
% 
% Set it to 0 for maximum animation speed.
%-----------------------------------------------------------
pausesecs = 0;

%-----------------------------------------------------------
% Plot attributes defining the appearance  of the masses.
%-----------------------------------------------------------

% m1 has a (marker) size 
m1size = 8;
% ... it's red ...
m1color = 'b';
% ... and it's plotted as a circle.
m1marker = 'o';

% m2 has a (marker) size
m2size = 8;
% ... it's red ...
m2color = 'r';
% ... and it's plotted as a circle.
m2marker = 'o';


starsize = 2;
starmarker = 'o';
s1color = m1color;
s2color = m2color;

% star defined below

%-----------------------------------------------------------
% Set avienable to a non-zero value to make an AVI movie.
%-----------------------------------------------------------
avienable = 1;

% If plotting is disabled, ensure that AVI generation
% is as well
if ~plotenable
   avienable = 0;
end

% Name of avi file.
avifilename = 'galaxysimtest.avi';

% Presumed AVI playback rate in frames per second.
aviframerate = 60;

%-----------------------------------------------------------
%% SECTION 2. PERFORM THE SIMULATION.
%-----------------------------------------------------------

%-----------------------------------------------------------
% If AVI creation is enabled, then initialize an avi object.
%-----------------------------------------------------------
if avienable
   aviobj = VideoWriter(avifilename);
   open(aviobj);
end

%-----------------------------------------------------------
% FOR EACH TIME STEP ...
%-----------------------------------------------------------

for tstep = 1:length(t)
   % BEGIN TIME STEP
    
   if plotenable
      %%-----------------------
      %% BEGIN Graphics section
      %%-----------------------

      % Clear figure
      clf;

      % Don't erase figure after each plot command.
      hold on;

      % Define plotting area, using a 1:1 aspect ratio for the 
      % plotted region, boxed axes and a 15%-width "border" around 
      % the unit square.
      axis square;
      box on;
      xlim([-0.5*dlim, dlim]);
      ylim([0, 2*dlim]);

       % Make and display title. 
      titlestr = sprintf('Red Mass: %d , Blue Mass: %d', mass(1), mass(2));
      title(titlestr, 'FontSize', 16, 'FontWeight', 'bold', ...
         'Color', [0.25, 0.42, 0.31]);

      % Draw the balls. 
      framedata = pos(:, :, tstep);

      m1data = framedata(1, :);
      m2data = framedata(2, :);

      plot(m1data(1), m1data(2), 'Marker', m1marker, 'MarkerSize', m1size, ...
                    'MarkerEdgeColor', m1color, 'MarkerFaceColor', m1color);
      plot(m2data(1), m2data(2), 'Marker', m2marker, 'MarkerSize', m2size, ...
                    'MarkerEdgeColor', m2color, 'MarkerFaceColor', m2color);

      offset = length(mass)+1;

      xstar1data = framedata(offset:stars(1)+offset, 1);
      ystar1data = framedata(offset:stars(1)+offset, 2);
      scatter(xstar1data, ystar1data, starsize, s1color, starmarker, 'filled');

      xstar2data = framedata(stars(1)+offset:size(pos, 1), 1);
      ystar2data = framedata(stars(1)+offset:size(pos, 1), 2);
      scatter(xstar2data, ystar2data, starsize, s2color, starmarker, 'filled');


      % Force update of figure window.
      drawnow;

      % Record video frame if AVI recording is enabled and record 
      % multiple copies of the first frame.  Here we record 5 seconds
      % worth which will allow the viewer a bit of time to process 
      % the initial scene before the animation starts.
      if avienable
         if t == 0
            framecount = 5 * aviframerate ;
         else
            framecount = 1;
         end
         for iframe = 1 : framecount
            writeVideo(aviobj, getframe(gcf));
         end
      end

      % Pause execution to control interactive visualization speed.
      pause(pausesecs);
      %%-----------------------
      %% End Graphics section
      %%-----------------------
   end

   % END TIME STEP
end

% END SIMULATION

% If we're making a video, finalize the recording and 
% write a diagnostic message that a movie file was created.

if avienable
   close(aviobj);
   fprintf('Created video file: %s\n', avifilename);
end
% END OF SCRIPT

