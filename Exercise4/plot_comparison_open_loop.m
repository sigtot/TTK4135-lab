function plot_comparison_open_loop(x_meas, u_meas, N, M, mx, mu, x0, hill_opt_real, elevation_opt_real, t_opt_real, prefix)
    
    
    font_size = struct(...
        'legend', 10,...
        'title', 18,...
        'xlabel', 12,...
        'ylabel', 12);

    %% Extract states
    % time
    t                   = x_meas(1, :);
    t                   = u_meas(1, :);
    
    
    % optimal
    lambda_opt          = x_meas(2, :);
    lambda_dot_opt      = x_meas(3, :);
    pitch_opt           = x_meas(4, :);
    pitch_dot_opt       = x_meas(5, :);
    elevation_opt       = x_meas(6, :);
    elevation_dot_opt   = x_meas(7, :);

    pitch_ref_opt       = u_meas(2, :);
    elevation_ref_opt   = u_meas(3, :); 
    
    % measured
    lambda_meas         = x_meas(8, :);
    lambda_dot_meas     = x_meas(9, :);
    pitch_meas          = x_meas(10, :);
    pitch_dot_meas      = x_meas(11, :);
    elevation_meas      = x_meas(12, :);
    elevation_dot_meas  = x_meas(13, :);

    pitch_ref_meas      = u_meas(4, :);
    elevation_ref_meas  = u_meas(5, :);
    

    %% Create figure
    fig3 = figure(89);
    hold on
    
    %%  Plot pitch
    subplot(211)
    hold on
    ylabel({'$p$'}, 'fontsize', font_size.ylabel)
    grid on
        
    hold on
    
    plot(t,pitch_opt, 'DisplayName', 'Optimal pitch'),grid    
    plot(t,pitch_meas, 'DisplayName', 'Actual pitch'),grid
    plot(t,pitch_ref_opt, 'DisplayName', 'Pitch reference'),grid
    
    grid on;

    legend('Location', 'best');
    legend show;

    %% Plot travel
    subplot(212);
    hold on
    ylabel({'$\lambda (rad)$'}, 'Interpreter', 'latex', 'fontsize', font_size.ylabel)

    hold on
    
    plot(t,lambda_opt, 'DisplayName', 'Optimal travel'),grid
    plot(t,lambda_meas, 'DisplayName', 'Actual travel'),grid
    
    legend('Location', 'best');
    legend show;
    ylabel({'$\lambda$'}, 'fontsize', font_size.ylabel);
    grid on
    %% Time
    xlabel({'time (s)'}, 'fontsize', font_size.xlabel)
    
    
    %% Save to .pdf
    PART_PATH = 'Exercise4/figures/';
    PART_AND_PROBLEM = 'p43';
    FILE_NAME = 'travel_and_pitch_comparison';

    set(fig3, 'Units', 'Inches');
    pos1 = get(fig3, 'Position');
    set(fig3, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches', 'PaperSize', [pos1(3), pos1(4)]);
    print(fig3, strrep(strcat(PART_PATH, prefix, PART_AND_PROBLEM, FILE_NAME), '.', 'pnt'), '-dpdf', '-r0');

%%  Plot elevation
    fig5 = figure(97);
    hold on
    hold on
    ylabel({'$e$'}, 'Interpreter', 'latex', 'fontsize', font_size.ylabel)

    hold on
    
    plot(t_opt_real,elevation_opt_real, '-.', 'DisplayName', 'Optimal elevation'),grid
    plot(t,elevation_meas, 'DisplayName', 'Actual elevation'),grid
    plot(t_opt_real,hill_opt_real, 'DisplayName', 'Hill constraint'),grid

    grid on
    
    legend show;
   
    %% Time
    xlabel({'time (s)'}, 'fontsize', font_size.xlabel)
    
    %% Save to .pdf
    PART_PATH = 'Exercise4/figures/';
    PART_AND_PROBLEM = 'p43';
    FILE_NAME = 'elevation_comparison';

    set(fig5, 'Units', 'Inches');
    pos1 = get(fig5, 'Position');
    set(fig5, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches', 'PaperSize', [pos1(3), pos1(4)]);
    print(fig5, strrep(strcat(PART_PATH, prefix, PART_AND_PROBLEM, FILE_NAME), '.', 'pnt'), '-dpdf', '-r0');
    
    hold off;
end
