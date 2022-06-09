function zscore_ds5 = extract_ds5_each_zscore (filename)

% Read datafile, extract z score and convert to numbers
rawdata = readtable(filename, 'delimiter', ',','readvariablenames', false);
rawdata = table2cell(rawdata);
rawdata = string(rawdata);
zscore_raw = rawdata(8:end-4);
zscore_raw = split(zscore_raw);
zscore_raw = str2double(zscore_raw);

[row,column] = size(zscore_raw); 
    %If only 1 row, it flips. So flip it back.
    if column == 1
        zscore_raw = zscore_raw'
    end
[row,column] = size(zscore_raw); 

% Take each row, downsample it by 5, add it to a output matrix.
zscore_ds5 = [];
for r = 1:row
    zscore_row = zscore_raw(r,:);
    zscore_row = zscore_row(1:5:end); %Downsample by 5
    zscore_ds5 = [zscore_ds5; zscore_row];
end


end
