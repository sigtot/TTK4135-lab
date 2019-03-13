function plot_lambdas(solutions, N, M, mx, mu, x0, P, delta_t)
    font_size = struct(...
        'legend', 10,...
        'title', 18,...
        'xlabel', 12,...
        'ylabel', 12);
    
    fig3 = figure(71);
    hold on
    
    subplot(211)
    hold on
    ylabel({'$u$'}, 'fontsize', font_size.ylabel)
    grid on
        
    for n = 1 : length(solutions(1, :))
        
        hold on
        z = solutions(:, n);
        %% Extract control inputs and states
        u  = [z(N*mx+1:N*mx+M*mu);z(N*mx+M*mu)]; % Control input from solution

        lambda = [x0(1);z(1:mx:N*mx)];              % State x1 from solution

        num_variables = 5/delta_t;
        zero_padding = zeros(num_variables,1);
        unit_padding  = ones(num_variables,1);

        u = [zero_padding; u; zero_padding];
        lambda = [pi*unit_padding; lambda; zero_padding];

        %%  Plot graphs
        t = 0:delta_t:delta_t*(length(u)-1);
 

        
        stairs(t,u, 'DisplayName', sprintf('q = %0.1f', P(n))),grid
        grid on;
    end
    legend show;
    subplot(212)
    hold on
    ylabel({'$\lambda$'}, 'Interpreter', 'latex', 'fontsize', font_size.ylabel)
    
    for n = 1 : length(solutions(1, :))
        hold on
        
        z = solutions(:, n);
        %% Extract control inputs and states
        u  = [z(N*mx+1:N*mx+M*mu);z(N*mx+M*mu)]; % Control input from solution

        lambda = [x0(1);z(1:mx:N*mx)];              % State x1 from solution

        num_variables = 5/delta_t;
        zero_padding = zeros(num_variables,1);
        unit_padding  = ones(num_variables,1);

        u = [zero_padding; u; zero_padding];
        lambda = [pi*unit_padding; lambda; zero_padding];

        %%  Plot graphs
        t = 0:delta_t:delta_t*(length(u)-1);
 
        font_size = struct(...
            'legend', 10,...
            'title', 18,...
            'xlabel', 12,...
            'ylabel', 12);
        
        plot(t,lambda, 'DisplayName', sprintf('q = %0.1f', P(n))),grid
        %legend({'$\lambda$'}, 'Interpreter', 'latex', 'fontsize', font_size.legend, 'location', 'best')

        grid on
    end
    legend show;
    xlabel({'time (s)'}, 'fontsize', font_size.xlabel)
    
    %% Save to .pdf
    PART_PATH = 'Exercise2/figures/';
    PART_AND_PROBLEM = 'p2';
    FILE_NAME = 'opt_travel_and_inputs';

    set(fig3, 'Units', 'Inches');
    pos1 = get(fig3, 'Position');
    set(fig3, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches', 'PaperSize', [pos1(3), pos1(4) + 0.2]);
    print(fig3, strrep(strcat(PART_PATH, PART_AND_PROBLEM, FILE_NAME), '.', 'pnt'), '-dpdf', '-r0');
end
