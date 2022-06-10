% Reads Non Epoch Raw Data (NERD)from PEP 
% Random Pellet Drop Protocol
% Gets 1st HE (bit 4) after 1 pellet (bit 1), 2 pellet (bit 2), 3 pellet (bit 3).
% Plot averaged Zscore
clc;clear

upper_folder = cd

folderlist = filename2str("*22*");





%% Extract Rawdata

for f = 1:length(folderlist)
% Get mouse numbers from foldername & go into folder

folder = char(folderlist(f));
mouse1 = string(folder(1:4));
mouse2 = string(folder(6:9));
cd(folderlist(f));
    
    

for m = 1:2
    mouselist = [mouse1;mouse2];
    mouse = mouselist(m);
% Extract the data from NERD file
if mouse == "0000"
    continue 
elseif mouse == mouse1
    rawdata = readtable("NonEpochRawData__405A__470A_0.1X.txt");
elseif mouse == mouse2
    rawdata = readtable("NonEpochRawData__405B__470B_0.1X.txt");
end
    rawdata = table2cell (rawdata);
    rawdata = string (rawdata);
    rawdata = str2double(rawdata);


%%
[row,column] = size(rawdata);

index = [];

for k = 1:row
    
    if isnan(rawdata(k,5)) == 0;
        if rawdata(k,5) <= 4
            index = [index;k,rawdata(k,5)];
        end
    end

end


[indexrow,indexcolumn] = size(index);
noHEindex = [];
index_1 = [];
index_2 = [];
index_3 = [];

for i = 1:indexrow-1 % indexrow-1 because the program ends immediately after last pellet so no HE after. 
    
    if index(i,2) <= 3 && index(i+1,2) ~= 4
        noHEindex = [noHEindex,i];
    end
    
    
    
end
index(noHEindex,:) = [];
[indexrow,indexcolumn] = size(index);

for i = 1:indexrow-1
    if index(i,2) == 1
        index_1 = [index_1, index(i+1,1)]; %Takes 1st HE tick after 1 pellet drop
    elseif index(i,2) == 2
        index_2 = [index_2, index(i+1,1)];
    elseif index(i,2) == 3
        index_3 = [index_3, index(i+1,1)];
    end
end

    if length (index_1) > 5
        index_1 = index_1(1:5);
    end

    if length(index_2) > 5
        index_2 = index_2(1:5);
    end
    
    if length(index_3) > 5
        index_3 = index_3(1:5);
    end



index_set = {index_1;index_2;index_3};



%% Graphing Time
pellet_num = ["1pellet", "2pellet", "3pellet"];

Fs = 101.7255;
timebef=-10;
timeaft=20;



for in = 1:3;

    current_index = index_set(in,:);
    current_index = cell2mat(current_index);
  
    zscore_set = [];
    
for e = 1:length(current_index)

epoc_tick = current_index(e);



%X axis
timebef_tick = epoc_tick + round(Fs*timebef);
timeaft_tick = epoc_tick + round(Fs*timeaft);
timeticks=round((timeaft-timebef)*Fs);
x_window=linspace(timebef,timeaft,timeticks);

%Convert 470 signal to Z-score
signal_470 = rawdata(timebef_tick:timeaft_tick,2);
signal_470(1019) = [];
zscore = (signal_470 - mean(signal_470)) / std(signal_470);

zscore_set = [zscore_set;zscore'];

end

if length(zscore_set) == 0
    continue
end


%% Average Zscores and calcualte standard error
zscore_ave = mean(zscore_set);
[zscore_row,zscore_col] = size(zscore_set);
zerror=std(zscore_set)/sqrt(zscore_row);




%% Export z-score set and sort out the excel file

% Go out to main folder
cd(upper_folder)
% Prepare the Excel file
    output_filename = "LHphotC2_RPD.xlsx";
    writematrix("1 Pellet",output_filename,'sheet',mouse,"range","A1");
    writematrix("2 Pellet",output_filename,'sheet',mouse,"range","A7");
    writematrix("3 Pellet",output_filename,'sheet',mouse,"range","A13");

    excel_ranges = ["A2:DMK6","A8:DMK12","A14:DMK18"];

% Append zscore data to existing excel sheet
writematrix(string(zscore_set),output_filename,'sheet',mouse,'Range',excel_ranges(in));

cd(folderlist(f))

%% Plot Ten Stack Graph
    figure(1)
    clf
    
    %Graph of zscore, averaged
    plot(x_window,zscore_ave,'color',[0,0.4,0.7])
    hold on
    
 
    
    %Shaded SEM
    uppererror=zscore_ave+zerror;
    lowererror=zscore_ave-zerror;
    shadederror=[uppererror,fliplr(lowererror)];
    xx=[x_window,fliplr(x_window)];
    fill(xx,shadederror,[0.3,0.8,1],'facealpha',.2)
    plot(x_window,uppererror,'color',[0.3,0.8,1])
    plot(x_window,lowererror,'color',[0.3,0.8,1])
       
    xline(0);

    xlabel("Time (s)")
    ylabel("Z-Score")
    axis([-10 20 -5 15])
    set(gcf, 'Position', [200,200,1300,600])
    set(gca, 'Position', [.1,.1,.8,.8]) 
    title(strcat(mouse,', ',strrep(pellet_num(in),'_',' ')," Average of Five Trials"))

    fig1=strcat(mouse,'_',pellet_num(in),'_ave5');
    print(gcf,'-dpng',fig1)

    
    hold off
    

end




end

cd(upper_folder)

end


