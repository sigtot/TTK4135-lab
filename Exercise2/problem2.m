% TTK4135 - Helicopter lab
% Hints/template for problem 2.
% Updated spring 2018, Andreas L. Fl�ten

%% Initialization and model definition
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

%% Solve QP problem with linear model and plot
P = [0.1, 1, 10];
[z1, lambda, PhiOut] = solve_qp(P(1), Q1, N, M, c, Aeq, beq, vlb, vub, x0, mx, mu);
[z2, lambda, PhiOut] = solve_qp(P(2), Q1, N, M, c, Aeq, beq, vlb, vub, x0, mx, mu);
[z3, lambda, PhiOut] = solve_qp(P(3), Q1, N, M, c, Aeq, beq, vlb, vub, x0, mx, mu);
plot_many(z1, N, M, mx, mu, x0, P(1), delta_t);

solutions = [z1, z2, z3];

plot_lambdas(solutions, N, M, mx, mu, x0, P, delta_t);

data = load('Exercise2/maymay2.mat');
data = data.ans;
plot_comparison(z2, data, N, M, mx, mu, x0, delta_t);
%% Extract input
u  = [z2(N*mx+1:N*mx+M*mu);z2(N*mx+M*mu)]; % Control input from solution

% Add zero padding
num_variables = 5/delta_t;
zero_padding = zeros(num_variables,1);
unit_padding  = ones(num_variables,1);
u = [zero_padding; u; zero_padding];
t = 0:delta_t:delta_t*(length(u)-1);
z = [x0(1);z2(1:mx:N*mx)];
z = [pi*unit_padding; z; zero_padding];

% Export to simulink
p_c = [t', u];
travel = [t', z];