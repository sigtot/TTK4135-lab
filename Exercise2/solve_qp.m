function [z, lambda, PhiOut] = solve_qp(P1, Q1, N, M, c, Aeq, beq, vlb, vub, x0, mx, mu)                              % Weight on input
    Q = gen_q(Q1, P1, N, M);              % Generate Q
    tic
    [z, lambda] = quadprog(Q, c, [], [], Aeq, beq, vlb, vub, x0); % hint: quadprog. Type 'doc quadprog' for more info 
    t1=toc;

    % Calculate objective value
    phi1 = 0.0;
    PhiOut = zeros(N*mx+M*mu,1);
    for i=1:N*mx+M*mu
      phi1=phi1+Q(i,i)*z(i)*z(i);
      PhiOut(i) = phi1;
    end
end
