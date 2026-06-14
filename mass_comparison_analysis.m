% =========================================================================
% Satellite Slosh Analysis - Comparison Plots
% Translational Maneuver (Figure 1) | Rotational Maneuver (Figure 2)
% Each figure: Attitude | Position | Velocity | Rates
% Dry (low mass) vs Peak (high mass) overlaid per subplot
% Units: angles in degrees, positions in mm, velocities in mm/s, rates in deg/s
% =========================================================================

clear; clc; close all;

%% --- Data Directory ---
data_dir = '/Users/alexsolakhyan/Desktop/satellite_slosh_analysis/ATTITUDE_OUTPUTS/';

%% --- Conversion ---
r2d = 180 / pi;   % radians -> degrees

%% --- Load All Data ---

% Translational maneuver
att_trans_dry  = readtable(fullfile(data_dir, 'attitude_data_trans_dry.csv'));
att_trans_peak = readtable(fullfile(data_dir, 'attitude_data_trans_peak.csv'));
pos_trans_dry  = readtable(fullfile(data_dir, 'position_data_trans_dry.csv'));
pos_trans_peak = readtable(fullfile(data_dir, 'position_data_trans_peak.csv'));
vel_trans_dry  = readtable(fullfile(data_dir, 'velocity_data_trans_dry.csv'));
vel_trans_peak = readtable(fullfile(data_dir, 'velocity_data_trans_peak.csv'));
rat_trans_dry  = readtable(fullfile(data_dir, 'rates_data_trans_dry.csv'));
rat_trans_peak = readtable(fullfile(data_dir, 'rates_data_trans_peak.csv'));

% Rotational maneuver
att_rot_dry    = readtable(fullfile(data_dir, 'attitude_data_rot_dry.csv'));
att_rot_peak   = readtable(fullfile(data_dir, 'attitude_data_rot_peak.csv'));
pos_rot_dry    = readtable(fullfile(data_dir, 'position_data_rot_dry.csv'));
pos_rot_peak   = readtable(fullfile(data_dir, 'position_data_rot_peak.csv'));
vel_rot_dry    = readtable(fullfile(data_dir, 'velocity_data_rot_dry.csv'));
vel_rot_peak   = readtable(fullfile(data_dir, 'velocity_data_rot_peak.csv'));
rat_rot_dry    = readtable(fullfile(data_dir, 'rates_data_rot_dry.csv'));
rat_rot_peak   = readtable(fullfile(data_dir, 'rates_data_rot_peak.csv'));

%% --- Color & Style Definitions ---
c_dry  = [0.20, 0.45, 0.75];   % Blue  - Dry (low mass)
c_peak = [0.85, 0.25, 0.15];   % Red   - Peak (high mass)
lw = 1.4;                       % Line width
leg_dry  = 'Dry (Low Mass)';
leg_peak = 'Peak (High Mass)';

%% =========================================================================
%  PEAK VALUE SUMMARY — TRANSLATIONAL MANEUVER
% ==========================================================================
fprintf('\n========================================================\n');
fprintf('  PEAK VALUES — TRANSLATIONAL MANEUVER\n');
fprintf('========================================================\n');

% Attitude (Yaw)
peak_yaw_trans_dry  = max(abs(att_trans_dry.Yaw_rad))  * r2d;
peak_yaw_trans_peak = max(abs(att_trans_peak.Yaw_rad)) * r2d;
fprintf('\n  [Attitude - Yaw]\n');
fprintf('    Dry  (Low Mass) : %.6f deg\n', peak_yaw_trans_dry);
fprintf('    Peak (High Mass): %.6f deg\n', peak_yaw_trans_peak);

% Position (X, Y)
peak_X_trans_dry  = max(abs(pos_trans_dry.X_m))  * 1e3;
peak_X_trans_peak = max(abs(pos_trans_peak.X_m)) * 1e3;
peak_Y_trans_dry  = max(abs(pos_trans_dry.Y_m))  * 1e3;
peak_Y_trans_peak = max(abs(pos_trans_peak.Y_m)) * 1e3;
fprintf('\n  [Position]\n');
fprintf('    X  Dry  (Low Mass) : %.6f mm\n', peak_X_trans_dry);
fprintf('    X  Peak (High Mass): %.6f mm\n', peak_X_trans_peak);
fprintf('    Y  Dry  (Low Mass) : %.6f mm\n', peak_Y_trans_dry);
fprintf('    Y  Peak (High Mass): %.6f mm\n', peak_Y_trans_peak);

