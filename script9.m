%%% Create the E-class and C-class numbers by 
%%% - Vary the RT cutoff from -0.5 to +0.5 at increments of 0.1
%%% - Fix percent to 1 (at least one cell line supports E-class)
%%% - Vary the switchCutoff between -0.5 to 1 at increments of 0.1

function script9


%for sc =0: 1: 10
%for rtc = -5: 1: 5
%  col9(100, sc, rtc);
%end
%end

%for rtc = 0: 1: 5
%  col8(50, sc, rtc);
%end
%for rtc = 0: 1: 5
%  col8(100, sc, rtc);
%end

%j=0;
%x = zeros(264, 5);
%for pct = [1, 10, 25, 50]
%for sc =0: 1: 5
%for rtc = -5: 1: 5
%  j = j+1
%  x(j, :) = col9(pct, sc, rtc);
%end
%end
%end

%x


for pct = 10:10:50
	for sc =5: 1: 10
		for rtc = -2.0: 1.0: 2.0
			%col9('allderm', 'all-exp.csv', 'all-rt.csv', pct, sc, rtc);
			col9('ectoderm', 'ectoderm-exp.csv', 'ectoderm-rt.csv', pct, sc, rtc);
			col9('endoderm', 'endoderm-exp.csv', 'endoderm-rt.csv', pct, sc, rtc);
			col9('mesoderm', 'mesoderm-exp.csv', 'mesoderm-rt.csv', pct, sc, rtc);
		end
		
	end
end
