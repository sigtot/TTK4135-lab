function plot_comparison(z, data, N, M, mx, mu, x0, delta_t)
    font_size = struct(...
        'legend', 10,...
        'title', 18,...
        'xlabel', 12,...
        'ylabel', 12);
    
    fig3 = figure(83);
    hold on
    
    subplot(211)
    hold on
    ylabel({'$u$'}, 'fontsize', font_size.ylabel)
    grid on
        
    hold on
    %% Extract states
    lambda = data(5, :);              % State x1 from solution
    lambda_real = data(4, :);
    
    u = data(2, :);
    u_real = data(3, :);
    
    t = data(1, :);
    
    num_variables = 5/delta_t;
    zero_padding = zeros(num_variables,1);
    unit_padding  = ones(num_variables,1);

    %lambda = [pi*unit_padding; lambda; zero_padding];

    %%  Plot graphs
    plot(t,u, 'DisplayName', 'Pitch reference'),grid
    plot(t,u_real, 'DisplayName', 'Actual pitch'),grid
    grid on;

    legend show;
    subplot(212)
    hold on
    ylabel({'$u$'}, 'Interpreter', 'latex', 'fontsize', font_size.ylabel)

    hold on

    %%  Plot graphs
    plot(t,lambda, 'DisplayName', 'Optimal travel'),grid
    plot(t,lambda_real, 'DisplayName', 'Actual travel'),grid

    grid on
    
    legend show;
    ylabel({'$\lambda$'}, 'fontsize', font_size.ylabel)

    xlabel({'time (s)'}, 'fontsize', font_size.xlabel)
    
    %% Save to .pdf
    PART_PATH = 'Exercise2/figures/';
    PART_AND_PROBLEM = 'p2';
    FILE_NAME = 'travel_and_input_comparison';

    set(fig3, 'Units', 'Inches');
    pos1 = get(fig3, 'Position');
    set(fig3, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches', 'PaperSize', [pos1(3), pos1(4) + 0.2]);
    print(fig3, strrep(strcat(PART_PATH, PART_AND_PROBLEM, FILE_NAME), '.', 'pnt'), '-dpdf', '-r0');
end
