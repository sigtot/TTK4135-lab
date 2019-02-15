function plot_many(z, N, M, mx, mu, x0, P1, delta_t)
    %% Extract control inputs and states
    u  = [z(N*mx+1:N*mx+M*mu);z(N*mx+M*mu)]; % Control input from solution

    x1 = [x0(1);z(1:mx:N*mx)];              % State x1 from solution
    x2 = [x0(2);z(2:mx:N*mx)];              % State x2 from solution
    x3 = [x0(3);z(3:mx:N*mx)];              % State x3 from solution
    x4 = [x0(4);z(4:mx:N*mx)];              % State x4 from solution

    num_variables = 5/delta_t;
    zero_padding = zeros(num_variables,1);
    unit_padding  = ones(num_variables,1);

    u   = [zero_padding; u; zero_padding];
    x1  = [pi*unit_padding; x1; zero_padding];
    x2  = [zero_padding; x2; zero_padding];
    x3  = [zero_padding; x3; zero_padding];
    x4  = [zero_padding; x4; zero_padding];

    %% Plotting
    t = 0:delta_t:delta_t*(length(u)-1);

    figure(2)
    subplot(511)
    stairs(t,u),grid
    ylabel('$u$')
    subplot(512)
    plot(t,x1,'m',t,x1,'mo'),grid
    ylabel('$\lambda$')
    subplot(513)
    plot(t,x2,'m',t,x2','mo'),grid
    ylabel('$r$')
    subplot(514)
    plot(t,x3,'m',t,x3,'mo'),grid
    ylabel('$p$')
    subplot(515)
    plot(t,x4,'m',t,x4','mo'),grid
    xlabel('time (s)'),ylabel('$\dot p$')

    %%  Plot graphs

    PART_PATH = 'Exercise2/figures/';
    PART_AND_PROBLEM = 'p2';
    FILE_NAME = strcat('opt_all_q=', num2str(P1));

    font_size = struct(...
        'legend', 10,...
        'title', 18,...
        'xlabel', 12,...
        'ylabel', 12);

    fig3 = figure(3);
        hold on
        subplot(511)
        stairs(t,u),grid
        ylabel('$u$')
        subplot(512)
        plot(t,x1,'m',t,x1,'mo'),grid
        ylabel('$\lambda$')
        subplot(513)
        plot(t,x2,'m',t,x2','mo'),grid
        ylabel('$r$')
        subplot(514)
        plot(t,x3,'m',t,x3,'mo'),grid
        ylabel('$p$')
        subplot(515)
        plot(t,x4,'m',t,x4','mo'),grid
        xlabel('time (s)'),ylabel('$\dot p$')

        % Save to .pdf

        set(fig3, 'Units', 'Inches');
        pos1 = get(fig3, 'Position');
        set(fig3, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches', 'PaperSize', [pos1(3), pos1(4)]);
        print(fig3, strrep(strcat(PART_PATH, PART_AND_PROBLEM, FILE_NAME), '.', 'pnt'), '-dpdf', '-r0');
end