% Velocity (Vx, Vy)
peak_Vx_trans_dry  = max(abs(vel_trans_dry.Vx_ms))  * 1e3;
peak_Vx_trans_peak = max(abs(vel_trans_peak.Vx_ms)) * 1e3;
peak_Vy_trans_dry  = max(abs(vel_trans_dry.Vy_ms))  * 1e3;
peak_Vy_trans_peak = max(abs(vel_trans_peak.Vy_ms)) * 1e3;
fprintf('\n  [Velocity]\n');
fprintf('    Vx Dry  (Low Mass) : %.6f mm/s\n', peak_Vx_trans_dry);
fprintf('    Vx Peak (High Mass): %.6f mm/s\n', peak_Vx_trans_peak);
fprintf('    Vy Dry  (Low Mass) : %.6f mm/s\n', peak_Vy_trans_dry);
fprintf('    Vy Peak (High Mass): %.6f mm/s\n', peak_Vy_trans_peak);

% Rates (r)
peak_r_trans_dry  = max(abs(rat_trans_dry.r_rads))  * r2d;
peak_r_trans_peak = max(abs(rat_trans_peak.r_rads)) * r2d;
fprintf('\n  [Body Rate - r]\n');
fprintf('    r  Dry  (Low Mass) : %.6f deg/s\n', peak_r_trans_dry);
fprintf('    r  Peak (High Mass): %.6f deg/s\n', peak_r_trans_peak);

%% =========================================================================
%  PEAK VALUE SUMMARY — ROTATIONAL MANEUVER
% ==========================================================================
fprintf('\n========================================================\n');
fprintf('  PEAK VALUES — ROTATIONAL MANEUVER\n');
fprintf('========================================================\n');

% Attitude (Yaw)
peak_yaw_rot_dry  = max(abs(att_rot_dry.Yaw_rad))  * r2d;
peak_yaw_rot_peak = max(abs(att_rot_peak.Yaw_rad)) * r2d;
fprintf('\n  [Attitude - Yaw]\n');
fprintf('    Dry  (Low Mass) : %.6f deg\n', peak_yaw_rot_dry);
fprintf('    Peak (High Mass): %.6f deg\n', peak_yaw_rot_peak);

% Position (X, Y)
peak_X_rot_dry  = max(abs(pos_rot_dry.X_m))  * 1e3;
peak_X_rot_peak = max(abs(pos_rot_peak.X_m)) * 1e3;
peak_Y_rot_dry  = max(abs(pos_rot_dry.Y_m))  * 1e3;
peak_Y_rot_peak = max(abs(pos_rot_peak.Y_m)) * 1e3;
fprintf('\n  [Position]\n');
fprintf('    X  Dry  (Low Mass) : %.6f mm\n', peak_X_rot_dry);
fprintf('    X  Peak (High Mass): %.6f mm\n', peak_X_rot_peak);
fprintf('    Y  Dry  (Low Mass) : %.6f mm\n', peak_Y_rot_dry);
fprintf('    Y  Peak (High Mass): %.6f mm\n', peak_Y_rot_peak);

% Velocity (Vx, Vy)
peak_Vx_rot_dry  = max(abs(vel_rot_dry.Vx_ms))  * 1e3;
peak_Vx_rot_peak = max(abs(vel_rot_peak.Vx_ms)) * 1e3;
peak_Vy_rot_dry  = max(abs(vel_rot_dry.Vy_ms))  * 1e3;
peak_Vy_rot_peak = max(abs(vel_rot_peak.Vy_ms)) * 1e3;
fprintf('\n  [Velocity]\n');
fprintf('    Vx Dry  (Low Mass) : %.6f mm/s\n', peak_Vx_rot_dry);
fprintf('    Vx Peak (High Mass): %.6f mm/s\n', peak_Vx_rot_peak);
fprintf('    Vy Dry  (Low Mass) : %.6f mm/s\n', peak_Vy_rot_dry);
fprintf('    Vy Peak (High Mass): %.6f mm/s\n', peak_Vy_rot_peak);

% Rates (r)
peak_r_rot_dry  = max(abs(rat_rot_dry.r_rads))  * r2d;
peak_r_rot_peak = max(abs(rat_rot_peak.r_rads)) * r2d;
fprintf('\n  [Body Rate - r]\n');
fprintf('    r  Dry  (Low Mass) : %.6f deg/s\n', peak_r_rot_dry);
fprintf('    r  Peak (High Mass): %.6f deg/s\n', peak_r_rot_peak);
fprintf('\n========================================================\n\n');

