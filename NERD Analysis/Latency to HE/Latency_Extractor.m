clc; clear

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Input here %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
experiment_day = 'AcquistionDay3';
cohort = "VglutVgatC1";
common_character = "2204"; % Input character that all target folders have in common


%%%%% You will need these functions in the Path %%%%%
% filename2str.m
% latencyfromNERD.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



original_folder = cd; %Set home folder
common_character = strcat("*",common_character,"*"); %Add asterisks as "wildcards"
folderlist = filename2str(common_character); %Get filenames with common character

%%
latency_list = []; % Blank matrix to build latency list

for f = 1:length(folderlist)
    
    current_folder = folderlist(f); %Select Folder
    current_folder_char = char(current_folder); %Break down Foldername into letters
    mouse1 = str2double(current_folder_char(1:4)); %Take Mouse IDs from fixed positions
    mouse2 = str2double(current_folder_char(6:9));

    cd (current_folder) %Go into selected folder

    if isfile("NonEpochRawData__405A__470A_0.1X.txt") == 1 %If target file exists
        latency1 = latencyfromNERD("NonEpochRawData__405A__470A_0.1X.txt"); %Run latency extracting function
        if isnan(latency1) == 0 %If latency output of the extracting function is a number
            if mouse1 ~= 0 %And mouse ID isn't 0000
                latency_list = [latency_list ; mouse1,latency1]; %Add that shit to the latency list
            end
        end
    end
    if isfile("NonEpochRawData__405B__470B_0.1X.txt") == 1
        latency2 = latencyfromNERD("NonEpochRawData__405B__470B_0.1X.txt");
        if isnan(latency2) == 0
            if mouse2 ~= 0
                latency_list = [latency_list ; mouse2,latency2];
            end
        end
    end
        
    cd (original_folder) %Return to Home Folder
    
end
    
excel_file = strcat(cohort,"_",experiment_day,'_Latency.xlsx'); %Name the excel sheet
writematrix(latency_list,excel_file,'Sheet',experiment_day) %Write the excel sheet

