% PART ONE -----------------------------------------------------

files = dir('*.xlsx');
colorarray = ['r' 'b' 'g'];

% i have 3 data files, aka three sets of data to spline
% or, i have one big set of data... but this doesn't seem right
% because the points lie on top of one another vertically, which makes me
% think that if i tried to draw a line through all of them, we would run
% into some kind of discontinuity. so i'm gonna spline 3 seperate sets.

for thisdata = 1:3

    % loop through each file of the correct ending in this dir
    % read it, get the cols
    mycolor = colorarray(thisdata);
    myfile = files(thisdata,1);
    ourdata = readtable(myfile.name);
    times = table2array(ourdata(:,1));
    probs = table2array(ourdata(:,2));

    % get value N
    N = size(times);
    N = N(1);

    % make a matrix to hold the equations we do at the end
    % originally i made this outside the big loop so it has (N,3) size
    % but in this usage it only needs (N,1)
    % keeping it to demonstrate my thought process
    pmatrix = zeros(N,1);
    pprimematrix = zeros(N,1);

    % initialize our matrices that we have to build, then send to trisolve
    abcdmatrix = zeros(N);
    rmatrix = zeros(N,1);
    abcdmatrix(1,1) = 1;
    abcdmatrix(N,N) = 1;
    % bc natural spline...
    rmatrix(1) = 0;
    rmatrix(N) = 0;


    for index=2:N-1
        % from 2 to N-1 because we index 'index+1' >>> cant be greater than
        % N when we index! 

        % getting our h values
        hn = times(index+1) - times(index);
        hnminus = times(index) - times(index-1);

        % filling in the r matrix
        rmatrixleft = (6 * (probs(index+1)-probs(index))) / hn;
        rmatrixright = (6 * (probs(index) - probs(index-1))) / hnminus;
        rmatrix(index) = rmatrixleft + (-1*rmatrixright);
        % there's an issue here, see line before secder

        % if we're on the 2nd or N-1th line of the tridiagonal matrix, there are only
        % two items, while in all other rows there's 3. i account for this
        % by making some exceptional cases and filling in the 1st and 2nd col 
        % for row 2, and the N-2 and N-1 col for row N-1

        % essentially, im looking at the diagonal and filling in to the
        % left and right hand side of it

        if index==2
            abcdmatrix(index,index) = 2 * (hnminus+hn);
            abcdmatrix(index,index+1) = hn;
    
        elseif index==N-1
            abcdmatrix(index,index-1) = hnminus;
            abcdmatrix(index,index) = 2 * (hnminus + hn);
        
        else 
            abcdmatrix(index,index-1) = hnminus;
            abcdmatrix(index,index) = 2 * (hnminus+hn);
            abcdmatrix(index,index+1) = hn;
        
        end % end if loop
    end % end for loop

    %disp(rmatrix)
    % okay, so it's fine for set 1
    % set 2 may have issues at 9 and 10 (0.0000 and -0.0000) - also 0 at 7
    % set 3 has issues at 8 and 9
    % this is bc at those spots, rmatrixleft = rmatrixright
    % and THATS because the difference between val at j and val at j-1, j+1
    % are the same 

    % send those into trisolve to get 2nd der
    secder = trisolve(abcdmatrix,rmatrix);
    
    % im going to make arrays with all the coefficients
    % sanity check - should there only be 10?
    for j=1:N-1
        h(j) = times(j+1) - times(j);
        d(j) = probs(j);
        cjfirst = (probs(j+1)-probs(j))/h(j);
        cjsecond = (h(j)*secder(j+1))/6;
        cjthird = (h(j)*secder(j))/3;
        c(j) = cjfirst - cjsecond - cjthird;
        b(j) = secder(j) / 2;
        a(j) = (secder(j+1)-secder(j)) / (6*h(j));
    end

   % okay, i got all my coefficients, for each index
   % i stored them in an array which exists differently for each file
   % (remember, we're looping through 3 files, doing all this for each!)
   % now i need to (1) get the spline between two points
   % those being L and R of 4, 7, 11 and 20 months
   % and (2) get the overall spline and plot it against the data

    figure(1)
    hold on
    title('Survival Probability for Liver Cancer vs Time: Cubic Spline')
    xlabel('Time [Months]')
    ylabel('Survival Probability [Fraction]')
    scatter(times,probs,10,mycolor)
    hold on

   for s = 1:N-1
    X = linspace(times(s),times(s+1),99);
    P = a(s)*(X-times(s)).^3 + b(s)*(X-times(s)).^2 + c(s)*(X-times(s)) + d(s);
    plot(X,P,mycolor);
   end


   % now we look at 4, 7, 11 and 20
   % so i need to look at the k indexes... not index 3 and 6, in the first
   % case, but 2 and 3, because times(k) at k=2 is 3, and times(k) at k=3
   % is 6. if that makes sense? the approximations it gives me are only
   % something like 0.01 off from the graph.
   for k = 2:3
    %X = linspace(times(k),times(k+1),15);
    month4 = a(k)*(4-times(k)).^3 + b(k)*(4-times(k)).^2 + c(k)*(4-times(k)) + d(k);
   end
   for k = 3:4
    %X = linspace(times(k),times(k+1),15);
    month7 = a(k)*(7-times(k)).^3 + b(k)*(7-times(k)).^2 + c(k)*(7-times(k)) + d(k);
   end
   for k = 5:6
    %X = linspace(times(k),times(k+1),15);
    month11 = a(k)*(11-times(k)).^3 + b(k)*(11-times(k)).^2 + c(k)*(11-times(k)) + d(k);
   end
   for k = 8:9
    %X = linspace(times(k),times(k+1),15);
    month20 = a(k)*(20-times(k)).^3 + b(k)*(20-times(k)).^2 + c(k)*(20-times(k)) + d(k);
   end
   
   statement = ['the values of the ',num2str(mycolor),' colored data set, aka set ',num2str(thisdata),' at 4, 7, 11 and 20 months are: '];
   montharray = [month4, month7,month11,month20];
   disp(statement);
   disp(montharray);

end


%splines = dj + (cj * (midx-thisx)) + (bj * ((midx-thisx)^2)) + (aj * ((midx-thisx)^3));
%ajver2 = (secder(j+1)-secder(j)) / (2*hj);
%firstder = (cj) + (secder(j)*(midx-thisx)) + (ajver2 * ((midx-thisx)^2));  
% save spline, 1st der so i can plot it
%pmatrix(j,thisdata) = splines;
%pprimematrix(j,thisdata) = firstder;


% PART TWO -----------------------------------------------------

for thisdata = 4:6
    myfile = files(thisdata,1);
    partwodata = readtable(myfile.name);
     timestwo = table2array(partwodata(:,1));
     probstwo = table2array(partwodata(:,2));
     sigmas = table2array(partwodata(:,3));
     N2 = length(timestwo);
     % isn't linear, we need it to be
     logprobs = log(probstwo);
     logsig = log(sigmas);
    
     % wanna fit it to y=a*exp(bx)
     % no, to a_0 + a_1*x
     % that means we need to find the params a0 and a1
     % so i can use my lin fit
     % i dont need the fancy one for this (whatever it is we'll use for LU)
    
     % not using my seperate line fit function bc this has exponent funny
     % business going on. anyway here's all the sums.
    
    S = sum(1/(sigmas.^2));
    Sx = sum(timestwo./(sigmas.^2));
    Sy = sum(logprobs./(sigmas.^2));
    Sxx = sum((timestwo.^2)./(sigmas.^2));
    Sxy = sum((timestwo.*logprobs)./(sigmas.^2));
    
    %falseSxx = sum((timestwo.*logprobs)./(sigmas.^2));
    %falseSxy = sum((timestwo.^2)./(sigmas.^2));
    
     del = S*Sxx - (Sx)^2;
     a12 = (Sxx.*Sy-Sx.*Sxy)/ del;
     a22 = (S.*Sxy-Sx.*Sy) / del;
     sig2a1 = Sxx / del;
     sig2a2 = S / del;
    
     % lucien was able to figure out why our graph wasn't sitting at the right
     % y-intercept - it was needing to exp() the whole funct versus just a1
     % but i left my incorrect code commented to look at
    
     figure(2)
     lspace = linspace(timestwo(1),timestwo(N2),((N2-1)*100));
     funct = exp((a12 + (a22*lspace))); % exp the whole thing
     % because we get WHOLE linear func then need to plot as exp
     % which is essentially getting rid of ln(x) we did
    
     %functdiff = funct(1) - 1 ;
     %lenfunc = length(funct);
     %for i=1:lenfunc
     %    funct(i) = funct(i) - functdiff;
     %end
    
     errorbar(timestwo,probstwo,sigmas,'ro')
     hold on
     plot(lspace,funct,'b')
     title('Survival Probability for Liver Cancer vs Time: Exponential Fit')
     xlabel('Time [Months]')
     ylabel('Survival Probability [Fraction]')
     hold on
end