%% =========================================================================
%  FIGURE 1: TRANSLATIONAL MANEUVER
% ==========================================================================
fig1 = figure('Name', 'Translational Maneuver', 'NumberTitle', 'off', ...
              'Position', [50, 50, 1300, 900]);

sgtitle('Translational Maneuver — Dry vs. Peak Mass', ...
        'FontSize', 16, 'FontWeight', 'bold');

% --- TOP LEFT: Attitude (Yaw only) ---
ax1 = subplot(2, 2, 1);
hold on; grid on; box on;
plot(att_trans_dry.Time_s,  att_trans_dry.Yaw_rad  * r2d, '-',  'Color', c_dry,  'LineWidth', lw, 'DisplayName', leg_dry);
plot(att_trans_peak.Time_s, att_trans_peak.Yaw_rad * r2d, '-',  'Color', c_peak, 'LineWidth', lw, 'DisplayName', leg_peak);
xlabel('Time (s)'); ylabel('Yaw (deg)');
title('Attitude (Yaw)');
legend('Location', 'best', 'FontSize', 9);

% --- TOP RIGHT: Position (X and Y only) ---
ax2 = subplot(2, 2, 2);
hold on; grid on; box on;
plot(pos_trans_dry.Time_s,  pos_trans_dry.X_m  * 1e3, '-',  'Color', c_dry,        'LineWidth', lw, 'DisplayName', [leg_dry  ' — X']);
plot(pos_trans_peak.Time_s, pos_trans_peak.X_m * 1e3, '-',  'Color', c_peak,       'LineWidth', lw, 'DisplayName', [leg_peak ' — X']);
plot(pos_trans_dry.Time_s,  pos_trans_dry.Y_m  * 1e3, '--', 'Color', c_dry  * 0.6, 'LineWidth', lw, 'DisplayName', [leg_dry  ' — Y']);
plot(pos_trans_peak.Time_s, pos_trans_peak.Y_m * 1e3, '--', 'Color', c_peak * 0.7, 'LineWidth', lw, 'DisplayName', [leg_peak ' — Y']);
xlabel('Time (s)'); ylabel('Position (mm)');
title('Position (X / Y)');
legend('Location', 'best', 'FontSize', 9);

% --- BOTTOM LEFT: Velocity (Vx and Vy only) ---
ax3 = subplot(2, 2, 3);
hold on; grid on; box on;
plot(vel_trans_dry.Time_s,  vel_trans_dry.Vx_ms  * 1e3, '-',  'Color', c_dry,        'LineWidth', lw, 'DisplayName', [leg_dry  ' — Vx']);
plot(vel_trans_peak.Time_s, vel_trans_peak.Vx_ms * 1e3, '-',  'Color', c_peak,       'LineWidth', lw, 'DisplayName', [leg_peak ' — Vx']);
plot(vel_trans_dry.Time_s,  vel_trans_dry.Vy_ms  * 1e3, '--', 'Color', c_dry  * 0.6, 'LineWidth', lw, 'DisplayName', [leg_dry  ' — Vy']);
plot(vel_trans_peak.Time_s, vel_trans_peak.Vy_ms * 1e3, '--', 'Color', c_peak * 0.7, 'LineWidth', lw, 'DisplayName', [leg_peak ' — Vy']);
xlabel('Time (s)'); ylabel('Velocity (mm/s)');
title('Velocity (Vx / Vy)');
legend('Location', 'best', 'FontSize', 9);

% --- BOTTOM RIGHT: Rates (r only) ---
ax4 = subplot(2, 2, 4);
hold on; grid on; box on;
plot(rat_trans_dry.Time_s,  rat_trans_dry.r_rads  * r2d, '-', 'Color', c_dry,  'LineWidth', lw, 'DisplayName', [leg_dry  ' — r']);
plot(rat_trans_peak.Time_s, rat_trans_peak.r_rads * r2d, '-', 'Color', c_peak, 'LineWidth', lw, 'DisplayName', [leg_peak ' — r']);
xlabel('Time (s)'); ylabel('Rate (deg/s)');
title('Body Rate (r)');
legend('Location', 'best', 'FontSize', 9);

set([ax1 ax2 ax3 ax4], 'FontSize', 10);

