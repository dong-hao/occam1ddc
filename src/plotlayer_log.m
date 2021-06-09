function plotlayer_log(res,layer,ccode)
% a barn door function to plot 1d layered model 
% in logrithm (log10) scale
% DONG Hao
% 2010/06/10
% Beijing
%=========================================================================%
% input parametres:
% res:      array of resistivity for eache layer (in log10 domain)
% layer:    array of depth in each layer
% ccode:    symbols to plot (color code)
if nargin<3
    ccode='k';
end
if (size(res,2)~=size(layer,2))
    if length(res)==length(layer)
        layer=layer';
    else
	    disp('please check the input parametres ')
        error('res and layer should have the same size');
    end
end
NL=length(layer);
depth=0.1;
h=gca;
for i=1:NL-1
    plot(h,[res(i) res(i)],[depth depth+layer(i)],ccode,'linewidth',2)
    hold(h,'on');
    plot(h,[res(i) res(i+1)],[depth+layer(i) depth+layer(i)],ccode,'linewidth',2)
    depth=depth+layer(i);
end
plot(h,[res(NL) res(NL)],[depth depth+layer(NL)*10],ccode,'linewidth',2);
hold(h,'off');
set(h, 'ydir', 'reverse');
set(h, 'xlim', [0 4])
set(h, 'ylim', [0.1 depth+layer(NL)*1.5]);
set(h, 'yscale', 'log');
xlabel(h,'log_{10} Resistivity(\Omega m)');
ylabel(h,'Depth(m)');
grid on;
