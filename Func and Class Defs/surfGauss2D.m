% create 3D plots for each ROI raw vs. fitted
function surfGauss2D(Xaxis, Yaxis, rawData, fitData)

    figure;
    subplot(1,2,1);
    surf(Xaxis, Yaxis, rawData);
    title(strcat('Raw Data'));
    subplot(1,2,2);
    surf(Xaxis, Yaxis, fitData);
    title(strcat('Fit Data'));

end