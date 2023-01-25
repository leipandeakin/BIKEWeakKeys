function [cntr, W_S]= counter(S, nod_inv)
    
    global N


    cntr = zeros(1, N);
    S_ind = find(S);
    W_S = length(S_ind);
    for i = S_ind
        H = zeros(1, N);
        H(nod_inv(i,:))=1;
        idx = find(H);
        cntr(idx) = cntr(idx)+1;
    end
end