function plot1derr(hAB,var1,ccode,var2)
% a barn door function to plot 1d apparent resistivities for DC resistivity
% DONG Hao
% 2010/06/10
% Beijing
%=========================================================================%
% input parametres:
% hAB:      array of AB/2 for response to be generated 
% var1:     array of apparent resistivity of each dipole
% var2:     array of error for each apparent resistivity
% ccode:    symbols to plot (color code)
switch nargin
    case 0
        error('not enough input arguments, 2 at least')
    case 1
        error('not enough input arguments, 2 at least')       
    case 2
        ccode='b-';
end
if nargin <= 3
        plot(hAB,var1,ccode);
else
        errorbar(hAB,var1,var2,ccode);
end
set(gca,'xscale','log');
set(gca,'xgrid','on','ygrid','on')
xlabel('AB/2 (m)'); 
ylabel('log_1_0 App. Res. (\Omega m)');
set(gca,'ylim', [0 4]);
return