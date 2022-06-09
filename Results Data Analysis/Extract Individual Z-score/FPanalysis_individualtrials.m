clc;clear

experiment_day = 'Cue Reinstatement';

mouselist = filename2str('*2201*'); %Takes folders with the same characters in them
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
    for b = 1:length(datafilelist);
        
        % Convert Results Data filenames to char
        results_datafile = char(datafilelist(b)); 
        
        % Get bit number and box number (and mouse number) from filename
        bit = results_datafile(22);
        boxnum = results_datafile(16);
        if boxnum == '1'
            mouse = mouse1;
        else
            mouse = mouse2;
        end

        % Extract Z-score
        box_bit = extract_ds5_each_zscore(datafilelist(b));

        % Go to parent folder, write to excel file, go back to mouse folder
        cd(parent_folder);
        
        excelfile = strcat('CrisprC1_',experiment_day,'_bit',bit,'.xlsx');
        writematrix(box_bit,excelfile,'Sheet',mouse);
        
        cd(both_mice);
        
    end

  cd(parent_folder);
end