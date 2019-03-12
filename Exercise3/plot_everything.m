%% Initializing for plotting...
font_size = struct(...
        'legend', 10,...
        'title', 18,...
        'xlabel', 12,...
        'ylabel', 12);

%% Import data    
data = load('C:\Users\sigurdvt\Documents\opt_reg\Exercise3\maymay3travel_penalty1e3.mat');
data = data.ans;

% Time
t = data(1, :);

% Measured state
lambda_meas     = data(2, :);
lambda_dot_meas = data(3, :);
pitch_meas      = data(4, :);
pitch_dot_meas  = data(5, :);

% Optimal state
lambda_opt      = data(6, :);
lambda_dot_opt  = data(7, :);
pitch_opt       = data(8, :);
pitch_dot_opt   = data(9, :);

% Actual pitch reference
pitch_ref_meas  = data(10, :);

% Optimal pitch reference
pitch_ref_opt   = data(11, :);

%% Plot data
fig89 = figure(89);

hold on

subplot(211)
hold on
ylabel({'$u$'}, 'fontsize', font_size.ylabel)
grid on

hold on

%%  Plot graphs
plot(t, pitch_ref_opt, 'DisplayName', 'Optimal pitch reference'),grid
plot(t, pitch_ref_meas, 'DisplayName', 'Actual pitch reference'),grid
plot(t, pitch_meas, 'DisplayName', 'Actual pitch'),grid
grid on;

legend('Location', 'best');
%legend show;
subplot(212)
hold on
ylabel({'$u$'}, 'Interpreter', 'latex', 'fontsize', font_size.ylabel)

hold on

%%  Plot graphs
plot(t, lambda_opt, 'DisplayName', 'Optimal travel'),grid
plot(t, lambda_meas, 'DisplayName', 'Actual travel'),grid

grid on

legend('Location', 'best');
%legend show;
ylabel({'$\lambda$'}, 'fontsize', font_size.ylabel)

xlabel({'time (s)'}, 'fontsize', font_size.xlabel)

%% Save to .pdf
PART_PATH = 'Exercise3/figures/';
PART_AND_PROBLEM = 'p3';
FILE_NAME = 'LQ_travel_and_input_comparison';

set(fig89, 'Units', 'Inches');
pos1 = get(fig89, 'Position');
set(fig89, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches', 'PaperSize', [pos1(3), pos1(4)]);
print(fig89, strrep(strcat(PART_PATH, PART_AND_PROBLEM, FILE_NAME), '.', 'pnt'), '-dpdf', '-r0');
















