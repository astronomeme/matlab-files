function [y,t,stepsize] = adaptvec(initt,finalt,h,S0,tol,hmin,hmax)

    % a function to do rk4 adaptive step sizes with vectors
    % currently set up to calculate quad air res
    % while in myadaptive i input func, here i create a seperate function
    % since i need to extract the first/second/third element of S

    myh = h;
    t(1) = initt;
    y(:,1) = S0;
    stepsize(:,1) = myh;
    index = 2;
    flag = 0;
    toomanylow = 0; 
    toomanyhigh = 0;
    if ~exist('hmin','var') && ~exist('hmax','var')
       flag = 1;
    end

    while initt<finalt

        if flag == 0
            if myh<hmin
                myh = hmin;
                toomanylow = toomanylow + 1;
            elseif myh>hmax
                myh = hmax;
                toomanyhigh = toomanyhigh + 1;
            end
        end
        %if flag==0 && toomanyhigh>=5 || flag==0 && toomanylow>=5
        %    break
        %end

        f0 = quadair(initt,S0);
        f1 = quadair(initt+(myh/4),S0+f0.*(myh/4));
        f2 = quadair(initt+(3/8)*myh,S0+((3/32)*myh.*f0)+((9/32)*myh.*f1));
        f3 = quadair(initt+(12/13)*myh,S0+((1932/2197)*myh.*f0)-((7200/2197)*myh.*f1)+((7296/2197)*myh.*f2));
        f4 = quadair(initt+myh,S0+((439/216)*myh.*f0)-(8*myh.*f1)+((3680/513)*myh.*f2)-((845/4104)*myh.*f3));
        f5 = quadair(initt+(myh/2),S0-((8/27)*myh.*f0)+(2*myh.*f1)-((3544/2565)*myh.*f2)+((1859/4104)*myh.*f3)-((11/40)*myh.*f4));
    
        S0hat = S0 + myh.*((16/135)*f0 + (6656/12825)*f2 + (28561/56430)*f3 - (9/50)*f4 + (2/55)*f5);
        myerr = myh*((1/360)*f0 - (128/4275)*f2 - (2197/75240)*f3 + (1/50)*f4 + (2/55)*f5);
        denom = abs(myerr) ./ S0hat;
        rooterm = tol ./ denom;
        myhnew = min(0.9 * myh .* nthroot(abs(rooterm),5));
        %disp(myhnew)
        
        % myhnew is a vector and myh isnt
        % should h ever become a vector or stay a scalar?
        % this affects initt - it makes it into a vector
        % which doesn't make any sense since time is same for x and y
        % i guess this comes down to - are we allowing the time steps
        % for x and y to be different?

        % it should be how much they change over the same interval of time

        if myhnew >= myh
            myh = myhnew;
            S0 = S0hat;
            % disp(myhnew)
            initt = initt + myhnew;
            t(index) = initt;
            y(:,index) = S0;
            stepsize(:,index) = myh;
            %plot(t,y(1,:),'r')
            %hold on
            %plot(t,y(2,:),'b')
            %legend('xvel','yvel')
            index = index + 1;
        elseif myhnew < myh
            % disp(myhnew)
            new = 0.9*myhnew;
            myh = new;
        end

        checker1 = initt+myh;
        if checker1 > finalt
            myh = finalt - initt;
        end
        checker2 = ((finalt - initt)/finalt);
        if checker2 < 1*10^-10
            break
        end

    end
end


function [der] = quadair(t,S) % this is changed for each func you solve
    vx = S(1);
    vy = S(2);
    vz = S(3);
    sigma = 10;
    beta = 8/3;
    p = 28;
    % c = 0.1;
    % g = -9.8;
    % currently this is set up for the lorenz eq
    % but if you uncomment the line below, you'll be able to solve
    % air resistance odes
    % der = [-c*sqrt(vx^2+ vy^2)*vx ; -g - c*sqrt(vx^2+ vy^2)*vy];
    der = [sigma*(vy-vx) ; vx.*(p-vz) - vy ; (vx*vy) - (beta*vz)];
end