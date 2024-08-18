function chain = mcmcfunction(model,guess,datarray,nsim)

    % getting variables for the number of params and data points
    nparam = length(guess);
    N = length(datarray(:,1));

    % so, we need some initial guesses to move on from
    % we provide some points around which to look for minimums in our 'guesses'
    % and fminsearch spits back out the function value at the minimum, and the 
    % parameter at the minimum too
    % why do a minimum? because our ss(theta) function is residual squares
    % we want to minimize this to get a good param - it's like least squares
    [bmin,ssmin] = fminsearch(model,guess,[],datarray);
    sigmasq = ssmin / (N-2); % ssmin = RSS 

    % here we set up the covariance matrix, which defines how our
    % parameters interact. we will multiply any new parameters by this to
    % scale them / help determine their probability with respect to the
    % original parameters above.
    identity = eye(nparam);
    %alpha = sigmasq;
    alpha = 0.0001;
    %disp(sigmasq)
    % sqrt(alpha) = sig, so alpha = sigsq
    covar = chol(alpha * identity);

    oldparam = bmin;
    chain(1,:) = bmin; % our first chain link holds only the oldest params
    % its dims are nsim rows by nparam cols
    numreject = 0;
    
    % the provided outline inludes keeping track of all our ss's
    % not sure why we're doing this but i'll go ahead
    ssinit = model(oldparam,datarray);
    sstorage = zeros(nsim,1);
    sstorage(1) = ssinit;

    for mysim = 2:nsim
        newparams = oldparam + randn(1,nparam) * covar;
        % new values scaled by the covariance matrix
        % which is related to the spread of the curve
        % how far these new parameters are from the old in a multi-d
        % gaussian distrobution
        ssold = ssinit;
        ssnew = model(newparams,datarray);
        sigmalike = sigmasq;
        expterm = (-1/(2*sigmalike)) * (ssnew-ssold);
        ratio = min(1,exp(expterm));
        ratioarray(mysim) = ratio;
        u = rand;
        if u<ratio
            % accept if the ratio is greater than u
            % we do this random process here to mitigate param values which
            % aren't actually better being accepted. i don't understand
            % this totally and should ask about it
            chain(mysim,:) = newparams; % we add the new, better params to the chain
            oldparam = newparams;
            ssinit = ssnew; % we stay within this new area of the distrobution
        else
            chain(mysim,:) = oldparam;
            numreject = numreject+1;
            ssinit = ssold;
        end
        sstorage(mysim) = ssinit;
    end

    figure(4)
    scatter(chain(:,1),ratioarray);
    title('Parameter 1 versus Probability')
    figure(5)
    scatter(chain(:,1),sstorage);
    title('Parameter versus Link Function')
end