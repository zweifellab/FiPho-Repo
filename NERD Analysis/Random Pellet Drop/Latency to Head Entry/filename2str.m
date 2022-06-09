% Function to read filenames in directory and convert them to string

% For the variable "common_char", pick a character that
% is shared by all the files you want to grab 
% Use * as wildcard.

function files = filename2str (common_char, Destination_Folder)


if ~exist ("Destination_Folder","var") 
%Destination_Folder is an optional input.
    
    files=dir(common_char); 
    files=struct2cell(files);
    files=files(1,:);
    files=string(files);
    
else
    
    Original_Folder = cd
    
    cd (Destination_Folder)
    
    files=dir(common_char); 
    files=struct2cell(files);
    files=files(1,:);
    files=string(files);
    
    cd (Original_Folder)
    
end

end
