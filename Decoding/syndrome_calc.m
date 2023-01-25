function S = syndrome_calc(nod_inv, C)

    global r
    
    S = zeros(1, r);

    for i=1:r
        c_e = sum(C(nod_inv(i,:)));
        if mod(c_e, 2)~=0
            S(i)=1;
        end
    end


end