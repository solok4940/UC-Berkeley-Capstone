%% Post-Process Fill Level Comparison – 30%, 50%, 70% Fill Cases
% Generates 2 figures:
%   Figure 1 – Core response: Yaw angle | Position | Velocity | Yaw rate
%   Figure 2 – Yaw torque | Accumulated yaw momentum | Linear momentum

clear; clc; close all;

%% ── Configuration ────────────────────────────────────────────────────────
csv_dir = '/Users/alexsolakhyan/Desktop/satellite_slosh_analysis/Fill_Comparison_Outputs/';

% Satellite mass & inertia
mass = 205.112;   % kg
Ixx  =  36.25;    % kg·m²
Iyy  =  29.7478;
Izz  =  44.8639;

% Hard-coded simulation time window
t_max = 43.5;     % seconds

fills       = {'30', '50', '70'};       % filename tokens
fkeys       = {'f30', 'f50', 'f70'};    % valid MATLAB struct field names
fill_labels = {'30% Fill', '50% Fill', '70% Fill'};

% Color per fill level – used consistently across ALL subplots
colors = {[0.0000 0.4470 0.7410], ...   % blue   – 30%
          [0.8500 0.3250 0.0980], ...   % orange – 50%
          [0.4660 0.6740 0.1880]};      % green  – 70%

% Line style per fill level – used consistently across ALL subplots
ls = {'-', '--', ':'};

lw = 1.8;   % single line width for all plots

fprintf('Reading CSV files from: %s\n', csv_dir);
fprintf('Time window: 0 – %.1f s\n\n', t_max);

%% ── Load & clip data ─────────────────────────────────────────────────────
for k = 1:numel(fills)
    f  = fills{k};
    fk = fkeys{k};

    att.(fk) = readtable([csv_dir 'attitude_data_' f 'fill_trans.csv']);
    pos.(fk) = readtable([csv_dir 'position_data_' f 'fill_trans.csv']);
    vel.(fk) = readtable([csv_dir 'velocity_data_' f 'fill_trans.csv']);
    rat.(fk) = readtable([csv_dir 'rates_data_'    f 'fill_trans.csv']);

    % Clip to t_max
    att.(fk) = att.(fk)(att.(fk).Time_s <= t_max, :);
    pos.(fk) = pos.(fk)(pos.(fk).Time_s <= t_max, :);
    vel.(fk) = vel.(fk)(vel.(fk).Time_s <= t_max, :);
    rat.(fk) = rat.(fk)(rat.(fk).Time_s <= t_max, :);

    fprintf('✓ Loaded %s%% fill  |  %d pts (clipped to %.1f s)\n', ...
        f, height(att.(fk)), t_max);
end

%% ── Derived quantities ───────────────────────────────────────────────────
for k = 1:numel(fkeys)
    fk = fkeys{k};

    % Yaw angle – unwrapped, converted to degrees
    yaw_unwrap.(fk) = rad2deg(unwrap(att.(fk).Yaw_rad));

    % Linear momentum magnitude
    v_mag.(fk)    = sqrt(vel.(fk).Vx_ms.^2 + vel.(fk).Vy_ms.^2 + vel.(fk).Vz_ms.^2);
    momentum.(fk) = mass * v_mag.(fk);

    % Yaw torque:  τ_r = Izz · dω_r/dt
    t_r           = rat.(fk).Time_s;
    torque_r.(fk) = Izz * gradient(rat.(fk).r_rads, t_r);

    % Accumulated yaw angular momentum:  H_r = ∫τ_r dt
    H_r.(fk) = cumtrapz(t_r, torque_r.(fk));
end

%% ── Console summary ──────────────────────────────────────────────────────
fprintf('\n════════════════════════════════════════════════════════\n');
fprintf('  FILL LEVEL COMPARISON SUMMARY (Yaw axis)\n');
fprintf('════════════════════════════════════════════════════════\n');
fprintf('Mass: %.3f kg  |  Izz: %.4f kg·m²\n\n', mass, Izz);
fprintf('%-10s  %18s  %20s  %18s\n', ...
    'Fill', 'Max |τ_yaw| (N·m)', 'Max |H_yaw| (N·m·s)', 'Max p (kg·m/s)');
fprintf('%s\n', repmat('-', 1, 70));
for k = 1:numel(fkeys)
    fk = fkeys{k};
    fprintf('%-10s  %18.6f  %20.6f  %18.6f\n', [fills{k} '%'], ...
        max(abs(torque_r.(fk))), max(abs(H_r.(fk))), max(momentum.(fk)));
end
fprintf('════════════════════════════════════════════════════════\n\n');

%% ════════════════════════════════════════════════════════════════════════
%  FIGURE 1 – Core Response
%  Subplots: Yaw Angle | Position | Velocity | Yaw Rate
% ════════════════════════════════════════════════════════════════════════
figure('Name', 'Fill Comparison – Core Response', 'Position', [50 50 1400 900]);
set(gcf, 'Color', 'white');

% ── Subplot 1: Yaw angle (unwrapped) ─────────────────────────────────
subplot(2,2,1);  hold on;  grid on;
for k = 1:numel(fkeys)
    fk = fkeys{k};
    plot(att.(fk).Time_s, yaw_unwrap.(fk), ...
         'Color', colors{k}, 'LineStyle', ls{k}, 'LineWidth', lw, ...
         'DisplayName', fill_labels{k});
