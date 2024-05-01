
clear
clc
FileName = 'BD17DeepNVCenters_BottomLeftCornerDiamond.mat';

% addpath 'C:\Users\Tom\Desktop\current work\Other sub projects\Surface NVs\Argonne Nazar samples round 1\Confocal Images ND79 15 nm deep'
% addpath '/Users/jason/Documents/MATLAB/ImageAcquire image Export tool'
ConfocalImage = load(FileName);
ConversionRatio = 25; % 25µm/V for Richard Set up
% ConversionRatio = 40; % For Daniela set up: 40µm/1 V (25nm deep data)
Scan = ConfocalImage;
Data = Scan.data;
Xaxis = (-799:800)/400 * ConversionRatio;
Yaxis = (-799:800)/400 * ConversionRatio;

%%

save(['Exported ' FileName],'Data',"Xaxis","Yaxis")

writematrix(Data, [FileName ' Data.txt'], 'Delimiter', 'tab');
writematrix(Xaxis, [FileName ' Xaxis.txt'], 'Delimiter', 'tab');
writematrix(Yaxis, [FileName ' Yaxis.txt'], 'Delimiter', 'tab');


%% Plot the data


% Sample data - replace these with your actual data
% Nrow = 10; % Number of rows
% Ncol = 15; % Number of columns
% Data = rand(Nrow, Ncol); % Replace with your data matrix
% Xaxis = 1:Ncol; % Replace with your X-axis values
% Yaxis = 1:Nrow; % Replace with your Y-axis values

% Plotting
figure; % Creates a new figure
imagesc(Xaxis, Yaxis, Data); % Plots the data
set(gca,'YDir','reverse');
colorbar; % Adds a color bar to indicate the scale

% Optional: Customizing the plot
xlabel('X-axis label'); % Replace with your X-axis label
ylabel('Y-axis label'); % Replace with your Y-axis label
title('2D Data Plot'); % Replace with your plot title
