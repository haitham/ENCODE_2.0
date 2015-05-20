%%%  Same as col8 
%%%  The key difference is that input data is split into 
%%%    two files, one for expression and one for replication timing
%%%

function resultprint = col9(subdir, expIN, rtIN, percent, sc, rtc)

transcribed = load(expIN);
rawRT = load(rtIN);

%%% initializations start here

switchCutoff = sc/10; 
RTcutoff = rtc/10;

[m, n] = size(transcribed);
%foo = a(:,5:8);

earlyreplicated = ones(m,n);
for i = 1:m  % rows
  for j = 1:n % columns
    if (rawRT(i,j) <= RTcutoff)
      earlyreplicated(i,j) = 0;
    end
  end
end



eclass = zeros(m,1);
cclass = eclass;

%%% initializations end here


for i = 1:m

%%% Check whether the gene is switching in terms of replication timing
%%% A gene is switching if MAX{cell_line} - MIN{cell_line} >= threshold
minRT = min(rawRT(i, :));
maxRT = max(rawRT(i, :));
isSwitching = 0;
if ( maxRT - minRT >= switchCutoff)
  isSwitching = 1;
end


%%% Check whether the gene is regulatory in terms of replication timing
  s = sum (earlyreplicated(i, :));
isRegulatory = 0;
if ( and(s > 0, s < n) )
  isRegulatory = 1;
end

%%% Check whether expressed at least percent % when early replicated 
s = sum ( earlyreplicated(i, :) .* transcribed(i, :));
smin = sum(earlyreplicated(i, :)) * percent / 100;
isExpressedWhenEarlyPercent = 0;
if (s >= smin)
  isExpressedWhenEarlyPercent = 1;
end

%%% Check whether never expressed when late replicated
s = sum ( (1 - earlyreplicated(i, :)) .* transcribed(i, :));
isNeverExpressedWhenLate = 0;
if (s == 0)
  isNeverExpressedWhenLate = 1;
end


%%% Set e-class
if (isRegulatory * isExpressedWhenEarlyPercent * isNeverExpressedWhenLate * isSwitching == 1)
  eclass(i) = 1;
end

%%% Check if expressed at least once when early replicated 
s = sum ( earlyreplicated(i, :) .* transcribed(i, :) );
isExpressedWhenEarly = 0;
if (s > 0)
  isExpressedWhenEarly = 1;
end

%%% Check if expressed at least once when early replicated 
s = sum ( (1 - earlyreplicated(i, :)) .* transcribed(i, :) );
isExpressedWhenLate = 0;
if (s > 0)
  isExpressedWhenLate = 1;
end


%%% Set c-class
if (isExpressedWhenEarly * isExpressedWhenLate * isSwitching == 1)
  cclass(i) = 1;
end

end

resultprint = [percent, switchCutoff*100, RTcutoff*100, sum(eclass), sum(cclass)];
%resultprint = [eclass cclass];


eFile = strcat(subdir, '/eclass_', num2str(percent), '_',  num2str(sc), '_', num2str(rtc, '%2.1f'))
fid = fopen(eFile, 'w');
fprintf(fid,'%d\n', eclass);
fclose(fid);

cFile = strcat(subdir, '/cclass_', num2str(percent), '_', num2str(sc), '_', num2str(rtc, '%2.1f'))
fid = fopen(cFile, 'w');
fprintf(fid,'%d\n', cclass);
fclose(fid);

% switchCutoff, RTcutoff
