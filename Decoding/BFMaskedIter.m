function e = BFMaskedIter(S, e, mask, T, nod_inv)
    
    global N
    
    [cntr, W_S]= counter(S, nod_inv);

    idx = find(cntr>=T);
    e(idx) = xor(e(idx), mask(idx));
  

end
