function [c, ceq] = ineq_constraint(z, N, M, mx, mu, alpha, beta, lambda_t)
%INEQ_CONSTRAINT Summary of this function goes here
%   Detailed explanation goes here
    
    x = z(1:mx*N);
    u = z(mx*N+1:mx*N+mu*M);
    
    lambda = x(1:mx:mx*N);
    e      = x(5:mx:mx*N);

    c   = zeros(N, 1);
    ceq = [];
    
    %zeros(N, 1); %zeros(N * mx + M * mu, 1);
     %zeros(N * mx + M * mu, 1);
    
    for k = 1:N
        c(k, 1) = alpha * exp(- beta * (lambda(k) - lambda_t)^2) - e(k);
    end
    
end