%% =========================================================================
%  FIGURE 2: ROTATIONAL MANEUVER
% ==========================================================================
fig2 = figure('Name', 'Rotational Maneuver', 'NumberTitle', 'off', ...
              'Position', [100, 100, 1300, 900]);

sgtitle('Rotational Maneuver — Dry vs. Peak Mass', ...
        'FontSize', 16, 'FontWeight', 'bold');

% --- TOP LEFT: Attitude (Yaw only) ---
ax5 = subplot(2, 2, 1);
hold on; grid on; box on;
plot(att_rot_dry.Time_s,  att_rot_dry.Yaw_rad  * r2d, '-',  'Color', c_dry,  'LineWidth', lw, 'DisplayName', leg_dry);
plot(att_rot_peak.Time_s, att_rot_peak.Yaw_rad * r2d, '-',  'Color', c_peak, 'LineWidth', lw, 'DisplayName', leg_peak);
xlabel('Time (s)'); ylabel('Yaw (deg)');
title('Attitude (Yaw)');
legend('Location', 'best', 'FontSize', 9);

% --- TOP RIGHT: Position (X and Y only) ---
ax6 = subplot(2, 2, 2);
hold on; grid on; box on;
plot(pos_rot_dry.Time_s,  pos_rot_dry.X_m  * 1e3, '-',  'Color', c_dry,        'LineWidth', lw, 'DisplayName', [leg_dry  ' — X']);
plot(pos_rot_peak.Time_s, pos_rot_peak.X_m * 1e3, '-',  'Color', c_peak,       'LineWidth', lw, 'DisplayName', [leg_peak ' — X']);
plot(pos_rot_dry.Time_s,  pos_rot_dry.Y_m  * 1e3, '--', 'Color', c_dry  * 0.6, 'LineWidth', lw, 'DisplayName', [leg_dry  ' — Y']);
plot(pos_rot_peak.Time_s, pos_rot_peak.Y_m * 1e3, '--', 'Color', c_peak * 0.7, 'LineWidth', lw, 'DisplayName', [leg_peak ' — Y']);
xlabel('Time (s)'); ylabel('Position (mm)');
title('Position (X / Y)');
legend('Location', 'best', 'FontSize', 9);

% --- BOTTOM LEFT: Velocity (Vx and Vy only) ---
ax7 = subplot(2, 2, 3);
hold on; grid on; box on;
plot(vel_rot_dry.Time_s,  vel_rot_dry.Vx_ms  * 1e3, '-',  'Color', c_dry,        'LineWidth', lw, 'DisplayName', [leg_dry  ' — Vx']);
plot(vel_rot_peak.Time_s, vel_rot_peak.Vx_ms * 1e3, '-',  'Color', c_peak,       'LineWidth', lw, 'DisplayName', [leg_peak ' — Vx']);
plot(vel_rot_dry.Time_s,  vel_rot_dry.Vy_ms  * 1e3, '--', 'Color', c_dry  * 0.6, 'LineWidth', lw, 'DisplayName', [leg_dry  ' — Vy']);
plot(vel_rot_peak.Time_s, vel_rot_peak.Vy_ms * 1e3, '--', 'Color', c_peak * 0.7, 'LineWidth', lw, 'DisplayName', [leg_peak ' — Vy']);
xlabel('Time (s)'); ylabel('Velocity (mm/s)');
title('Velocity (Vx / Vy)');
legend('Location', 'best', 'FontSize', 9);

% --- BOTTOM RIGHT: Rates (r only) ---
ax8 = subplot(2, 2, 4);
hold on; grid on; box on;
plot(rat_rot_dry.Time_s,  rat_rot_dry.r_rads  * r2d, '-', 'Color', c_dry,  'LineWidth', lw, 'DisplayName', [leg_dry  ' — r']);
plot(rat_rot_peak.Time_s, rat_rot_peak.r_rads * r2d, '-', 'Color', c_peak, 'LineWidth', lw, 'DisplayName', [leg_peak ' — r']);
xlabel('Time (s)'); ylabel('Rate (deg/s)');
title('Body Rate (r)');
legend('Location', 'best', 'FontSize', 9);

set([ax5 ax6 ax7 ax8], 'FontSize', 10);

%% --- Optional: Save figures ---
% saveas(fig1, fullfile(data_dir, 'slosh_translational.png'));
% saveas(fig2, fullfile(data_dir, 'slosh_rotational.png'));

fprintf('Done. Two figures generated.\n');