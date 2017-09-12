N = 20; % Total number of objects in the planetory system (1 Sun, 9 planets, 10 moons)
dt = .001; 
e = .1;

% Mass and position of each planet
% Initial Velocity is set to zero
p = zeros(N, 3); % position
v = zeros(N, 3); % velocity
m = zeros (N, 2); % mass

color = zeros (N, 3); % Sun will be yellow color, moon will be white color, each panet will be of random color.

size = zeros(N,1);
size(1) = 1000; % size of sun
size(2:10) = 80; % size of each planet
size(11:N) = 10; % size of each moon

% Mass of each planet is set to 1 and position of all bodies are randomly
% placed on axis.
for k = 1:N
    m(k, 1) = k;
    m(k, 2) = 1; % On average mass of planets = 3.335*10^26
    for n = 1:3
        p(k, n) = rand(); % Max distance from sun to planet 5000000000
        v(k, n) = rand();
        color(k, n) = rand();
    end
end

% Mass of Sun is set to 100 and Sun is placed at the center of axis in plot
m(1,2) = 100; % mass = 1.989*10^30 %%%% 3
p(1, 1:3) = 0.5;
color(1,1:3) = [1 1 0]; 

% Moons 
for i = 11:N % from 11 to N, all are moons
    m(i, 2) = 0.01; % mass = 3.0*10^21
    for j = 1:3
        color(i, 1:3) = [1 1 1]; % All moons are white color
    end
end

% Below code determines number of number of moons that would revolve around
% each planet
n = 2;
x = 11;
while (n <= 10 && x <= N)
    b = ceil(5*rand()); 
    for y = 1:b
        p(x,:) = p(n,:) + (-1)^b*0.0005;
        x = x + 1;
    end
    n = n + 1;
end

Total_F = zeros(N, 3);
vel_a = zeros(N, 3);
planet_a = zeros(N, 3);
planet_b = zeros(N, 3);
new_vel_a = zeros(N, 3);
new_planet_a = zeros(N, 3);

% Compute forces between bodies for 500 iterations. 
for time = 1:500
    for a = 1:N
        planet_a(a,:) = [p(a,1), p(a,2), p(a,3)];
        vel_a(a,:) = [v(a,1), v(a,2), v(a,3)];
        mass_a = m(a, 2);
        Total_F(a,:) = [0,0,0];
        for b = [1:a-1,a+1:N] % compute forces between body a to body b
            planet_b(b,:) = [p(b,1), p(b,2), p(b,3)];
            mass_b = m(b, 2);

            diff = planet_b(b,:) - planet_a(a,:);
            a_to_b = sqrt((diff(1)^2) + (diff(2)^2) + (diff(3)^2));
            for x = 1:3
                Total_F(a, x) = Total_F(a, x) + (mass_b*diff(x))/(abs(a_to_b)^3 + e);
            end
        end
        new_vel_a(a,:) = vel_a(a,:) + dt*(Total_F(a,:));
        new_planet_a(a,:) = planet_a(a,:) + dt*vel_a(a,:);
        v(a, 1:3) = new_vel_a(a,:);
        p(a, 1:3) = new_planet_a(a,:);
    end   
    
    scatter3(p(:,1),p(:,2),p(:,3),size(:,1),color,'fill');
    whitebg([0 0 0]); % Black color background
    %axis([-15 15 -15 15 -15 15]);
    zoom (1.4); % Zooms on scatter plot
    grid off;
    drawnow;
    movie(time) = getframe;
end

movie2avi(movie, 'H3_2_Planets_movie.avi');