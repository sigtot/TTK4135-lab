function res = objective_function(z, N, M, mx, mu, lambda_f, q_1, q_2)
%OBJECTIVE_FUNCTION F is for friends who do stuff together.
% U is for you and me
% N is for Numerical Optimization
    x = z(1:mx*N);
    u = z(mx*N+1:mx*N+mu*M);
    
    lambda = x(1:mx:mx*N);
    p_c = u(1:mu:mu*M);
    e_c = u(2:mu:mu*M);
    
    res = 0;
    for i = 1:N
        res = res + lambda(i)^2 - 2 * lambda_f * lambda(i) + lambda_f^2 + q_1 * p_c(i)^2 + q_2 * e_c(i)^2;
    end
end

