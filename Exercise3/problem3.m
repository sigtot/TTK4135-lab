init02; % Change this to the init file corresponding to your helicopter
set(groot, 'defaultTextInterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

A_c = [0, 1, 0, 0; 0, 0, -K_2, 0; 0, 0, 0, 1; 0, 0, -K_1 * K_pp, -K_1 * K_pd];
B_c = [0; 0; 0; K_1 * K_pp];

% Discrete time system model. x = [lambda r p p_dot]'
delta_t	= 0.25; % sampling time
A1 = (eye(4) + delta_t * A_c);
B1 = delta_t * B_c;

% Number of states and inputs
mx = size(A1,2); % Number of states (number of columns in A)
mu = size(B1,2); % Number of inputs(number of columns in B)

lambda_0 = pi;
lambda_f = 0;

% Initial values
x1_0 = lambda_0;                        % Lambda
x2_0 = 0;                               % r
x3_0 = 0;                               % p
x4_0 = 0;                               % p_dot
x0 = [x1_0 x2_0 x3_0 x4_0]';            % Initial values

% Time horizon and initialization
N  = 100;                               % Time horizon for states
M  = N;                                 % Time horizon for inputs
z  = zeros(N*mx+M*mu,1);                % Initialize z for the whole horizon
z0 = z;                                 % Initial value for optimization

% Bounds
ul 	    = - 30 * pi / 180;              % Lower bound on control
uu 	    = - ul;                         % Upper bound on control

xl      = -Inf*ones(mx,1);              % Lower bound on states (no bound)
xu      = Inf*ones(mx,1);               % Upper bound on states (no bound)
xl(3)   = ul;                           % Lower bound on state x3
xu(3)   = uu;                           % Upper bound on state x3

% Generate constraints on measurements and inputs
[vlb, vub]      = gen_constraints(N, M, xl, xu, ul, uu); % hint: gen_constraints
vlb(N*mx+M*mu)  = 0;                    % We want the last input to be zero
vub(N*mx+M*mu)  = 0;                    % We want the last input to be zero

% Generate the matrix Q and the vector c (objecitve function weights in the QP problem) 
Q1 = zeros(mx,mx);
Q1(1,1) = 1;                            % Weight on state x1
Q1(2,2) = 0;                            % Weight on state x2
Q1(3,3) = 0;                            % Weight on state x3
Q1(4,4) = 0;                            % Weight on state x4
c_i = [- 2 * lambda_f; 0; 0; 0; 0];        % c vector element
c = repmat(c_i, N, 1);                     % Generate c, this is the linear constant term in the QP

%% Generate system matrixes for linear model
Aeq = gen_aeq(A1, B1, N, mx, mu);       % Generate A, hint: gen_aeq
beq_i = [0 0 0 0];             
beq = [A1 * x0; repmat(beq_i', N - 1, 1)];              % Generate b

%% Solve QP problem with linear mode
[z, lambda, PhiOut] = solve_qp(1, Q1, N, M, c, Aeq, beq, vlb, vub, x0, mx, mu);

x1 = [x0(1);z(1:mx:N*mx)];              % State x1 from solution
x2 = [x0(2);z(2:mx:N*mx)];              % State x2 from solution
x3 = [x0(3);z(3:mx:N*mx)];              % State x3 from solution
x4 = [x0(4);z(4:mx:N*mx)];              % State x4 from solution

u  = [z(N*mx+1:N*mx+M*mu);z(N*mx+M*mu)]; % Control input from solution

% Add zero padding
num_variables = 5/delta_t;
zero_padding = zeros(num_variables,1);
unit_padding  = ones(num_variables,1);

u  = [zero_padding; u; zero_padding];
x1 = [pi * unit_padding; x1; zero_padding];
x2 = [zero_padding; x2; zero_padding];
x3 = [zero_padding; x3; zero_padding];
x4 = [zero_padding; x4; zero_padding];

t = 0:delta_t:delta_t*(length(u)-1);

x = [x1, x2, x3, x4];

%% LQ controller
Q = diag([1e3, 1, 1, 1]);
R = diag([1]);

[K, S, e] = dlqr(A1, B1, Q, R);

%% System inputs

u_opt = [t', u];
x_opt = [t', x];