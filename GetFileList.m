function [myFileVector] = GetFileList(listfile,diresory)
    %GETFILELIST Load files from a file list
    
    FileToRead = fopen(listfile, 'r');
    tline = fgets(FileToRead);     % get the first line of the fileList
    c = 1;
    myFileVector{c}  = [diresory strtrim(tline)];
    while ischar(tline)
        c = c + 1;
        tline = fgets(FileToRead);
        if ischar(tline),
            myFileVector{c} = [diresory strtrim(tline)]; %loads each file name into the vector
        end
    end
    fclose(FileToRead);
    
end