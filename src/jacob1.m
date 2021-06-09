function [J,rho]=jacob1(hAB,res,z)
% rewritten Jacobian calculation script for 1D DC (schlumberger array)
% for drhoa/dlog10(res) 
% this is but a by-product of the matlab script for 1D MT 
% used for occam 1D inversion
%=========================================================================%
% description of parameters:
% 
% hAB:      array of AB/2 for response to be generated 
% res:      array of resistivity of each layer
% z:        array of layer DEPTH of each layer INTERFACE, z1=0(surface of 
%           the earth)
% J:        output sensitivity - dlog10(rhoi)/dlog10(resj)
% rho:      apparent resistivity (can save you some time as those are
%           calculated anyway.
%=========================================================================%
% version 0.2
% DONG Hao
% 2011/06/23
% Golmud
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
s = -2.1719; % filter step (in log)
T = zeros(NAB,NL);
d = log(10)/6; %
J = zeros(NAB,NL);
dTdr = zeros(NAB, NL);
neff = length(cf);
for idipole=1:NAB
    for k=1:neff
        T(idipole,NL)=res(NL); % transform for the (top of) last layer.
        m=exp(k*d+s)/hAB(idipole);
        dTdrk = zeros(1,NL);
        dTdrk(NL) = 1;
        for ilayer=NL-1:-1:1
            
            thick=z(ilayer+1)-z(ilayer);
            sinh1 = 1 - exp(-2*m*thick); % hyperbolic sine "sinh"*2e^-x
            cosh1 = 1 + exp(-2*m*thick); % hyperbolic cosine "cosh"*2e^-x
            tanh1 = sinh1/cosh1;
            
            % calculate Koefoed resistivity transform T for given layers...
            T(idipole,ilayer) = res(ilayer)*(res(ilayer)*sinh1+T(idipole,ilayer+1)*cosh1)...
                /(res(ilayer)*cosh1+T(idipole,ilayer+1)*sinh1); 
            ci = (1 + tanh1*T(idipole,ilayer+1)/res(ilayer))^2;
            % dTi/dresi 
            dTdrk(ilayer) = tanh1 * (1 + T(idipole,ilayer+1)^2/res(ilayer)^2 ...
                + 2 * T(idipole,ilayer+1) * tanh1 /res(ilayer))/ci;
            % calculating dTi/dTi+1
            dTiip1 = (1 - tanh1^2)/ci;
            % now multiply dTi/dTi+1 for each layer below this one 
            % (including this layer)
            dTdrk(ilayer+1:NL)=dTdrk(ilayer+1:NL)*dTiip1;
        end
        dTdr(idipole,:) = dTdr(idipole,:) + dTdrk * cf(k); % integrate...
        rho(idipole) = rho(idipole) + T(idipole,1) * cf(k); % integrate...
    end
end
% changed for log10(res)  
for idipole=1:NAB
    for ilayer=1:NL
         J(idipole,ilayer)=res(ilayer)*dTdr(idipole,ilayer)/(rho(idipole));  
    end
end
% changed for log10(rho)   
rho = log10(rho);
return