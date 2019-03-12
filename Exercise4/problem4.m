set(groot, 'defaultTextInterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

close all;
A_c = [0, 1,    0,           0,             0,              0;
       0, 0,    -K_2,        0,             0,              0;
       0, 0,    0,           1,             0,              0;
       0, 0,    -K_1 * K_pp, -K_1 * K_pd,   0,              0;
       0, 0,    0,           0,             0,              1;
       0, 0,    0,           0,             -K_3 * K_ep,    -K_3 * K_ed];
   
B_c = [0,           0;
       0,           0;
       0,           0;
       K_1 * K_pp,  0;
       0,           0;
       0,           K_3 * K_ep];

delta_t	= 0.25; % sampling time
A_d = (eye(6) + delta_t * A_c);
B_d = delta_t * B_c;

alpha = 0.2;
beta = 20;

% Number of states and inputs
mx = size(A_d,2); % Number of states (number of columns in A)
mu = size(B_d,2); % Number of inputs (number of columns in B)

lambda_0 = pi;
lambda_f = 0;
lambda_t = 2 * pi / 3;

% Initial values
x1_0 = lambda_0;                        % Lambda
x2_0 = 0;                               % r / lambda_dot
x3_0 = 0;                               % p
x4_0 = 0;                               % p_dot
x5_0 = 0;                               % e
x6_0 = 0;                               % e_dot
x0   = [x1_0 x2_0 x3_0 x4_0 x5_0 x6_0]';  % Initial values

% Time horizon and initialization
N  = 40;                                % Time horizon for states
M  = N;                                 % Time horizon for inputs
z  = zeros(N*mx+M*mu,1);                % Initialize z for the whole horizon
z0 = z; % Initial value for optimization
z0(1) = lambda_0;
z0(5) = -pi / 6;

% Bounds
bound   = - 30 * pi / 180; 
ul 	    = [bound; -Inf];                % Lower bound on control
uu 	    = - ul;                         % Upper bound on control

xl      = -Inf*ones(mx,1);              % Lower bound on states (no bound)
xu      = Inf*ones(mx,1);               % Upper bound on states (no bound)
xl(3)   = bound;                        % Lower bound on state x3
xu(3)   = - bound;                      % Upper bound on state x3

% Generate constraints on measurements and inputs
[vlb, vub]      = gen_constraints(N, M, xl, xu, ul, uu); % hint: gen_constraints
vlb(N*mx+M*mu)  = 0;                    % We want the last input to be zero
vub(N*mx+M*mu)  = 0;                    % We want the last input to be zero

% Generate the matrix Q and the vector c (objective function weights in the QP problem) 
Q1 = zeros(mx,mx);
Q1(1,1) = 1;                            % Weight on state x1
Q1(2,2) = 0;                            % Weight on state x2
Q1(3,3) = 0;                            % Weight on state x3
Q1(4,4) = 0;                            % Weight on state x4
Q1(5,5) = 0;                            % Weight on state x5
Q1(6,6) = 0;                            % Weight on state x6

q_1 = 1;
q_2 = 100;
P1 = diag([q_1, q_2]);

G = 2 * gen_q(Q1, P1, N, M); % standard is 1/2 

c_i = [- 2 * lambda_f; 0; 0; 0; 0];        % c vector element
c = repmat(c_i, N, 1);                     % Generate c, this is the linear constant term in the QP

%% Generate system matrixes for linear model
Aeq = gen_aeq(A_d, B_d, N, mx, mu);       % Generate A, hint: gen_aeq
beq_i = [0 0 0 0 0 0];             
beq = [A_d * x0; repmat(beq_i', N - 1, 1)];              % Generate b

[K, S, e] = dlqr(A_d, B_d, Q1, P1);

f = @(x) 1/2 * x' * G * x; % objective_function2(x, N, M, mx, mu, lambda_f, q_1, q_2);

nonlcon2 = @(x) ineq_constraint(x, N, M, mx, mu, alpha, beta, lambda_t);

options = optimoptions('fmincon', 'Algorithm', 'sqp', 'MaxFunEvals', 42000);
tic;
[Z, zval, exitflag] = fmincon(f, z0, [], [], Aeq, beq, vlb, vub, nonlcon2, options);
toc;

lambda          = Z(1:mx:N*mx);
lambda_dot      = Z(2:mx:N*mx);
pitch           = Z(3:mx:N*mx);
pitch_dot       = Z(4:mx:N*mx);
elevation       = Z(5:mx:N*mx);
elevation_dot   = Z(6:mx:N*mx);
pitch_ref       = Z(N*mx + 1:mu:N*mx + M*mu);
elevation_ref   = Z(N*mx + 2:mu:N*mx + M*mu);


% Add zero padding
num_variables = 5/delta_t;
zero_padding  = zeros(num_variables,1);
unit_padding  = ones(num_variables,1);

lambda          = [pi * unit_padding;   lambda;        zero_padding];
lambda_dot      = [zero_padding;        lambda_dot;    zero_padding];
pitch           = [zero_padding;        pitch;         zero_padding];
pitch_dot       = [zero_padding;        pitch_dot;     zero_padding];
elevation       = [zero_padding;        elevation;     zero_padding];
elevation_dot   = [zero_padding;        elevation_dot; zero_padding];

pitch_ref       = [zero_padding; pitch_ref;     zero_padding];
elevation_ref   = [zero_padding; elevation_ref; zero_padding];

t = 0:delta_t:delta_t*(length(lambda)-1);

hill = zeros(1, length(lambda));
for k = 1:length(lambda)
    hill(k) = alpha * exp(-beta*(lambda(k) - lambda_t)^2);
end
figure(10000);
plot(t, hill, t, elevation);


% states and actuation
u_opt = [t', pitch_ref, elevation_ref];
x_opt = [t', lambda, lambda_dot, pitch, pitch_dot, elevation, elevation_dot];


%% Plot comparison

% open loop
u_meas_open = open('Exercise4/maymay4_openlooop_actuation.mat');
u_meas_open = u_meas_open.ans;

x_meas_open = open('Exercise4/maymay4_openlooop_state.mat');
x_meas_open = x_meas_open.ans;

% closed loop

u_meas_closed = open('Exercise4/maymay4_closedlooop_actuation.mat');
u_meas_closed = u_meas_closed.ans;

x_meas_closed = open('Exercise4/maymay4_closedlooop_state.mat');
x_meas_closed = x_meas_closed.ans;

% MÆSTER HÆCKER
temp = x_meas_open(8, :);
x_meas_open(8, :) = x_meas_closed(8, :);
x_meas_closed(8, :) = temp;

% plot open loop
plot_comparison_open_loop(x_meas_open, u_meas_open, N, M, mx, mu, x0, hill, elevation, t, 'open');

close all;

% plot closed loop
plot_comparison_open_loop(x_meas_closed, u_meas_closed, N, M, mx, mu, x0, hill, elevation, t, 'closed');

close all;