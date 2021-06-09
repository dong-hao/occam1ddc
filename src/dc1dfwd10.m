function rho=dc1dfwd10(hAB,res,z)
% a barn door 1d layered forward routine for 
% dc resisitivity 1D inversion 
% this is a log10 version (i.e. input res and output rho both in log10
% domain
% apparent resistivities are generated from layered model at different AB/2
% dipole lengths.
%=========================================================================%
% description of parameters:
% 
% hAB:      array of AB/2 for response to be generated 
% res:      array of resistivity of each layer
% z:        array of layer DEPTH of each layer INTERFACE, z1=0(surface of 
%           the earth)
%=========================================================================%
% version 0.2
% DONG Hao
% 2010.06.
% Beijing 
%=========================checking parameters=============================%
switch nargin
    case 0
        error('not enough input arguments, 2 at least')
    case 1
        error('not enough input arguments, 2 at least')       
    case 2
        z = 0; % treat the earth as half space
end
if (size(z)~=size(res))
    if length(z)==length(res)
        res=res';
    else
	    disp('please check the input parametres ')
        error('res and z should have the same size');
    end
end
res = 10.^res;
NL=length(z); % number of layers
NAB=length(hAB); % number of dipole lengths
rho=zeros(1,NAB);
% 19-point filter from Guptasarma, 1982
cf=[ 0.00097112 -0.00102152 0.00906965 0.01404316 0.09012 0.030171582...
   0.99627084 1.3690832 -2.99681171 1.65464068 -0.59399277 0.22329813...
   -0.10119309 0.05186135 -0.02748647 0.01384932 -0.00599074 0.00190463...
   -0.0003216];

% 20-point filter from some unknown source (got that from a Chinese technical 
% report from the 90s )
% cf=[0.003042,-0.001198,0.01284,0.0235,0.08688,0.2374,0.6194,1.1817,...
%     0.4248,-3.4507, 2.7044,-1.1324,0.393,-0.1436,0.05812,-0.02521,...
%     0.01125,-0.004978,0.002072,-0.000318];
s=-2.1719; % filter step (in log)
neff=length(cf);
T=zeros(NL,1);
d=log(10)/6; % 
for idipole=1:NAB
    for k=1:neff
        T(NL)=res(NL); % transform for the (top of) last layer.
        m=exp(k*d+s)/hAB(idipole);
        for ilayer=NL:-1:2
            thick=z(ilayer)-z(ilayer-1);
            sinh1 = 1 - exp(-2*m*thick); % hyperbolic sine "sinh"*2e^-x
            cosh1 = 1 + exp(-2*m*thick); % hyperbolic cosine "cosh"*2e^-x
            % calculate Koefoed resistivity transform T for given layers...
            T(ilayer-1) = res(ilayer-1)*(res(ilayer-1)*sinh1+T(ilayer)*cosh1)...
                /(res(ilayer-1)*cosh1+T(ilayer)*sinh1); 
        end
        rho(idipole) = rho(idipole) + T(ilayer-1)*cf(k); % integrate...
    end
end
rho = log10(rho);
return
