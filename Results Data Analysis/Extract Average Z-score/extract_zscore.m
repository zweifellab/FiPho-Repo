function average_zscore = extract_zscore (filename)

rawdata = readtable(filename, 'delimiter', ',','readvariablenames', false);
rawdata = table2cell(rawdata);
rawdata = string(rawdata);
zscore = rawdata(8:end-4);
zscore = split(zscore);
zscore = str2double(zscore);

[z_row,z_col] = size(zscore);

if z_row > 1 & z_col > 1
    average_zscore = mean(zscore);
else
    average_zscore = zscore';
end


end