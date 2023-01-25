function key = read_sec_key(line_number)

     global w
    
    fid = fopen('private_keys.txt','r');
    %A = fscanf(fid,'%c',[1 18]);

    
    % Line Number to be read
    linenum = line_number;
    A = textscan(fid,'%s',1,'delimiter','\n', 'headerlines',linenum-1);
    A1 = A{1}{1};
    A1_split = strsplit(A1,{',',' '});
    
    key = zeros(1,w);
    for i=1:w
        key(i) = str2num(A1_split{i});
    end
    %display(key)
    fclose(fid);
end