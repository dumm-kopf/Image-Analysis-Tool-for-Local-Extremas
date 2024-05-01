%% This is a GUI that allows for tweaking of binary mask parameters
function fin_mask = maskOptimizer(input)

    idata = input;

    param1 = 5;
    param2 = [0 100];
    param3 = [0 1];
    param4 = [0 1];
    param5 = 0.3;

    mask = zeros(size(idata));
        
    fig = uifigure;
    gui = uigridlayout(fig, [8 2]);
    gui.RowHeight = {'fit', 'fit', 'fit', 'fit', 'fit', 'fit'};
    gui.ColumnWidth = {'50x','50x'};

    % Displays Image
    % img = uiimage(gui, "Position", [0,0,100,100], "ScaleMethod", "fit");
    % img.Layout.Column = 1;

    % Created linked axes for side by side image
    ax(1) = axes("Parent", gui, "Position", [0 0 50 50]);
    ax(2) = axes("Parent", gui, "Position", [50 0 50 50]);

    ax(1).Layout.Column = 1;
    ax(1).Layout.Row = 1;
    ax(2).Layout.Column = 2;     
    ax(2).Layout.Row = 1;

   
    raw_img = imagesc(idata, "Parent", ax(1));
    mask_img = imagesc(mask, "Parent", ax(2));
    
    linkaxes(ax);


    % Initialize sliders for each parameter

    % neighborhood size for adaptive threshold
    p1Sld = uislider(gui,"Limits",[0 50], "Value", param1, ...
        "Position", [0 0 10 3], "BusyAction", "cancel");
    p1Sld.MajorTicks = 1:2:50;
    p1Sld.Layout.Column = [1 2];

    % Sensitivity in adaptthresh
    p5Sld = uislider(gui,"Limits",[0 1], "Value", param5, ...
        "Position", [0 0 10 3], "BusyAction", "cancel");
    p5Sld.MajorTicks = 0:0.1:1;
    p5Sld.Layout.Column = [1 2];

    % Area
    p2Sld = uislider(gui,"range",...
        "Limits",[0 100], "Value", param2);
    p2Sld.Layout.Column = [1 2];

    % Circularity
    p3Sld = uislider(gui, "range", ...
        "Limits",[0 1], "Value", param3);
    p3Sld.Layout.Column = [1 2];

    % Intensity
    p4Sld = uislider(gui,"range", ...
        "Limits",[0 1], "Value", param4);
    p4Sld.Layout.Column = [1 2];
   

    % nbszSld = uislider(gui,"range", ...
    %     "Limits",[0 1], "Value", param4);
    % nbszSld.Layout.Column = [1 2];

    p1Sld.ValueChangingFcn = @(src,event) updateP1(event,mask_img);
    p2Sld.ValueChangingFcn = @(src,event) updateP2(event,mask_img);
    p3Sld.ValueChangingFcn = @(src,event) updateP3(event,mask_img);
    p4Sld.ValueChangingFcn = @(src,event) updateP4(event,mask_img);
    p5Sld.ValueChangingFcn = @(src,event) updateP5(event,mask_img);
    % nbszSld.ValueChangingFcn = @(src,event) updateNbsz(event,mask_img);

    % Button to Save Parameters
    saveMaskBtn = uibutton(gui, "Text", "Save Mask", ...
        "ButtonPushedFcn", @(src,event) saveMaskBtnPushed());
    saveMaskBtn.Layout.Column = [1 2];
    saveMaskBtn.Layout.Row = 8;

    waitfor(fig);

    fin_mask = mask;

    function saveMaskBtnPushed(hObject, handles)
       closereq();
    end
    
    function updateP1(event, mask_img)
        p = floor(event.Value);
        if rem(p, 2) == 0
            param1 = p + 1;
        else
            param1 = p;
        end
        mask = filtmask();
        overlay = imfuse(mask, idata, "blend");
        set(mask_img, "Cdata", overlay);
    end
    
    function updateP2(event, mask_img)
        param2 = event.Value;
        mask = filtmask();
        overlay = imfuse(mask, idata, "blend");
        set(mask_img, "Cdata", overlay)
    end
    
    function updateP3(event, mask_img)
        param3 = event.Value;
        mask = filtmask();
        overlay = imfuse(mask, idata, "blend");
        set(mask_img, "Cdata", overlay)
    end
    
    function updateP4(event, mask_img)
        param4 = event.Value;
        mask = filtmask();
        overlay = imfuse(mask, idata, "blend");
        set(mask_img, "Cdata", overlay)
    end

    function updateP5(event, mask_img)

        param5 = event.Value;
        mask = filtmask();
        overlay = imfuse(mask, idata, "blend");
        set(mask_img, "Cdata", overlay);
    end

    % function updateNbsz(event, mask_img)
    %     param5 = event.Value;
    %     mask = filtmask();
    %     set(mask_img, "Cdata", mask)
    % end
    
    function out_mask = filtmask()

        T = adaptthresh(idata, param5, "NeighborhoodSize", param1, "Statistic", "gaussian");

        % Binary mask
        bi_mask = imbinarize(idata, T);
        % Filter by area
        bi_mask = bwpropfilt(bi_mask, "Area", param2, 4);
        % Filter by Diameter
        bi_mask = bwpropfilt(bi_mask, "Eccentricity", param3, 4);
        % Filter by MaxIntensity
        bi_mask = bwpropfilt(bi_mask, idata, "MaxIntensity", param4, 4);
    
        % map = [0 0 0;   ...
        %        0 0.8 1];
        % color_mask = label2rgb(bi_mask + 1, map);

        out_mask = bi_mask;
    
    end

end


    


