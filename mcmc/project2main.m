% reading in my data
datarray = table2array(readtable('monod.dat'));
datarray(:,2) = [];

% values that are useful later
N = length(datarray(:,1)); % number of data points (might be minus one)
nsim = 20000;
guess = [0,1];
nparam = length(guess); % number of params
model = @(param,data) sum((data(:,2) - ((param(1).*data(:,1)) ./ (param(2) + data(:,1)))).^2);

chain = mcmcfunction(model,guess,datarray,nsim);

% i take the mean of all those in the distro of thetas to get my MAPs
mean1 = mean(chain(:,1));
mean2 = mean(chain(:,2));
var1 = std(chain(:,1));
var2 = std(chain(:,2));
% but these arent the actual map params!
% we need to normalize these, because this whole process has been
% essentially trying to find the stationary distro that fits our data
% and to normalize it we need to divide by the total space
maparam1 = mean1;% / (mean2+mean1);
maparam2 = mean2;% / (mean2+mean1);
mapvar1 = var1;
mapvar2 = var2;

% numer and denom are both 7 row by 1 col arrays. 
% dividing them only works if the division between the arrays is not
% element-wise. why? because we want to do MATRIX multiplication, which
% isn't equal to just multiplying things elementwise. 
% why does this make a bunch of 0's? 

xlin = linspace(0,400,1000);
numer = maparam1 .* xlin;
denom = maparam2 + xlin;
modat = numer ./ denom;
% this thing above is linear, but we need to use the link function to turn
% this linear data into something which mirrors the non-linear relationship
% of the points (?) - link functions map nonlinear to linear which i'm
% guessing means they do it vice-versa too
modat2 = datarray(:,2) - (modat);

figure(1)
scatter(datarray(:,1),datarray(:,2),'m','filled')
hold on
hold on
plot(xlin,modat,'b')
title('Microbial growth vs. Nutrient Concentration')
xlabel('mg of nutrient per L')
ylabel('growth of microbes per hour')

% i also wanna plot the uncertainty
maparam1high = maparam1 + mapvar1;
maparam1low = maparam1 - mapvar1;
maparam2high = maparam2 + mapvar2;
maparam2low = maparam2 - mapvar2;

numerh = maparam1high .* xlin;
denomh = maparam2high + xlin;
modath = numerh ./ denomh;
modat2h = datarray(:,2) - (modath);

numerl = maparam1low .* xlin;
denoml = maparam2low + xlin;
modatl = numerl ./ denoml;
modat2l = datarray(:,2) - (modatl);

hold on
%plot(datarray(:,1),modat2h(:,7),'g')
%plot(datarray(:,1),modat2l(:,7),'g')
hold on
env = fill([xlin fliplr(xlin)], [modath fliplr(modatl)], 'g','LineStyle','none');
legend('Data','MCMC fit','Uncertainty')
alpha(env,0.2);

% graph param vs prob of param / ss(theta)
% graph param vs param - corner plot

figure(2);
histogram(chain(:,1));
figure(3);
histogram(chain(:,2));



