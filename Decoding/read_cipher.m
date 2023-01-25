function c = read_cipher(line_number)
    
    global N
    
    fid = fopen('cipher.txt','r');
    %A = fscanf(fid,'%c',[1 18]);

    
    % Line Number to be read
    linenum = line_number;
    A = textscan(fid,'%s',1,'delimiter','\n', 'headerlines',linenum-1);
    A1 = A{1}{1};
    %display(A1(1:8))

    num = floor(N/4);


    temp = zeros(1,N);
    for i=0:num-1
        hex = A1(1*(i)+1:1*(i+1));
        %display(hex)

        B = hex2dec(hex);
        A_bin = dec2bin(B);
        %display(A_bin)


        b1 = textscan(A_bin,'%c');
        %display(qq{1}(1))
        b1 = str2num(b1{1});

        if length(A_bin) == 4
            temp(4*(i)+1:4*(i+1)) = [b1(1) b1(2) b1(3) b1(4)];  

        elseif length(A_bin) == 3 

            temp(4*(i)+1:4*(i+1)) = [0 b1(1) b1(2) b1(3)];

        elseif length(A_bin) == 2 

            temp(4*(i)+1:4*(i+1)) = [0 0 b1(1) b1(2)];

         elseif length(A_bin) == 1
             temp(4*(i)+1:4*(i+1)) = [0 0 0 b1(1)];

        end
        %display(temp)
        %temp(8*(i)+1:8*(i+1)) = qq;
    end

    if num ~= N/4
        hex = A1(1*num+1:1*(num+1));
            %display(hex)

            B = hex2dec(hex);
            A_bin = dec2bin(B);
            %display(A_bin)


            b1 = textscan(A_bin,'%c');
            %display(qq{1}(1))
            b1 = str2num(b1{1});

            if length(A_bin) == 3 

                temp(4*(num)+1:N) = [b1(1) b1(2) b1(3)];

            elseif length(A_bin) == 2
                
                if N - (4*num) == 3
                    temp(4*(num)+1:N) = [0 b1(1) b1(2)];
                else
                    temp(4*(num)+1:N) = [b1(1) b1(2)];
                end

             elseif length(A_bin) == 1
                 
                 if N - (4*num) == 2
                    temp(4*(num)+1:N) = [0 b1(1)];
                 else 
                     temp(N) = b1(1);
                 end

            end
    end
    c = temp;
    %display(temp)
    fclose(fid);
    
end
