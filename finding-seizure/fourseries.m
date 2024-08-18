function fx = fourseries(minlimx,maxlimx,stepx,numterms,sign)

    howmany = minlimx:stepx:maxlimx;
    fx = zeros(1,length(howmany));
    index = 1;
    A = -1;

    if sign == 1 % if odd
        for xvals = minlimx:stepx:maxlimx
            nsum = 0;
            for eachn = 1:2:numterms
                nsum = nsum + (1/eachn) * sin(eachn*pi*xvals/maxlimx);
            end
            fx(index) = nsum;
            index = index + 1;
        end
        fx = fx .* (-4*A/pi);
    end
    % might in an even and neither option later if needed

end