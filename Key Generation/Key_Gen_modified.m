% Post-Quantum Cryptosystems Project, CSRI, Deakin University, 2021. 
%------------------------------------------------------------------------
% This code randomly generates public-private key pairs based on the 
% QC-MDPC variant of the McEliece scheme.
% 
% In a (N,r,w)-QC-MDPC code with n_0 = 2, the parity-check matrix  
% H = [H_0 H_1] is the private key where H_0 and H_1 are circulant blocks  
% of size r x r (i.e., if h_0 and h_1 are the first row of H_0 and H_1,  
% respectively, where weight(h_0) = weight(h_1) = w/2, then the other r-1 
% rows are cycling shifts of h_0 and h_1).
% The public key is the generator matrix G = [I_r | Q] where Q =
% ((H_1)^(-1)_H0)^T).

%------------------------------------------------------------------------
% Taking the code parameters (N, r, w):
% These parameters proposed by Misoczki (see table 2 in his paper)
% N is the length of codewords

for i =1:25
    display(i)
    key_gen()
    
end

function key_gen()

global N
global r
global w
%N = 9602; % r = 4801
%N = 23558; % r = 11779
%N = 24646; % r = 12323
%N = 20506; %r = 10253;
 N = 20018; %r = 9643;
% r is the length of redundant bits in a codeword. For n_0 = 2, we have:
% N = 2r
r = N/2;

% w is the row weight of the parity-check matrix H (note: w must be even)
%w = 90;
%w = 134;
%w = 142;
%w = 134;
%w = 42;
%w = 126;
w = 142;


                       %----------------------------------
                        % Constructing the private key
    tic

    [h0, h0_comp] = Vector_Gen(r,w);

    [h1, h1_comp] = Vector_Gen(r,w);

    % Constructing sk as the private key
    %h1_comp = h1_comp + r;
    sk = [h0_comp h1_comp];

                        %----------------------------------
                            % Constructing the Public Key

    % Next, Q should be calculated which is Q = (h1^(-1).h0)^T
    % Calculating the inverse of h1:

    h1_inv = inverse(h1);

    %----- Just to test
    tst = multiply(h1_inv, h1);
    temp = 0;
    for i=1:r
        temp = temp + tst(i);
    end

    display(tst(1))
    display(temp)

    %------------------------------

    B = multiply(h1_inv, h0);


    q = zeros(1,r);
    % Calculating transpose of B (i.e., q = B^T)
    for i=0:r-1 
        q(i+1) = B(1+mod((r-i), r));
    end

    pk = q;
    toc

    %save_to_file(pk, sk)

    save_pub_key_to_file(pk)
    save_sec_key_to_file(sk)
    %display(sk)
    %display(pk)
end
%----------------------------------
% Functions %

function [h,one_positions] = Vector_Gen(r,w)
                %--------------------------------
                    % Generating the first row of the block 
    % First, defining h as all-zero vectors of length r
    h = zeros(1,r);

    % Then, randomly selecting w/2 positions in h_0 
    one_positions = randperm(r, w/2); 
    
    % Finally, changing the value at each selected position from 0 to 1.
    h(one_positions) = 1;

end

function res = inverse(h)

    global r
