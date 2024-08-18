seg1 = edfread('chb10_19.edf');
seg2 = edfread('chb10_20.edf');
seg3 = edfread('chb10_21.edf');

% the code below only deals with the 1st col of data for original seg1
% do i need to save them all?
for channel = 1:width(seg1) % this tells you what channel - which 
    % subheading in seg1 youre looking at
    seg1dat(:,channel) = seg1{:,channel};
    seg2dat(:,channel) = seg2{:,channel};
    seg3dat(:,channel) = seg3{:,channel};
end

seg1dt = cell2mat(seg1dat);
seg2dt = cell2mat(seg2dat);
seg3dt = cell2mat(seg3dat);

% seg 1 has 23 columns
% each of these is a different channel, it seems
% one for each electrode?
% each col has 7200 entries for 7200 seconds - 120 minutes
% each entry contains a list of 256 items, collected in that single second

% seg1dt takes this and makes it all into one very very long array
% it does this by, for each channel, sort of 'opening up' the lists
% so the first 256 in seg1dt(:,1) are the cell 1,1 in seg1
% second 256 in seg1dt(:,1) are the cell 2,1 in seg1

% fs contains, for each channel, the frequency step (?)

len13 = length(seg1dt(:,1));
len2 = length(seg2dt(:,1));
info1 = edfinfo('chb10_19.edf');
info2 = edfinfo('chb10_20.edf');
info3 = edfinfo('chb10_21.edf');
fs1 = info1.NumSamples/seconds(info1.DataRecordDuration);
fs2 = info2.NumSamples/seconds(info2.DataRecordDuration);
fs3 = info3.NumSamples/seconds(info3.DataRecordDuration);
w1 = 0:fs1/len13:((fs1)*len13-1)/len13;
w2 = 0:fs2/len2:((fs2)*len2-1)/len2;
w3 = 0:fs3/len13:((fs3)*len13-1)/len13;

t1 = 0:(1/fs1):(len13-1)/fs1;
t2 = 0:(1/fs2):(len2-1)/fs2;
t3 = 0:(1/fs3):(len13-1)/fs3;

% where can i see the seizure?
% ------------------------------------
% seg1dt chan 1, seg1dt chan 8, thick peaks at 9, seg1dt chan 11, seg1dt
% chan 12, seg1dt chan 16, seg1dt chan 20 and 21
% ------------------------------------
% in general amps in seg2dt are higher
% seg2dt chan 1, thick peaks at 3, SEG2DT CHAN 4, seg2dt chan 5, seg2dt 
% chan 7, seg2dt chan 9 and 10, pulses at 11, SEG2DT CHAN 12, seg2dt chan
% 15, SEG2DT CHAN 16, 19 is just interesting,SEG2DT CHAN 20 AND 21,
% very thick spikes, wide, followed by periods of laying low with one one
% single large, thin peak for the whole 2 hours
% ------------------------------------
% seg3dt chan 3 and 4, seg3dt chan 7 and 8, maybe 18 and 19, 20 and 21
% with this one it's harder to tell

myseg = seg2dt(:,12);

% this loop takes whatever segment you're looking at
% and makes it so each col of a new array
% holds each sequential 256
for splitter=0:1:7198
    step = 256*splitter;
    nextstep = 256 * (splitter+1);
    timearray(:,splitter+1) = step:1:nextstep;
    splitarray(:,splitter+1) = myseg(step+1:1:nextstep+1);
end

txt = ' segment 2, channel 12';
seize12fft = seizefunc(myseg,1,7201,t2,w2,txt);
%figure(4)
%plot(timearray(:,4200:4500)/256,splitarray(:,4200:4500));
% the more data i include (larger snippet) the larger the freq band is
% shouldn't the freq band be something like 1-20? reasonable numbers?

% possible seizure indicator - low but with scattered higher peaks
% gets really thick, high amp, and then suddenly low again
% with none of those scattered high peaks anymore



