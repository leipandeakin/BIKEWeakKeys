% Post-Quantum Cryptosystems Project, CSRI, Deakin University, 2021. 
%------------------------------------------------------------------------
% This code generates some random messages and generates ciphertexts according 
% to QC-MDPC encryption procedure (i.e., C = m.G + e) 

global r
global N
global t
r = 10009;
%t = 114;
t = 134;


%r = 1117;
%t = 38;
N = 2*r;

%------------------------------------------------------------------------
% Firstly, the public key should be read from the txt file (i.e., q)


temp = 2;
for num=1:25
    
    display(num)
    q = key_read(temp);
    
    qt = zeros(1,r);
    
    for i=0:r-1
        qt(i+1) = q(1+mod((r-i), r));   
    end
    %Building the matrix of Q
    pk = zeros(r,r);
    for i=0:r-1
        pk(i+1,:) = circshift(qt,i);

    end
    
    for num1=1:10000
        tic
        encrypt(pk)
        toc
        disp(num1)
    end
    temp = temp + 1;
end



function encrypt(pk)
    global r
    global t
    global N
    %----------------------------------------
    % Codeword Generation (i.e., z = m.G = [m m.q]) 


    % Message Generation
    m = randi([0 1], 1,r);
    
    res = zeros(1,r); 
    for i=1:r
        
        if mod(sum(m.* pk(i,:)),2) == 0
            res (i) = 0;
        else
            res (i) = 1;
        end
    end
    
    
    %res = multiply(m, q);
    %display(res)

    z = [m res];

    %----------------------------------------
    % Generating random error vector e


        e = zeros(1, N);

        % Then, randomly selecting t positions in e 
        one_positions = randperm(N, t); 

        % Finally, changing the value at each selected position from 0 to 1.
        e(one_positions) = 1;

        %save_error_to_file(one_positions)
        %display(e)
    %----------------------------------------
    % Generating the final ciphertext

    cipher = bitxor(z,e);
    %display(cipher)

    %----------------------------------------
    % Saving the ciphertext into the cipher.text file

    save_to_file(cipher)

end


function key = key_read(line_number)
    
    global r
    
    fid = fopen('public_keys.txt','r');
    %A = fscanf(fid,'%c',[1 18]);

    
    % Line Number to be read
    linenum = line_number;
    A = textscan(fid,'%s',1,'delimiter','\n', 'headerlines',linenum-1);
    A1 = A{1}{1};
    %display(A1(1:8))

    num = floor(r/4);


    temp = zeros(1,r);
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

    if num ~= r/4
        hex = A1(1*num+1:1*(num+1));
            %display(hex)

            B = hex2dec(hex);
            A_bin = dec2bin(B);
            %display(A_bin)


            b1 = textscan(A_bin,'%c');
            %display(qq{1}(1))
            b1 = str2num(b1{1});

            if length(A_bin) == 3 

                temp(4*(num)+1:r) = [b1(1) b1(2) b1(3)];

            elseif length(A_bin) == 2
                
                if r - (4*num) == 3
                    temp(4*(num)+1:r) = [0 b1(1) b1(2)];
                else
                    temp(4*(num)+1:r) = [b1(1) b1(2)];
                end

             elseif length(A_bin) == 1
                 
                 if r - (4*num) == 2
                    temp(4*(num)+1:r) = [0 b1(1)];
                 else 
                     temp(r) = b1(1);
                 end

            end
    end
    key = temp;
    %display(temp)
end


function mul = multiply(x,y)
    global r
    
    mul = zeros(1,r);
    for i = 0:r-1
        temp = 0;
        for j = 0:r-1  
          temp = xor(temp, (x(j+1) * y(1 + mod(i+r-j,r))));
        end
        mul(i+1) = temp;
    end
end


function save_to_file(c)
    
    global N
    
    %num = floor(r/32);
    num = floor(N/4);
    %display(num)
    
    fid = fopen('cipher.txt','a');
    fprintf(fid, '\n');
    for ii=0:num-1
        
        yy = strrep(num2str(c(4*ii+1:4*(ii+1))), ' ', '');
        %display(yy)
        HH = dec2hex((bin2dec(yy))');
        HHH = string(HH);
        %display(HHH)
        
        %fid = fopen('keys.csv','a');
        CT = HHH.';
        fprintf(fid,'%s', CT{:});
      
    end
    % For the last section of c:
    % It is possible that the length of the last section of c is
    % less than 4 bits
    % In such cases, the binary to hex process may return different results
    % So, it should be considered separately:
    
    v = mod(N,4);
    %num2 = floor(v/4);
    
    if v ~= 0
        last_hex_digit = c(4*num + 1:N);

        s = string(last_hex_digit).join('');
        %display(s)
        HH = dec2hex((bin2dec(s))');
        HHH = string(HH);
        CT = HHH.';

        fprintf(fid,'%s', CT{:});
    
    end
    
   
    fclose(fid);

end

function save_error_to_file(e)

    global t

    fid = fopen('errors.txt','a');
    fprintf(fid, '\n');
    for i=1:t-1
        HHH = string(e(i));
        fprintf(fid,'%s', HHH, ", ");
    end
    
    HHH = string(e(t));
    fprintf(fid,'%s', HHH);
    
    fclose(fid);

end

function save_message_to_file(m)

    global r
    
    num = floor(r/4);
    %num = floor(N/4);
    %display(num)
    
    fid = fopen('messages.txt','a');
    fprintf(fid, '\n');
    for ii=0:num-1
        
        yy = strrep(num2str(m(4*ii+1:4*(ii+1))), ' ', '');
        %display(yy)
        HH = dec2hex((bin2dec(yy))');
        HHH = string(HH);
        %display(HHH)
        
        %fid = fopen('keys.csv','a');
        CT = HHH.';
        fprintf(fid,'%s', CT{:});
      
    end
    % For the last section of m:
    % It is possible that the length of the last section of m is
    % less than 4 bits
    % In such cases, the binary to hex process may return different results
    % So, it should be considered separately:
    
    v = mod(r,4);
    %num2 = floor(v/4);
    
    if v ~= 0
        last_hex_digit = m(4*num + 1:r);

        s = string(last_hex_digit).join('');
        %display(s)
        HH = dec2hex((bin2dec(s))');
        HHH = string(HH);
        CT = HHH.';

        fprintf(fid,'%s', CT{:});
    
    end
    
   
    fclose(fid);

end