% computing the length of r-2, i.e., log(r-2)
    r_bin = de2bi(r-2);
    l = length(r_bin);
    %display(r_bin)


    % Pre-calculating the valuse of k for f^(2^k) for the first k-square
    % Pre-calculating the valuse of k for f^[2^((r-2) mod 2^i)] for the second k-square

    BB1 = zeros(1,l-1);
    BB2 = zeros(1,l-1);
    for i=1:l-1 
    
        if i== 1
        
            BB1(i) = 2;
        else
            
            temp = BB1(i-1)^2;
            BB1(i) = mod(temp , r);
        
        end
        
        if r_bin(i+1) == 1
            
            k2 = mod(r-2, 2^i);
            if k2 == 0
               BB2(i) = 1;

            elseif k2 == 1
               BB2(i) = 2; 

            else
                % To support large values of k2 (because later we need to calculate
                % 2^k2), we can divide k2 by factors of 2  
                % To do this, we need to have an even number
                a = mod(k2, 2);

                % Check to see if k2-a is a factor of 8
                if mod(k2-a, 8) == 0
                    temp = 2^((k2-a)/8);
                    temp = mod(temp, r);

                    temp = mod(temp^2, r);
                    temp = mod(temp^2, r);
                    temp = mod(temp^2, r);
                    BB2(i) = mod(temp * (2^a), r);

                % Check to see if k2-a is a factor of 4
                elseif mod(k2-a, 4) == 0 

                    % In fact, we have: 2^(k2-a) = 2^([2*(2^((b-1)/2)^2)]^4). So, we have:
                    b = (k2-a)/4;

                    temp = 2^((b-1)/2);
                    temp = mod(temp, r);

                    temp = mod(temp^2, r);
                    temp = mod(temp * 2, r);

                    % temp^4
                    temp = mod(temp^2, r);
                    temp = mod(temp^2, r);

                    BB2(i) = mod(temp * (2^a), r);

                else
                    b = (k2-a)/2; % b is odd
                    c = b - 1; % c is even

                    if mod(c, 4)==0
                        % In this case: 2^(k2-a)=[2.((2^(c/4))^2)^2]^2 

                        temp = mod(2^(c/4), r);
                        temp = mod(temp^2, r);
                        temp = mod(temp^2, r);

                        temp = mod(temp * 2, r);
                        temp = mod(temp^2, r);
                        BB2(i) = mod(temp * (2^a), r);

                    else
                        % In this case: 2^(k2-a)=[2*(2*(2^([d-1]/2)^2))^2]^2
                        d = c/2;

                        temp = mod(2^((d-1)/2), r);
                        temp = mod(temp^2, r);

                        temp = mod(temp * 2, r);
                        temp = mod(temp^2, r);

                        temp = mod(temp * 2, r);
                        temp = mod(temp^2, r);

                        BB2(i) = mod(temp * (2^a), r);
                    end


                end
            end
            %k2 = mod(r-2, 2^i);

        end



    %         k1(i) = 2 ^(i-1);
    % 
    %         if r_bin(i+1) == 1
    % 
    %             k2(i) = mod(r-2, 2^i);
    %         end

    end
    

    A1 = zeros(l-1, r);
    A2 = zeros(l-1, r);
    
    for i=1:l-1
        for j=0:r-1
            A1(i,j+1) = mod(j * BB1(i), r); 
            A2(i, j+1) = mod(j * BB2(i), r);
        end
    end

    % ITI implementation
    f = h;
    res = h;

    for i = 1:l-1
        %k = 2 ^(i-1);

        % Calling function f_to_pow_2k() to calculate f^[2^(2^(i-1))]
        %g = f_to_pow_2k(f, k);
        g = pow_2_to_k(f,A1(i,:));

        %display(g)

        % Now, f must be multiplied by g, i.e., f = f*g. 
        % So, function multiply() is called:
        f = multiply(f,g);
        %display(f)

        % Check to see if bit i of (r-2) is one or no
        if r_bin(i+1) == 1

            %k3 = mod((r-2), 2^i);

            % Calling function f_to_pow_2k() to calculate f^[2^(r-2 mod 2^i)]
            %ff = f_to_pow_2k(f, k3);

            ff = pow_2_to_k(f,A2(i,:));

            % Now, ff must be multiplied by res, i.e., res = res*f
            res = multiply(res,ff);
        end

    end
    % Finally, Calling function f_to_pow_2k() to calculate (res)^2
    % Note that k should be 1 to squering res.
    %res = f_to_pow_2k(res, 1);
    res = pow_2_to_k(res, A1(1,:));

   
    %display(res)

    %test(h_1, res)
end

function pow = pow_2_to_k(f,A)
    global r
    
    %{
    fl = floor(r/5);
    
    f1 = f(1:fl);
    f2 = f(fl+1:2*fl);
    f3 = f(2*fl+1:3*fl);
    f4 = f(3*fl+1:4*fl);
    f5 = f(4*fl+1:r);
    
    
    AA1 = A(1:fl);
    AA2 = A(fl+1:2*fl);
    AA3 = A(2*fl+1:3*fl);
    AA4 = A(3*fl+1:4*fl);
    AA5 = A(4*fl+1:r);
    
    
    
    indx1 = AA1 .* f1;
    indx2 = AA2 .* f2;
    indx3 = AA3 .* f3;
    indx4 = AA4 .* f4;
    indx5 = AA5 .* f5;
    
    
    indx = [indx1 indx2 indx3 indx4 indx5];
    %}
    
    indx = A .* f;
    %display(A(1:20))
    temp = f(1);

    pow = zeros(1,r);
    pow(indx+1) = 1;

    if temp == 0
        pow(1) = 0;
    end
    

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

function save_pub_key_to_file(pub_key)

