%% Initialization
clc,clear,close all
format long
%% Options
% path loss exponent
% free space n=2
% urban area cellular radio n esta entre 2.7 a 3.5
% shadowed urgan area cellular radio n esta entre 3 a 5
% inside a building line of sight ,  n esta entre 1.6 a 1.8
% obstructed in building  ,  n esta entre 4 a 6
% obstructed in factory,  n esta entre 2 a 3
PathLossExponent=3;
%% Path loss calculation
PdBm=16.0206;                 % Transmission power Tx [dBm]
PtxW=10^(PdBm/10)/1000;       % Transmission power Tx [w]
r=1:1000;                     % Link distance [m]
freGH=5.9;                    % Frequency [GHz]
freH=freGH*1e9;               % Frequency [GHz]
vluz=3e8;                     % Speed light [m/s]
lambda=vluz/freH;             % Wavelength [m]
GtxdB=1;                      % Gain transmission antenna [dB]
Gtx=10^(GtxdB/10);            % Gain transmission antenna (linear)
GrxdB=1;                      % Gain reception antenna [dB]
Grx=10^(GrxdB/10);            % Gain reception antenna  (linear)

%% Distances from the source to the Antennas according to diversity order
N=4;               % Diversity order
distance=zeros(N,length(r));
distance(1,:)=r;
for h=1:length(r)
   for p=2:N
      aux=sqrt((r(h))^2+((p-1)*(lambda/2))^2); 
      distance(p,h)=aux;         
   end
end
%% Friss Equation
PrW=Gtx*Grx*PtxW*((lambda)./(4*pi*distance)).^2; %

%% Log distance  
%https://www.nsnam.org/doxygen/classns3_1_1_log_distance_propagation_loss_model.html
%d0= reference distance: 1 meter
%received power in log distance
%PrdBm=rx0(tx) - 10 * n * log (d/d0)
% rx0(tx): received power at reference distance d0 
d0=1;
% rx0 calculation [w]
Pr0W=Gtx*Grx*PtxW*((lambda)./(4*pi*d0)).^2;
% rx0 calculation [dBm]
Pr0dBm=10*log10(Pr0W./1)+ 30;

% rx calculation [dBm] & [w] to every distances
PrdBm=Pr0dBm-10*PathLossExponent*log10(distance/d0);
PrW2=10.^(PrdBm/10)/1000; 


%% Fading based on the distances
% m0=3   --> d<50 mts
% m1=1.5 --> 150mts<d<50mts
% m2=1   --> d>150 mts
fading=distance;
fading(fading<=50)=3;
fading(150<fading)=1;
[row, col] = find(fading>50 & fading<=150);
fading(row,col)=1.5;
%% calculation of the optimal parameters
[m_T,omega_T] = OptimalValues(N,fading,PrW2);

%% Export data to file.bin
longitud=length(m_T);
  
%Sample
m_T;

% Write a .bin file
fileID = fopen('parameters_naka.bin','w');
fwrite(fileID,longitud,'uint32'); 
fwrite(fileID,m_T,'double'); 
fwrite(fileID,omega_T,'double'); 
fclose(fileID);


    