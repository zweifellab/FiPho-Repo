clc;clear

experiment_day = 'FearCondday2PM';

mouselist = filename2str('7*'); %Takes folders with the number 7 in them
%mouselist = mouselist(3:end); %Removes hidden files '.' and '..' 

parent_folder = cd;

%% Select a mouse folder
for m = 1:length(mouselist)
    % Establish mouse number and go into that mouse's folder
    mouse = mouselist(m)
    cd(mouse)
    
    % Read files in the folder, downsample and extract zscores
    datafilelist = filename2str('ResultsData*');
    bit1 = extract_ds5_each_zscore(datafilelist(1));
   
    
    %% Go back to parent folder. Export data to excel files.
    cd(parent_folder)
        excelfile_bit1 = strcat('BNSTFP_',experiment_day,'_bit1','.xlsx');
        writematrix(bit1,excelfile_bit1,'Sheet',mouse);
        
end