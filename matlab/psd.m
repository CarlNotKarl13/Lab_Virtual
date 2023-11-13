%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%% INPUT DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Input_Image = imread('Big_Red_Board_6-12_Paint_Corrected.png');
board_height = 800;        % [mm]
Nb_of_Sieves = 6; % il faudrait smoother non pas en nombre mais en volume !

% Input parameters
n_bins = 10;
Max_Grain_Size = 20;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Input_Image = Input_Image(:,:,3);
X = size(Input_Image,1);
Y = size(Input_Image,2);
I = logical(Input_Image);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%% VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
binning = linspace(0,1.1*Max_Grain_Size,n_bins);   % binning in mm

V_eq_bin = zeros(1,n_bins);
N_bin = zeros(n_bins,1);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%% CALCULATIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pixel_size = X/board_height;

Bin_Image = I;
Properties_table = regionprops('table',Bin_Image,'EquivDiameter');
Region = bwlabel(Bin_Image);

Nb_of_Particles = size(Properties_table,1)
N = 1:Nb_of_Particles;
Stat_Summary = zeros(Nb_of_Particles,3);
Stat_Summary(:,1) = N;
Stat_Summary(:,2) = Properties_table.EquivDiameter * pixel_size;
Stat_Summary(:,3) = 4/3*pi*(Stat_Summary(:,2)/2).^3 * pixel_size^3;

% Loop to put the particle in their adequate bin
D_eq = Stat_Summary(:,2);
V_eq = Stat_Summary(:,3);
for i=1:Nb_of_Particles
    for j=2:n_bins-1
        if D_eq(i) > binning(j-1) &&  D_eq(i) < binning(j)  
            V_eq_bin(j) = V_eq_bin(j) + V_eq(i);
            N_bin(j) = N_bin(j)+1;
        end
    end
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%% OUTPUT DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fig_1 = figure(1);
plot(binning,100*cumsum(V_eq_bin)/max(cumsum(V_eq_bin)),'k','Linewidth',2)
ylabel('Cumulative Size Distribution [%]')
axis([0 max(binning) 0 110])
yyaxis right
plot(binning,V_eq_bin/max(cumsum(V_eq_bin)),'r','Linewidth',2)
grid
grid minor
xlabel('Diameter  [mm]')
ylabel('PSD')
set(gca,'FontSize',14)

fig_2 = figure(2);
imshow(I)
