function [e, black, gray] = BFIter(S, e, nod_inv, iter)
    
    global N
    global tau
    

    black = zeros(1,N);
    gray = zeros(1,N);

    [cntr, W_S]= counter(S, nod_inv);
    %val = max(cntr);

    T = threshold(W_S, iter);
    
    idx = find(cntr>=T);
    e(idx) = 1 - e(idx);
    black(idx) = 1;
    
    idxx = find(cntr>= T-tau & cntr<T);
    gray(idxx) = 1;
    

end
