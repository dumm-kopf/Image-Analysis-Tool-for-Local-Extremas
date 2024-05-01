%% Testing New Object Classes
clear, clc

img = imgOI('Exported Image_Surface');


try
    img.regProps = img.loadProps;
catch
    img.regProps = img.updateRegProps;
end
img.ROIList = img.updateROIList;



%% Stats

allParams = img.getParam;

%% PL Intensity

iStats = allParams(:, 1) - allParams(:, 5);
iStats = iStats(iStats>0);
clnistats = rmoutliers(iStats);


figure
histogram(clnistats, 100);
xlabel('PL Intensity')
% title('Intensity');

% allP = img.getParam;

%% Width
wStats = allParams(:, 2);
wStats = wStats(wStats>0);
clnwstats = rmoutliers(wStats);

figure
histogram(clnwstats, 100);
xlabel('Width (micrometer)')

%% IvW

figure();
scatter(clnistats, clnwstats);
xlabel('Width (micrometer)')
ylabel('Intensity')

%% Whole Img w Fitted Data


fd = img.Data;
for ii = 1:1:length(img.ROIList)

    if img.ROIList(ii).bounds ~= 0
        fd(img.ROIList(ii).bounds(2):img.ROIList(ii).bounds(4), ...
        img.ROIList(ii).bounds(1):img.ROIList(ii).bounds(3)) = img.ROIList(ii).fit_data;
    end
end

imagesc(fd)


%% 
importZ('2-Z-DependentScansHighDwell.mat');

