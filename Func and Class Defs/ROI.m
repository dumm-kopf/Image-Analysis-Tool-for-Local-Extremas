classdef ROI 
    
    properties        
        bounds = [0]
        fit_data = zeros(10, 10)
        fit_param = [-1, -1, -1, -1, -1; -1, -1, -1, -1, -1]
    end

    methods 
        function obj = ROI(bounds, reg_data) 

            if nargin > 0

                obj.bounds = bounds;

                rel_peaks = FastPeakFind(reg_data);
                
                try guess1 = [rel_peaks(1), rel_peaks(2)];
                catch 
                    [~, b] = max(max(reg_data));
                    [x, y] = ind2sub(size(reg_data), b);
                    guess1 = [x, y];
                end
                
                try guess2 = [rel_peaks(3), rel_peaks(4)];
                catch 
                    guess2 = [0, 0];
                end

                [obj.fit_data, fit_params] = twoGauss2D(reg_data, ...
                    "GuessParam1",guess1, "GuessParam2", guess2);

                fit_params(2:3) = obj.shift(fit_params(2), fit_params(3));
                fit_params(7:8) = obj.shift(fit_params(6), fit_params(7));

                
                obj.fit_param(1, 1:5) = fit_params(1:5);
                obj.fit_param(2, 1:5) = fit_params(6:10);

            end


        end

        % function real_peaks = getRealPeaks(obj)
        % 
        %     n = length(obj.peaks)/2;
        % 
        %     real_peaks = zeros(n, 2);
        % 
        %     if isempty(obj.peaks)
        %         real_peaks = [0, 0];
        % 
        %     else
        %         for ii = 1:1:n
        % 
        %             % coordinate of each peak ROI
        %             x = obj.bounds(1) + obj.peaks(2*ii - 1) - 1;
        %             y = obj.bounds(2) + obj.peaks(2*ii) - 1;
        %             real_peaks(ii, 1) = x;
        %             real_peaks(ii, 2) = y;
        % 
        %         end
        %     end
        % end

        function [xx, yy] = shift(obj, x, y)

            xx = x + obj.bounds(1);
            yy = y + obj.bounds(2);

        end

    end

end


