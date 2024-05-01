classdef imgOI

    properties
        FileName
        Data
        Xaxis
        Yaxis
        ROIList
        Peaks
        regProps
    end

    methods

        function obj = imgOI(FileName)

            obj.FileName = FileName;

            try
                b = load(strcat(FileName, '_obj'));
                obj = b.obj;
            catch
                imgStruct = load(strcat(FileName, '.mat'));

                obj.Data = imgStruct.Data;
                obj.Xaxis = imgStruct.Xaxis;
                obj.Yaxis = imgStruct.Yaxis;
            end

            % Load or create binary mask
            % try % try loading exisiting mask file
            %     obj.reg_props = obj.loadProps;
            % catch % if not then run binarize
            %     obj.reg_props = obj.updateRegProps;   
            % end
            
            % Fill ROIList
            % obj.ROIList = obj.fillROIList;

        end

        function props = loadProps(obj)

            maskFile = strcat(obj.FileName, '_mask.mat');
            try
                maskStruct = load(maskFile);
                props = maskStruct.roi_props;
            catch
                error(['No file found, check naming convention or create new' ...
                    ' with .updateRegProps'])
            end
        end

        function newprops = updateRegProps(obj)

            newprops = bi_filtNV(obj.Data);

        end


        function list = updateROIList(obj)

            % Initilize ROIList
            if isempty(obj.regProps)
                error(['reg_props is empty, ' ...
                    ' use .loadProps, or create new one with .updateRegProps'])
            end

            temp(length(obj.regProps), 1) = ROI;

            % Loop through mask regions
            for ii = 1:1:length(obj.regProps)

                a = obj.regProps(ii).WeightedCentroid;
                b = ceil(obj.regProps(ii).EquivDiameter);

                size = length(obj.Data);

                lolim = b;
                uplim = size - b;
    
                if all(a > lolim) && all(a < uplim)
    
                    bounds(1) = ceil(a(1) - b);
                    bounds(2) = ceil(a(2) - b);
                    bounds(3) = floor(bounds(1) + 2 * b);
                    bounds(4) = floor(bounds(2) + 2 * b);

                    

                    reg_data = obj.Data(bounds(2):bounds(4), bounds(1):bounds(3));

                    temp(ii) = ROI(bounds, reg_data);
                    
                end

            end
            
            list = temp(2:end);
            
        end

        function showGaussFit(obj, roiID)

            [X, Y] = obj.getROIAxes(roiID);

            surfGauss2D(X, Y, obj.getROIData(roiID), obj.ROIList(roiID).fit_data)
            
            figure

            obj.showRaw
            w = X(end) - X(1);
            rectangle('Position', [X(1), Y(1), w, w], 'EdgeColor', 'r', ...
                'LineWidth', 1.5)

        end

        function data = getROIData(obj, roiID)

            bounds = obj.ROIList(roiID).bounds;
            data = obj.Data(bounds(2):bounds(4), bounds(1):bounds(3));

        end

        function [X, Y] = getROIAxes(obj, roiID)

            bounds = obj.ROIList(roiID).bounds;
            X = obj.Xaxis((bounds(1):bounds(3)));
            Y = obj.Yaxis((bounds(2):bounds(4)));

        end

        function showRaw(obj, realUnit)

            arguments
                obj
                realUnit = 1
            end

            if realUnit
                imagesc(obj.Xaxis, obj.Yaxis, obj.Data)
                
            else
                imagesc(obj.Data)
            end
            colorbar

        end

        function param = getParam(obj, roiID, paramID)

            arguments
                obj
                roiID = [1:length(obj.ROIList)];
                paramID = [1:5];
            end

            if roiID == 'a'
                roiID = 1:length(obj.ROIList);
            end
            if paramID == 'a'
                paramID = 1:5;
            end

            param(numel(roiID), numel(paramID) + 1) = zeros;

            jj = 1;

            for ii = roiID

                param(jj, paramID) = obj.ROIList(ii).fit_param(1, paramID);
                param(jj, end) = ii;
                jj = jj + 1;
                if obj.ROIList(ii).fit_param(2, 1) > 1
                    try 
                        param(jj, paramID) = obj.ROIList(ii).fit_param(2, paramID);
                        param(jj, end) = ii;
                        jj = jj + 1;
                    catch
                    end
                end
                

            end
        end

        function saveObj(obj)

            save(strcat(obj.FileName, '_obj'), "obj")

        end


    end

end