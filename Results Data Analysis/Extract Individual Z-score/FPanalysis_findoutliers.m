clc;clear;close all

experiment_day = 'AcquisitionDay1';

mouselist = filename2str('*2201*'); %Takes folders with the number 7 in them
%mouselist = mouselist(3:end); %Removes hidden files '.' and '..' 

parent_folder = cd;

%% Select a mouse folder
for m = 1:length(mouselist)
    % Establish mouse number and go into that mouse's folder
    both_mice = mouselist(m);
    cd(both_mice)
    
    both_mice_char = char(both_mice);
    mouse1 = both_mice_char(1:4);
    mouse2 = both_mice_char(6:9);
    
    
    % Read files in the folder, downsample and extract zscores
 
    datafilelist = filename2str('ResultsData*');
    cd(parent_folder)
    for b = 1:length(datafilelist);
        
        cd(both_mice)
        % Convert Results Data filenames to char
        results_datafile = char(datafilelist(b)); 
        
        % Get bit number and box number (and mouse number) from filename
        bitnum = results_datafile(22);
        boxnum = results_datafile(16);
        if boxnum == '1'
            mouse = mouse1;
        else
            mouse = mouse2;
        end

        % Extract Z-score
        box_bit = extract_ds5_each_zscore(datafilelist(b));

    %% Bit 1 Graphs

        [bitrow,bitcolumn] = size(box_bit);
        counter = 25;
        figure_list = [];
        
    for t = 1:bitrow
        
        % Calculate trial average, SD and upper lower SDs
        trial = box_bit(t,:);
        trial_average = mean(trial);
        trial_SD = std(trial);
        upper_sd = trial_average + trial_SD*2;
        lower_sd = trial_average - trial_SD*2;
        % Prepare Graphs
        x = linspace(1,30,bitcolumn);
        y = ones(1,bitcolumn);
        y_trial_average = y*trial_average;
        y_upper_sd = y * upper_sd;
        y_lower_sd = y * lower_sd;
        
        % Graph Counter
        counter = counter + 1;
        % Counter resets after 25 and makes new figure
        if counter > 25 
            counter = 0;
            figure_list = [figure_list, figure('position',[1 1 1600 900])];
            % Creates a new figure in the figure list to be saved later
        end
        
      
        nexttile
        plot (x,y_trial_average,'k')
        hold on
        plot (x,y_upper_sd,'k--')
        plot (x,y_lower_sd,'k--')
        plot (x,trial)
        plot(linspace(10,10,10),linspace(upper_sd,lower_sd,10),'k:')
        
        
        trial_name = strcat(mouse," bit",bitnum," ","trial ",string(t));
        title(trial_name)
        
        
        hold off

        end 
    
    
        for fignum = 1:length(figure_list)            
            figure_name = strcat(mouse,"_bit",bitnum,"_",string(fignum));
            print(figure_list(fignum),figure_name,'-dpng') 
        end
    

    
  cd(parent_folder)  
  close all
  
        
    end
end