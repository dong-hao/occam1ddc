% simple testbench script, for 1D DC (schlumberger) occam inversion
% DONG Hao
% 2011/06/23
% Golmud
% ======================================================================= %
clear
% some settings here
% terminating RMS misfit
Trms=1.5;
% number of maximum iteration
Niter=20; 
% read a 24-layered model file
fid = fopen('aushield.mod');
tmp = textscan(fid,'%f %f','CommentStyle', '#');
fclose(fid);
res0 = tmp{2}';
l = tmp{1}(1:end-1)';
% depth of each layer INTERFACE, note that z1=0
z = cumsum([0 l]);
nz = length(l);
% read a DC sounding data file, which are the 
% 1D schlumberger resistivity data published by constable et al. (1985)
fid = fopen('aushield.dat');
tmp = textscan(fid,'%f %f %f','CommentStyle', '#');
fclose(fid);
% the data are (literally) copied from Table 4 of the Constable 1989 paper
% see: 
% Constable, S. C., Parker, R. L., & Constable, C. G. (1987). Occam’s 
% inversion: A practical algorithm for generating smooth models from 
% electromagnetic sounding data. Geophysics, 52(3), 289–300. 
% still not easy to imagine how you do an AB for 20,000 m(?
hAB = tmp{1}';
rho0 = tmp{2}';
erho = tmp{3}'; 
% now try the inversion
[resi,rho]=occam1ddc(z,res0,hAB,rho0,erho,Trms,Niter);
figure(1);clf;
% and plot the data and response
plot1derr(hAB,rho0,'bo',erho);
hold on
plot1derr(hAB,rho,'rx-');
legend('obs', 'rsp')
% plot the (initial and final) layered model
figure(2);clf;
l(end+1)=l(end)*1.5;
plotlayer_log(res0,l,'b');
hold on;
plotlayer_log(resi,l,'r');
% hasta la vista(?
