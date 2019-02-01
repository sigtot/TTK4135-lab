close all;

measurements_raw_data = load('measurements.mat')';

measurements = struct(...
    'time',         measurements_raw_data.ans(1,:),...
    'lambda',       measurements_raw_data.ans(2,:),...
    'lambda_dot',   measurements_raw_data.ans(3,:),...
    'e',            measurements_raw_data.ans(4,:),...
    'e_dot',        measurements_raw_data.ans(5,:),...
    'p',            measurements_raw_data.ans(6,:),...
    'p_dot',        measurements_raw_data.ans(7,:)...
);

%%  Plot graphs

PART_PATH = 'Exercise1/figures/';
PART_AND_PROBLEM = '';

font_size = struct(...
    'legend', 10,...
    'title', 18,...
    'xlabel', 12,...
    'ylabel', 12);

fig1 = figure(1); % Elevation rate
    plot(measurements.time, measurements.e_dot, 'color', 'g');
    hold on
    plot(measurements.time, measurements.p_dot, 'color', 'r');
    plot(measurements.time, measurements.lambda_dot, 'color', 'm');
    %plot(references.time, references.e_dot, 'color', 'b');
    title('Angle rate', 'Interpreter', 'latex', 'fontsize', font_size.title);
    legend({'$\dot{e}_{meas}$', '$\dot{p}_{meas}$', '$\dot{\lambda}_{meas}$'}, 'Interpreter', 'latex', 'fontsize', font_size.legend, 'location', 'best');
    ylabel({'Angular velocity [$\circ/s$]'}, 'Interpreter', 'latex', 'fontsize', font_size.ylabel);
    xlabel({'Time [s]'}, 'Interpreter', 'latex', 'fontsize', font_size.xlabel)

    % Save to .pdf
    
    set(fig1, 'Units', 'Inches');
    pos1 = get(fig1, 'Position');
    set(fig1, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches', 'PaperSize', [pos1(3), pos1(4)]);
    print(fig1, strrep(strcat(PART_PATH, PART_AND_PROBLEM, 'angle_rate'), '.', 'pnt'), '-dpdf', '-r0');
    
fig2 = figure(2); % Elevation rate
    plot(measurements.time, measurements.e, 'color', 'g');
    hold on
    plot(measurements.time, measurements.p, 'color', 'r');
    plot(measurements.time, measurements.lambda, 'color', 'm');
    %plot(references.time, references.e_dot, 'color', 'b');
    title('Angles', 'Interpreter', 'latex', 'fontsize', font_size.title);
    legend({'$e_{meas}$', '$p_{meas}$', '$\lambda_{meas}$'}, 'Interpreter', 'latex', 'fontsize', font_size.legend, 'location', 'best');
    ylabel({'Angle [$\circ$]'}, 'Interpreter', 'latex', 'fontsize', font_size.ylabel);
    xlabel({'Time [s]'}, 'Interpreter', 'latex', 'fontsize', font_size.xlabel)

    % Save to .pdf
    
    set(fig2, 'Units', 'Inches');
    pos1 = get(fig2, 'Position');
    set(fig2, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches', 'PaperSize', [pos1(3), pos1(4)]);
    print(fig2, strrep(strcat(PART_PATH, PART_AND_PROBLEM, 'angle'), '.', 'pnt'), '-dpdf', '-r0');