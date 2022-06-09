clc;clear

experiment_day = 'Cue Reinstatement'
folderlist = filename2str('*');
folderlist = folderlist(3:end); %Removes hidden files '.' and '..' 

output = [];
parent_folder = cd;

for ff = 1:length(folderlist);
current_folder = folderlist(ff);

current_folder_char = char(current_folder); 
mouse1 = current_folder_char(1:4);
mouse2 = current_folder_char(6:9);

   
cd (current_folder)


filelist = filename2str('ResultsData*');


    for f = 1:length(filelist)
        filename = filelist(f);
        filechars = char(filename);
            if filechars(16) == '2'
                mouse = mouse2;
            else
                mouse = mouse1;
            end
        bit = string(filechars(18:22));
        ave_zscore = extract_zscore(filename);
        
        output_line = [mouse,bit,ave_zscore];
        output = [output;output_line];
    end

 
cd (parent_folder)    
end

exp_day_nospace = experiment_day(find(~isspace(experiment_day)))
excel_file = strcat('CrisprC1_',exp_day_nospace,'.xlsx');
writematrix(output,excel_file,'Sheet',experiment_day)