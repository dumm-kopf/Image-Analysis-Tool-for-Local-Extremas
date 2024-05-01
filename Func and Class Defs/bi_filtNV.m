function [roi_props] = bi_filtNV(raw_data)

    % size = length(raw_data);
    % peaks_coord = zeros(1, 2);
    % p_cnt = 0;
    

    % Apply bilateral filtering w/ Gaussian kernel (smooths, preserves edges)
    % filt_data = imbilatfilt(raw_data, 100, 1);
    % Apply order 2 filtering (makes peaks more blobby)
    % filt_data = ordfilt2(filt_data,9,ones(3,3), 'symmetric');
    % scale filtered data to [0,1] for binarizing  
    filt_data = rescale(raw_data);

    % binarize data
    bi_mask = maskOptimizer(filt_data);

    roi_props = regionprops(bi_mask, raw_data,...
            'EquivDiameter', 'WeightedCentroid');

    save('mask.mat', 'bi_mask', 'roi_props');
end

    
    
    % default values for binarize and prop filtering
    % [sensitivity, minArea, EquivDiameter, minMaxIntensity]
    % param = [0.3, 20, 3, 0];
    % 
    % % Loop until filtering is good
    % goodbi = 0;
    % while ~goodbi
    % 
    %     bi_mask = imbinarize(filt_data, "adaptive", "Sensitivity", param(1));
    % 
    %     bi_mask = bwpropfilt(bi_mask, "Area", [param(2), 20000], 4);
    % 
    %     bi_mask = bwpropfilt(bi_mask, "EquivDiameter", [param(3), 100], 4);
    % 
    %     bi_mask = bwpropfilt(bi_mask, filt_data, "MaxIntensity", [0, 1], 4);
    % 
    %     roi_props = regionprops(bi_mask, raw_data,...
    %         'MinorAxisLength', 'WeightedCentroid', 'MaxIntensity');
    % 
    %     % Create and plot mask overlayed on raw data
    %     img = rescale(raw_data, 0, 3);
    %     masked_data = labeloverlay(img, bi_mask, Colormap="hsv");
    %     overlay = figure();
    %     image(masked_data);
    %     title('Initial Filtering');
    % 
    %     % Disp Current Parameters
    %     curParamStr = 'Current Parameters: ';
    %     curParamStr = strcat(curParamStr, 'Sensitivity: ', num2str(param(1)), '\n');
    %     curParamStr = strcat(curParamStr, 'MinArea: ', num2str(param(2)), '\n');
    %     curParamStr = strcat(curParamStr, 'Diameter: ', num2str(param(3)), '\n');
    %     curParamStr = strcat(curParamStr, 'Intensity: ', num2str(param(4)), '\n');
    %     fprintf(curParamStr)
    % 
    %     % User input if filtering is good, if not, takes new parameters
    %     goodbi = input('Filtering good?\n');
    %     if ~goodbi
    %          param = input('Enter New Parameters in form [a, b, c, d]:\n');
    %     end
    %     close(overlay)
    % end
