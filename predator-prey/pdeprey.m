% i tried writing my own version of this and it took far too long
% i was able to optomize it with some help from josh 
% this code is a combination of what i had originally and his approach
% i made a poor decision and dumped my messy original code

alpha = 0.4;
beta = 2.0;
gamma = 0.6;
del = 1;
ufrac = 6/35;
vfrac =  116/245;
h = 1;

maxtime = 150;
dt = 1/35;

u0 = zeros(400,400);
v0 = zeros(400,400);

x = 1:h:400;
y = 1:h:400;
[X,Y] = meshgrid(x,y);
figure

for times = 0:dt:maxtime
if times == 0
    % getting our initial conditions all filled out
    for i = 1:h:length(x)
        for j = 1:h:length(x)
            u0(i,j) = ufrac - (2*10^-7)*(x(i)-0.1*y(j)-180)*(x(i)-0.1*y(j)-800);
            v0(i,j) = vfrac - ((3*10^-5)*(x(i)-400)) - ((1.2*10^-4)*(y(i)-150));
        end
    end
    u = u0;
    v = v0;
    unew = zeros(400,400);
    vnew = zeros(400,400);
end

% average the corners and reset the corner value
% we don't include the diagonal 
% originally i was trying to do this and all the cases below in one 
% huge set of nested for loops
% ends up, hey, we know our corner coords
unew(1,1) = (u(1,1)+u(1,2)+u(2,1))/3; % top left
unew(1,400) = (u(1,399)+u(1,400)+u(2,400))/3; % top right
unew(400,1) = (u(399,1)+u(400,1)+u(400,2))/3; % bottom left
unew(400,400) = (u(400,399)+u(400,400)+u(399,400))/3; % bottom right

vnew(1,1) = (v(1,1)+v(1,2)+v(2,1))/3;
vnew(1,400) = (v(1,399)+v(1,400)+v(2,400))/3;
vnew(400,1) = (v(399,1)+v(400,1)+v(400,2))/3;
vnew(400,400) = (v(400,399)+v(400,400)+v(399,400))/3;


for i = 2:1:length(x)-1

    % bc at sides you either have i=1, j=1, i=400, j=400
    % you can only index one of them and be fine
    % this is where the triangular avg thing from the paper comes from

    unew(1,i) = (u(1,i-1)+u(1,i)+u(1,i+1)+u(2,i))/4; %first row
    unew(400,i) = (u(400,i-1)+u(400,i)+u(400,i+1)+u(399,i))/4; % 400 row
    unew(i,1) = (u(i-1,1)+u(i,2)+u(i+1,1)+u(i,1))/4; % first col
    unew(i,400) = (u(i-1,400)+u(i,399)+u(i+1,400)+u(i,400))/4; % 400 col

    vnew(1,i) = (v(1,i-1)+v(1,i)+v(1,i+1)+v(2,i))/4;
    vnew(400,i) = (v(400,i-1)+v(400,i)+v(400,i+1)+v(399,i))/4;
    vnew(i,1) = (v(i-1,1)+v(i,2)+v(i+1,1)+v(i,1))/4;
    vnew(i,400) = (v(i-1,400)+v(i,399)+v(i+1,400)+v(i,400))/4;


    for j = 2:1:length(x)-1
        u2 = u(i,j)*(1-u(i,j));
        uvfrac = (u(i,j)*v(i,j))/(u(i,j)+alpha);
        ulap = (u(i+1,j)+u(i,j+1))-4*u(i,j)+(u(i-1,j)+u(i,j-1));
        vlap = (v(i+1,j)+v(i,j+1))-4*v(i,j)+(v(i-1,j)+v(i,j-1));

        unew(i,j) = dt*(u2-uvfrac+ulap) + u(i,j);
        vnew(i,j) = dt*((beta*uvfrac)-(gamma*(v(i,j)))+(del*vlap))+v(i,j);
    end
end

header = strcat('time = ', ' ', num2str(times));
sgtitle(header)
% josh also showed me how to do multi-figure plots
subplot(1,2,1)
mesh(X,Y,u)
xlabel('$X_{prey}$', 'Interpreter','latex', 'FontSize', 15)
ylabel('$Y_{prey}$', 'Interpreter','latex', 'FontSize', 15)

view(2)
subplot(1,2,2)
mesh(X,Y,v)
xlabel('$X_{pred}$', 'Interpreter','latex', 'FontSize', 15)
ylabel('$Y_{pred}$', 'Interpreter','latex', 'FontSize', 15)

view(2)
u = unew;
v = vnew;
pause(0.2)

end
