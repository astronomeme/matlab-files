function fftdata = seizefunc(channel,start,ending,t,w,txt)

    mychan = channel;
    %snippet = mychan(start:ending);
    %timer = t;
    %time = timer(start:ending);
    time = t;
    figure(1)
    plot(time,mychan)
    xlabel('Time in Seconds')
    ylabel('Magnitude')
    head = 'EEG Signal over Time: ';
    catty = strcat(head,txt);
    title(catty);
    xlim([start ending])

    firstfft = fft(channel);
    fftdata = firstfft / length(firstfft);
    omega = w;
    wstart = omega(start);
    wend = omega(ending);
    figure(2)
    % plot(omega,fftshift(abs(fftdata)))
    plot(omega(1:length(fftdata)/2+1),abs(fftdata(1:length(fftdata)/2+1)))
    disp(length(abs(fftdata(1:length(fftdata)/2+1))))
    xlabel('Frequency in Hz')
    ylabel('Magnitude')
    head2 = 'FFT of EEG over Frequency Band: ';
    catty2 = strcat(head2,txt);
    title(catty2);
    %xlim([wstart wend]);

    figure(3)
    plot(omega(1:length(fftdata)/2+1),abs(fftdata(1:length(fftdata)/2+1)))
    disp(length(abs(fftdata(1:length(fftdata)/2+1))))
    xlabel('Frequency in Hz')
    ylabel('Magnitude')
    head2 = 'FFT of EEG over Frequency Band: ';
    catty2 = strcat(head2,txt);
    title(catty2);
    xlim([wstart wend]);

    figure(5)
    spectrogram(mychan,256,128,256,256,'centered','yaxis')
    head3 = 'Spectrogram for: ';
    title(strcat(head3,txt));

%     % fft'ing the segment is diff than ffting all the
%     % channel data, cutting that and plotting it
%     % i think the latter option is more useful maybe?

%     chanfft = fft(channel);
%     snipfft = chanfft(start:ending);
%     fftdata = snipfft/length(snipfft);
%     omega = w(start:ending);
%     figure(2)
%     % plot(omega,fftshift(abs(fftdata)))
%     plot(omega(1:length(fftdata)/2+1),abs(fftdata(1:length(fftdata)/2+1)))
%     disp(length(abs(fftdata(1:length(fftdata)/2+1))))
%     xlabel('Frequency in Hz')
%     ylabel('Magnitude')
%     head2 = 'FFT of EEG over Frequency Band: ';
%     catty2 = strcat(head2,txt);
%     title(catty2);

end