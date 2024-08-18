% code for problem 1 -------------------------------------------

x1 = 1;
y1 = 1;
z1 = 1;
S0 = [x1 ; y1 ; z1];
h = 0.5;
% no given hmin or hmax
tol = 1*10^-5;
% solving for times greater than 40... until when?
% i need to provide a ti and tf to my code...
% i'm going to set tf to 400... that's a long time
% t = 40:0.5:1000;
[solution,times,steps] = adaptvec(40,400,h,S0,tol);
lorenzgraph(solution,times,steps,1)
%lorenzgraph(solution,times,steps,1)
%lorenzgraph(solution,times,steps,3)

% code for problem 2 ----------------------------------------------

x2 = 1;
y2 = 1;
z2 = 1.00001;
S02 = [x2 ; y2 ; z2];
% my predictions... i predict that this will have a large impact
% but this is mostly because i read about lorenz things and i know
% this is a chaotic system...
% well, i can think about my graphs and the equations
% i think that it will add up quickly
[solution2,times2,steps2] = adaptvec(40,400,h,S02,tol);
 subsol = zeros(3,min(length(solution),length(solution2)));
 for sub=1:min(length(solution),length(solution2))
     subsol(:,sub) = solution2(:,sub)-solution(:,sub);
 end
%lorenzgraph(solution2,times2,steps2,1)


% code for problem 3 -----------------------------------------------

% other initial conditions
% 1.5, 1.5, 1.5
% 1.0001, 1, 1
% 3, 4, 5

x3 = 360;
y3 = 720;
z3 = 100;
S03 = [x3 ; y3 ; z3];
[solution3,times3,steps3] = adaptvec(40,400,h,S03,tol);
%lorenzgraph(solution3,times3,steps3,2)

x4 = 1.0001;
y4 = 1;
z4 = 1;
S04 = [x4 ; y4 ; z4];
[solution4,times4,steps4] = adaptvec(40,400,h,S04,tol);
 subsol4 = zeros(3,min(length(solution),length(solution4)));
for sub=1:min(length(solution),length(solution4))
     subsol4(:,sub) = solution4(:,sub)-solution(:,sub);
 end
% lorenzgraph(subsol4,times4,steps4,3)

x5 = 3;
y5 = 4;
z5 = 5;
S05 = [x5 ; y5 ; z5];
[solution5,times5,steps5] = adaptvec(40,400,h,S05,tol);
subsol5 = zeros(3,min(length(solution),length(solution5)));
for sub=1:min(length(solution),length(solution5))
    subsol5(:,sub) = solution5(:,sub)-solution(:,sub);
end
%lorenzgraph(solution5,times5(1:length(subsol5)),steps5,2)


% is there any way i can determine the width of the spirals, or their 
% internal radius and then compare them somehow?
% how do i give a physical interspretation to this?