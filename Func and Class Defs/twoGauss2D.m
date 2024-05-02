function [fittedData, pFit] = twoGauss2D(raw_data, NameValueArgs)

    arguments
        raw_data;
        NameValueArgs.GuessParam1 = [0, 0, 0, 0, 0];
        NameValueArgs.GuessParam2 = [0, 0, 0, 0, 0];
    end
    %% Initializations
    % 
    % Xaxis = (ROI.Xaxis) * 25;
    % Yaxis = (ROI.Yaxis) * 25;

    [XX, YY] = meshgrid(1:1:length(raw_data), 1:1:length(raw_data));
    
    XY(:,:,1) = XX;
    XY(:,:,2) = YY;
    
    %% Define 2D Gaussian functions for up to 2 peaks
    % sum of two
    twoGauss2D = @(p, xy) p(5) + p(1) * exp(-((xy(:,:,1) - p(2)).^2 + (xy(:,:,2) - p(3)).^2) / (2*p(4)^2))  ...
       + (p(10) + p(6) * exp(-((xy(:,:,1) - p(7)).^2 + (xy(:,:,2) - p(8)).^2)  / (2*p(9)^2)));

    % Prepare the data
    % Assume XY is a Nrow x Ncol x 2 array and Data is a Nrow x Ncol array
    x = XY(:,:,1);
    y = XY(:,:,2);

    coord = FastPeakFind(raw_data);

    if isempty(coord)
       coord = [floor(length(raw_data)/2), floor(length(raw_data)/2)];
    end

    % Initial guess for parameters: [Amplitude, x0, y0, Sigma, floor]
    initialGuess1 = [raw_data(coord(1),coord(2)), x(1, coord(1)), y(coord(2), 2), std(x(:)), min(min(raw_data))];

    % if there is only one peak, set second peak to be zero
    try initialGuess2 = [raw_data(coord(3), coord(4)), x(1, coord(3)), y(coord(4), 1), std(x(:)), min(min(raw_data))];
    catch initialGuess2 = [0, 0, 0, 0, 0];
    end
    % for ii = 1:1:length(NameValueArgs.GuessParam1)
    %     if NameValueArgs.GuessParam1(ii) ~= 0
    %         initialGuess1(ii) = NameValueArgs.GuessParam1(ii);
    %     end
    % end
    % 
    % for ii = 1:1:length(NameValueArgs.GuessParam2)
    %     if NameValueArgs.GuessParam2(ii) ~= 0
    %         initialGuess2(ii) = NameValueArgs.GuessParam2(ii);
    %     end
    % end

    initialGuess = cat(2, initialGuess1, initialGuess2);

    lb = zeros(1, 10);
    ub = [inf, length(raw_data), length(raw_data), length(raw_data), max(max(raw_data))];
    ub = cat(2, ub, ub);
    
    % Perform the fitting
    options = optimset('Display','off');
    [pFit, ~] = lsqcurvefit(twoGauss2D, initialGuess, XY, raw_data, lb, ub, options);

    % pFit(4) = abs(pFit(4));
    
    % Extract fitted parameters
    % amp_fit = pFit(1);
    % x0_fit = pFit(2);
    % y0_fit = pFit(3);
    % sigma_fit = pFit(4);
    
    % Generate fitted data for visualization
    fittedData = twoGauss2D(pFit, XY);
    
    % Plot the results
    % subplot(1,2,1);
    % surf(x, y, raw_data);
    % title('Original Data');

    % subplot(1,2,2);
    % surf(x, y, fittedData);
    % title('Fitted Data');
end
