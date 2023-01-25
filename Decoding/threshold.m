function T = threshold(W_S, iter)
    
    %global w
    global t
    %global delta
    
    % The thereshold of original BGF used in BIKE 
    T = max(0.0069722*W_S + 13.530, 36);
    
    
    
% Our threshold

%     delta = 1/(2*t);
% 
%     sigma1 = 1.9296;
% 
%     sigma2 = 13.53;
% 
%     T = max((sigma1 * delta * W_S) + (sigma2-0.25*iter), 36);
end