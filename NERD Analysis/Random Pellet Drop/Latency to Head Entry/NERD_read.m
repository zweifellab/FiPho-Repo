clc;clear

rawdata = readtable("NonEpochRawData__405A__470A_0.1X.txt");
rawdata = table2cell (rawdata);
rawdata = string (rawdata);
rawdata = str2double(rawdata);

%1 1 pellet 2 2 pe;;et 3 3pellet 4 1st HE

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
        noHEindex = [noHEindex,i]
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

index_1 = index_1(1:5);
index_2 = index_2(1:5);
index_3 = index_3(1:5);




%% Graphing Time
Fs = 101.7255;
timebef=-10;
timeaft=20;

epoc_tick = 22627

timebef_tick = epoc_tick + (Fs*timebef);
timeaft_tick = epoc_tick + (Fs*timeaft);


timeticks=round((timeaft-timebef)*Fs);
x_window=linspace(timebef,timeaft,timeticks);


signal_470 = rawdata(timebef_tick:timeaft_tick+1,2);
signal_470(1019) = [];
zscore = (signal_470 - mean(signal_470)) / std(signal_470);

zerror=std(zscore)/sqrt(length(zscore));



%%

%% Plot Ten Stack Graph
    figure(1)
    clf
    
    %Graph of ten trials, averaged
    plot(x_window,averagestack,'color',[0,0.4,0.7])
    hold on
    
    %Point of max peak 
    [maxpeak,maxpeak_index]=max(averagestack);
    plot(x_window(maxpeak_index),maxpeak,'xr')
    xline(0,'--r','label',"Stim",'labelhorizontalalignment','left');
    note=strcat("Max Peak = ",num2str(maxpeak));
    annotation('textbox',[0.65,0.8,0.1,0.1],'string',note,'fontsize',10)
    
    %Time from Stim onset to Peak Amplitude
    time2peak=strcat("Time from Stim Onset to Peak Amplitude = ", num2str(x_window(maxpeak_index)),"s");
    annotation('textbox',[0.65,0.7,0.1,0.1],'string',time2peak,'fontsize',10)
    
    %Decay Time Constant
    baseline_zscore=mean(averagestack(1:length(averagestack/3)));
    stimend = round(Fs * (stimwidth-timebef));
    decayto37=((averagestack(stimend)-baseline_zscore)*exp(-1))+baseline_zscore;
    
    for tt=stimend:length(averagestack)
        
        if averagestack(tt) < decayto37
            tau = x_window(tt)-x_window(maxpeak_index);
            tausymbol=char(964);
            time2decay=strcat(tausymbol," = ", num2str(tau),"s");
            annotation('textbox',[0.65,0.65,0.1,0.1],'string',time2decay,'fontsize',10)
            
            break
        end
    end
    
    
    %Shaded SEM
    uppererror=averagestack+zerror;
    lowererror=averagestack-zerror;
    shadederror=[uppererror,fliplr(lowererror)];
    xx=[x_window,fliplr(x_window)];
    fill(xx,shadederror,[0.3,0.8,1],'facealpha',.2)
    plot(x_window,uppererror,'color',[0.3,0.8,1])
    plot(x_window,lowererror,'color',[0.3,0.8,1])
    
    %Shaded area under curve
    AUC_note=strcat("Approx. AUC = ",AUC);
    annotation('textbox',[0.65,0.75,0.1,0.1],'string',AUC_note,'fontsize',10)    
    

    xlabel("Time (s)")
    ylabel("Z-Score")
    axis([-10 20 -10 30])
    set(gcf, 'Position', [200,200,1300,600])
    set(gca, 'Position', [.1,.1,.8,.8]) 
    title(strcat(strrep(mouse,'_',' ')," Average of Five Trials"))

    fig1=strcat(mouse,'_ave5');
    print(gcf,'-dpng',fig1)

    
    hold off
    


