end
xlabel('Time (s)');  ylabel('Yaw Angle (deg)');
title('Yaw Angle (Unwrapped)');
legend('Location', 'best', 'FontSize', 9);

% ── Subplot 2: Position ───────────────────────────────────────────────
% Colour encodes fill level; line style encodes fill level (consistent).
% All three axes (X, Y, Z) drawn at the same lw – no varying thickness.
subplot(2,2,2);  hold on;  grid on;
ax_flds = {'X_m',  'Y_m',  'Z_m'};
ax_lbl  = {'X',    'Y',    'Z'  };
for k = 1:numel(fkeys)
    fk = fkeys{k};
    for ax = 1:3
        plot(pos.(fk).Time_s, pos.(fk).(ax_flds{ax}) * 1000, ...
             'Color', colors{k}, 'LineStyle', ls{k}, 'LineWidth', lw, ...
             'DisplayName', [ax_lbl{ax} ' – ' fill_labels{k}]);
    end
end
xlabel('Time (s)');  ylabel('Position (mm)');
title('Position (X, Y, Z)');
legend('Location', 'best', 'NumColumns', 3, 'FontSize', 7);

% ── Subplot 3: Velocity ───────────────────────────────────────────────
subplot(2,2,3);  hold on;  grid on;
vel_flds = {'Vx_ms', 'Vy_ms', 'Vz_ms'};
vel_lbl  = {'Vx',    'Vy',    'Vz'   };
for k = 1:numel(fkeys)
    fk = fkeys{k};
    for ax = 1:3
        plot(vel.(fk).Time_s, vel.(fk).(vel_flds{ax}), ...
             'Color', colors{k}, 'LineStyle', ls{k}, 'LineWidth', lw, ...
             'DisplayName', [vel_lbl{ax} ' – ' fill_labels{k}]);
    end
end
xlabel('Time (s)');  ylabel('Velocity (m/s)');
title('Velocity (Vx, Vy, Vz)');
legend('Location', 'best', 'NumColumns', 3, 'FontSize', 7);

% ── Subplot 4: Yaw rate ───────────────────────────────────────────────
subplot(2,2,4);  hold on;  grid on;
for k = 1:numel(fkeys)
    fk = fkeys{k};
    plot(rat.(fk).Time_s, rad2deg(rat.(fk).r_rads), ...
         'Color', colors{k}, 'LineStyle', ls{k}, 'LineWidth', lw, ...
         'DisplayName', fill_labels{k});
end
xlabel('Time (s)');  ylabel('Yaw Rate (deg/s)');
title('Yaw Angular Rate  r');
legend('Location', 'best', 'FontSize', 9);

sgtitle('Satellite 6-DOF Response – Fill Level Comparison (30 / 50 / 70%)', ...
        'FontSize', 14, 'FontWeight', 'bold');

%% ════════════════════════════════════════════════════════════════════════
%  FIGURE 2 – Yaw Torque | Accumulated Yaw Momentum | Linear Momentum
% ════════════════════════════════════════════════════════════════════════
figure('Name', 'Fill Comparison – Torque & Momentum', 'Position', [150 80 900 950]);
set(gcf, 'Color', 'white');

% ── Subplot 1: Yaw torque ─────────────────────────────────────────────
subplot(3,1,1);  hold on;  grid on;  set(gca, 'Color', 'white');
for k = 1:numel(fkeys)
    fk = fkeys{k};
    plot(rat.(fk).Time_s, torque_r.(fk), ...
         'Color', colors{k}, 'LineStyle', ls{k}, 'LineWidth', lw, ...
         'DisplayName', fill_labels{k});
end
xlabel('Time (s)');  ylabel('Torque (N·m)');
title('Yaw Torque   τ_r = I_{zz} · dω_r/dt');
legend('Location', 'best', 'FontSize', 9);

% ── Subplot 2: Accumulated yaw angular momentum ───────────────────────
subplot(3,1,2);  hold on;  grid on;  set(gca, 'Color', 'white');
for k = 1:numel(fkeys)
    fk = fkeys{k};
    plot(rat.(fk).Time_s, H_r.(fk), ...
         'Color', colors{k}, 'LineStyle', ls{k}, 'LineWidth', lw, ...
         'DisplayName', fill_labels{k});
end
xlabel('Time (s)');  ylabel('Angular Momentum (N·m·s)');
title('Accumulated Yaw Angular Momentum   H_r = ∫τ_r dt');
legend('Location', 'best', 'FontSize', 9);

% ── Subplot 3: Linear momentum magnitude ─────────────────────────────
subplot(3,1,3);  hold on;  grid on;  set(gca, 'Color', 'white');
for k = 1:numel(fkeys)
    fk = fkeys{k};
    plot(vel.(fk).Time_s, momentum.(fk), ...
         'Color', colors{k}, 'LineStyle', ls{k}, 'LineWidth', lw, ...
         'DisplayName', fill_labels{k});
end
xlabel('Time (s)');  ylabel('Momentum (kg·m/s)');
title(sprintf('Linear Momentum Magnitude   (m = %.0f kg)', mass));
legend('Location', 'best', 'FontSize', 9);

sgtitle('Yaw Torque, Angular Momentum & Linear Momentum – Fill Level Comparison', ...
        'FontSize', 13, 'FontWeight', 'bold');

fprintf('✓ Generated 2 comparison figures.\n');
fprintf('Done!\n');