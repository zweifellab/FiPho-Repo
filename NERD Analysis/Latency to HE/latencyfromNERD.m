function median_latency = latencyfromNERD (NonEpochRawData)

%% Extract the data from Non Epoch Raw Data file (from PEP)
rawdata = readtable(NonEpochRawData); 
rawdata = table2cell (rawdata);
rawdata = string (rawdata);
rawdata = str2double(rawdata); % Convert to readable format

%%
median_latency = NaN; %If index becomes empty and function stops prematurely, return average latency as NaN
[row,~] = size(rawdata); %We need number of rows so we can iterate later
index = []; %Blank matrix to build index of bits

for k = 1:row
    if rawdata(k,5) == 3 || rawdata(k,5) == 4 %If bit is 3 or 4
        index = [index;k,rawdata(k,5)]; %Add the time and bit to the index
    end
end


%% Remove trials where there is no HE between pellet drop and next pellet drop

noHEindex = [];

if isempty(index)
    return
end

while isempty(index)~=1 & index(end,2) == 3
    index(end,:) = [];
end

while isempty(index)~=1 & index(1,2) == 4 
    index(1,:) = [];
end

if isempty(index)
    return
end

[indexrow,~] = size(index);
for i = 1:indexrow-1 
    
    if index(i,2) == index(i+1,2)
        if index(i,2) == 3
            noHEindex = [noHEindex,i]; % Record trials with no HE after pellet drop
        elseif index(i,2) == 4
            noHEindex = [noHEindex,i+1]; % Record trials with no HE after pellet drop
        end
    end
    
end
index(noHEindex,:) = []; % Remove those trials



%% Calculate Latency
[indexrow,~] = size(index);
Fs = 101.7255;
period = 1/Fs;
latency_list = zeros(indexrow/2,1);

for ii = 1:2:indexrow
    
    latency = period * ( index(ii+1,1) - index(ii,1) );
    latency_list((ii+1)/2,1) = latency;
    
end
    
    median_latency = median(latency_list);
end
