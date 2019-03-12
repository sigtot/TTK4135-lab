function plot_comparison_closed_loop(x_meas, u_meas, N, M, mx, mu, x0, delta_t)
    
    
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
    
    plot(t, elevation_meas, t, elevation_opt);
end

