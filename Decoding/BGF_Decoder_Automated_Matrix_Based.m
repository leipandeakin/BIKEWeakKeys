% Post-Quantum Cryptosystems Project, CSRI, Deakin University, 2021. 
%------------------------------------------------------------------------
% This code takes some random messages and generates ciphertexts according 
% to QC-MDPC encryption procedure (i.e., C = m.G + e) 

global r
global N
global w
global t
global tau

%r = 4801;
%w = 90;
%t = 84;

%r = 11779;
%w = 134;
%t = 126;

%r = 12323;
%w = 142;
%t = 134;

%r = 10253;
%w = 134;
%t = 126;

r = 10009;
%t = 114;
%w = 126;

t = 134;
w = 142;

tau = 3;


N = 2*r;




%save('variables.mat','l');

%------------------------------------------------------------------------
% Firstly, private key should be read from the txt file 

temp = 2;
num_fail = 0;
for num=1:25
    h_one_pos = read_sec_key(temp);

    h0_one_pos = h_one_pos(1:w/2);
    h1_one_pos = h_one_pos(w/2+1:w);
    
    node_bits_involved_0 = zeros(r,w/2);
    node_bits_involved_1 = zeros(r,w/2);

    pos_0 = h0_one_pos - 1;
    pos_1 = h1_one_pos - 1;

    for i=0:r-1
    
        node_bits_involved_0(i+1,:) = 1 + mod(pos_0 + i, r);
        node_bits_involved_1(i+1,:) = 1 + mod(pos_1 + i, r) + r;

    end

    node_bits_involved = [node_bits_involved_0 node_bits_involved_1];

    for num1=1:10000
        A = (num-1)*10000 + num1+1;
        display(A)
        cipher = read_cipher((num-1)*10000 + num1+1);
        failed = dec(node_bits_involved, cipher);
        
        num_fail = num_fail + failed; 
        display(num_fail)
        
%         if num_fail == 1000
%            num_test = (num-1)*10000 + num1;
%            break 
%         end
        
    end
    
    temp = temp + 1;
end
%display(num_test)
display(num_fail)
 

function decoding_failed = dec(node_bits_involved, cipher)
    
    
    global N
    global w
    global t
    
    Num_iter = 5;
    
    tic
    e = zeros(1, N);



    for iter=1:Num_iter
        %fprintf("--------------------")
        %display(iter)

        C = bitxor(cipher, e);
        S = syndrome_calc(node_bits_involved, C);

        [e, black, gray] = BFIter(S, e, node_bits_involved, iter);

    %     temp = 0;
    %     
    %     for j=1:N
    %         temp = temp + e(j);
    %     end
    %     fprintf("temp after the BFIter")
    %     display(temp)

        % Updating C
        C = bitxor(cipher, e);

        if iter == 1

            S = syndrome_calc(node_bits_involved, C); 
            e = BFMaskedIter(S, e, black, (w/2 +1)/2 + 1 , node_bits_involved);

    %         temp = 0;
    %     
    %         for j=1:N
    %             temp = temp + e(j);
    %         end
    %         fprintf("temp after black mask")
    %         display(temp)

            % Updating C
            C = bitxor(cipher, e);

            S = syndrome_calc(node_bits_involved, C); 
            e = BFMaskedIter(S, e, gray, (w/2 +1)/2 + 1, node_bits_involved);

    %         temp = 0;
    %     
    %         for j=1:N
    %             temp = temp + e(j);
    %         end
    %         fprintf("temp after gray mask")
    %         display(temp)

         end

%             if (sum(e)) == t
%                 break
%             end

    end

    C = bitxor(cipher, e);
    %S = syndrome_calc(h0, h1, C);
    S = syndrome_calc(node_bits_involved, C);
    if S == 0

         decoding_failed = 0;

    else 
        decoding_failed = 1; 
    end

    toc
    end