global r
    
    
    %num = floor(r/32);
    num = floor(r/4);
    %display(num)
    
    fid = fopen('public_keys.txt','a');
    fprintf(fid, '\n');
    for ii=0:num-1
        
        yy = strrep(num2str(pub_key(4*ii+1:4*(ii+1))), ' ', '');
        %display(yy)
        HH = dec2hex((bin2dec(yy))');
        HHH = string(HH);
        %display(HHH)
        
        %fid = fopen('keys.csv','a');
        CT = HHH.';
        fprintf(fid,'%s', CT{:});
      
    end
    % For the last section of pub_key:
    % It is possible that the length of the last section of pub_key is
    % less than 4 bits
    % In such cases, the binary to hex process may return different results
    % So, it should be considered separately:
    
    v = mod(r,4);
    %num2 = floor(v/4);
    
    if v ~= 0
        last_hex_digit = pub_key(4*num + 1:r);

        s = string(last_hex_digit).join('');
        %display(s)
        HH = dec2hex((bin2dec(s))');
        HHH = string(HH);
        CT = HHH.';

        fprintf(fid,'%s', CT{:});
    
    end
    
    
    fclose(fid);

end

function save_sec_key_to_file(sec_key)
    global w

    % Writing the private key to the text file
    
    fid = fopen('private_keys.txt','a');
    fprintf(fid, '\n');
    for i=1:w-1
        HHH = string(sec_key(i));
        fprintf(fid,'%s', HHH, ", ");
    end
    
    HHH = string(sec_key(w));
    fprintf(fid,'%s', HHH);
    
    fclose(fid);
end

%{
function save_to_file(pub_key, sec_key)
    

    global r
    global w
    
    num = floor(r/32);
    %display(num)
    
    fid = fopen('keys.txt','a');
    fprintf(fid, '\nPublic Key\n');
    for ii=0:num-1
        
        yy = strrep(num2str(pub_key(32*ii+1:32*(ii+1))), ' ', '');
        %display(yy)
        HH = dec2hex((bin2dec(yy))');
        HHH = string(HH);
        %display(HHH)
        
        %fid = fopen('keys.csv','a');
        CT = HHH.';
        fprintf(fid,'%s', CT{:});
      
    end
    % For the last section of pub_key:
    % It is possible that the length of the last section of pub_key is
    % less than 32 bits (or a number that is not a factor of 4)
    % In such cases, the binary to hex process may return different results
    % So, it should be considered separately:
    
    v = mod(r,32);
    num2 = floor(v/4);
    
    if v ~= 0
        last_part = pub_key(32*num + 1:r);
   
        for ii=0:num2-1
            % S
            s = string(last_part(1+4*ii:4*(ii+1))).join('');
            %display(s)
            HH = dec2hex((bin2dec(s))');
            HHH = string(HH);
            CT = HHH.';
            fprintf(fid,'%s', CT{:});
            %display(CT)
        end
        
        llp = length (last_part);
        %display(llp)
        last_hex_digit = last_part(4*num2 + 1:llp);
        s = string(last_hex_digit).join('');
        %display(s)
        HH = dec2hex((bin2dec(s))');
        HHH = string(HH);
        CT = HHH.';

        fprintf(fid,'%s', CT{:});
    
    end
    
    % Writing the private key to the csv file
    %dlmwrite('keys.csv',sec_key,'-append');
    fprintf(fid, '\nPrivate Key\n');
    for i=1:w
        HHH = string(sec_key(i));
  
        fprintf(fid,'%s', HHH, ", ");
    end
    fclose(fid)











%{
    global r
    global w
    
    num = floor(r/32);
    display(num)
    
    fid = fopen('keys.txt','a');
    fprintf(fid, '\nPublic Key\n');
    for ii=0:num-1
        
        yy = strrep(num2str(pub_key(32*ii+1:32*(ii+1))), ' ', '');
        display(yy)
        HH = dec2hex((bin2dec(yy))');
        HHH = string(HH);
        %display(HHH)
        
        %fid = fopen('keys.csv','a');
        CT = HHH.';
        fprintf(fid,'%s ', CT{:});
      
    end
    yy = strrep(num2str(pub_key(32*num + 1:r)), ' ', '');
    display(yy)
    HH = dec2hex((bin2dec(yy))');
    HHH = string(HH);
    display(HHH)
    
    CT = HHH.';
    fprintf(fid,'%s \n', CT{:});
    
    % Writing the private key to the csv file
    %dlmwrite('keys.csv',sec_key,'-append');
    fprintf(fid, 'Private Key\n');
    for i=1:w
        HHH = string(sec_key(i));
  
        fprintf(fid,'%s', HHH, ", ");
    end
    fclose(fid)
    %}
end
%}
