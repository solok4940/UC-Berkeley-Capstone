%% CFD Fill Level Comparison – Sloshing Forces, Moments & Fluid CoM
% Applies the same preprocessing as the single-case analysis script:
%   • 3-line Fluent header skip
%   • First-N-point transient crop (default: 3 pts)
%   • Physical unit scaling  (force × h,  moment × h,  CoM / norm_factor)
%   • CoM offset from initial position (drift)
%   • Moving average filter on moment & force (window = 11)
%   • Time axis clipped to shortest recording across all cases
%
% Produces 3 figures:
%   Figure 1 – Fluid Centre of Mass Drift (Xcm, Ycm side by side)
%   Figure 2 – Total Moment Z (yaw) – all cases on one plot
%   Figure 3 – Total Force X      – all cases on one plot

clear; clc; close all;

%% ── Case folders & labels ────────────────────────────────────────────────
dirs = { ...
    '/Users/alexsolakhyan/Desktop/satellite_slosh_analysis/Rot_30fill_CFD_vals/', ...
    '/Users/alexsolakhyan/Desktop/satellite_slosh_analysis/Rot_70fill_CFD_vals/', ...
    '/Users/alexsolakhyan/Desktop/satellite_slosh_analysis/Rotational_Maneuver_CFD_vals/' ...
};
case_labels = {'30% Fill', '70% Fill', '50% Fill'};  % adjust if needed

%% ── Physical parameters (match preprocessing script) ─────────────────────
tank.height      = 0.25;    % m
tank.corner_offset_from_sat_CoG = [0; 0; 0];  % [x; y; z] m — adjust if needed

% Per-case propellant mass (kg) — order must match dirs / case_labels above:
%   Case 1: Rot_30fill → 30% fill → 18 kg
%   Case 2: Rot_70fill → 70% fill → 29 kg
%   Case 3: Rotational → 50% fill → 24 kg
mass_prop_per_case = [18, 29, 24];  % kg

%% ── Preprocessing settings ───────────────────────────────────────────────
skip_pts      = 3;    % drop first N data points (startup transient)
filter_window = 11;   % moving-average window for moment & force smoothing

%% ── Visual encoding ──────────────────────────────────────────────────────
colors = {[0.0000 0.4470 0.7410], ...   % blue   – case 1
          [0.4660 0.6740 0.1880], ...   % green  – case 2
          [0.8500 0.3250 0.0980]};      % orange – case 3
ls     = {'-', '--', ':'};
lw     = 1.8;
n      = numel(dirs);

%% ── Load, preprocess & derive quantities for each case ───────────────────
fprintf('Loading and preprocessing CFD output files...\n\n');

for k = 1:n
    fprintf('  Case %d (%s): %s\n', k, case_labels{k}, dirs{k});

    % ── Read raw Fluent files ─────────────────────────────────────────────
    raw_fx  = readFluent([dirs{k} 'force_x_all-rfile.out'  ]);
    raw_mz  = readFluent([dirs{k} 'moment_all_z-rfile.out' ]);
    raw_cmx = readFluent([dirs{k} 'cm_x_non-norm-rfile.out']);
    raw_cmy = readFluent([dirs{k} 'cm_y_non-norm-rfile.out']);

    % ── Crop startup transient ────────────────────────────────────────────
    s = skip_pts + 1;   % first retained index (1-based)
    t_raw = raw_fx.time(s:end);
    t     = t_raw - t_raw(1);   % shift so t(1) = 0

    fx_raw  = raw_fx.data (s:end);
    mz_raw  = raw_mz.data (s:end);
    cmx_raw = raw_cmx.data(s:end);
    cmy_raw = raw_cmy.data(s:end);

    % ── Per-case normalisation factor ─────────────────────────────────────
    mass_prop      = mass_prop_per_case(k);
    cm_norm_factor = mass_prop / tank.height;

    % ── Physical unit scaling (same as preprocessing script) ─────────────
    Fx = fx_raw * tank.height;          % N
    Mz_corner = mz_raw * tank.height;   % N·m  (about tank corner)

    % Normalise CoM to physical metres
    xcm_m = cmx_raw / cm_norm_factor;  % m
    ycm_m = cmy_raw / cm_norm_factor;  % m

    % Moment transfer from tank corner to satellite CoG (2-D, z-component):
    %   Mz_sat = Mz_corner + (r_x * Fy - r_y * Fx)
    %   Fy = 0 for 2-D simulation
    r_x  = tank.corner_offset_from_sat_CoG(1);
    r_y  = tank.corner_offset_from_sat_CoG(2);
    Mz_sat_raw = Mz_corner + (r_x .* 0 - r_y .* Fx);

    % ── Moving average filter (moments & force) ───────────────────────────
    Mz_filtered = movmean(Mz_sat_raw, filter_window);
    Fx_filtered = movmean(Fx,         filter_window);

    % ── CoM drift (offset from initial position) ──────────────────────────
    xcm_drift = (xcm_m - xcm_m(1)) * 1000;   % mm
    ycm_drift = (ycm_m - ycm_m(1)) * 1000;   % mm

    % ── Store in structs ─────────────────────────────────────────────────
    T{k}        = t;
    FX{k}       = Fx_filtered;
    MZ{k}       = Mz_filtered;
    XCMDRIFT{k} = xcm_drift;
    YCMDRIFT{k} = ycm_drift;

    fprintf('    ✓ %d pts retained  |  t: 0 – %.2f s\n', numel(t), t(end));
    fprintf('    ✓ Fx range:  [%+.4f, %+.4f] N\n',   min(Fx_filtered),  max(Fx_filtered));
    fprintf('    ✓ Mz range:  [%+.4f, %+.4f] N·m\n', min(Mz_filtered),  max(Mz_filtered));
    fprintf('    ✓ Xcm drift: [%+.4f, %+.4f] mm\n',  min(xcm_drift),    max(xcm_drift));
    fprintf('    ✓ Ycm drift: [%+.4f, %+.4f] mm\n',  min(ycm_drift),    max(ycm_drift));
    fprintf('\n');
end

%% ── Clip to shortest common time window ──────────────────────────────────
t_max = min(cellfun(@(t) t(end), T));
fprintf('Common time window: 0 – %.4f s\n\n', t_max);

for k = 1:n
    mask        = T{k} <= t_max;
    T{k}        = T{k}(mask);
    FX{k}       = FX{k}(mask);
    MZ{k}       = MZ{k}(mask);
    XCMDRIFT{k} = XCMDRIFT{k}(mask);
    YCMDRIFT{k} = YCMDRIFT{k}(mask);
end

figure('Name', 'CFD Fill Level Comparison Summary', 'Position', [100 100 1200 850]);
set(gcf, 'Color', 'white');

% --- Subplot 1: Fluid CoM Drift - X ---
subplot(2,2,1); hold on; grid on; set(gca,'Color','white');
for k = 1:n
    plot(T{k}, XCMDRIFT{k}, 'Color', colors{k}, 'LineStyle', ls{k}, 'LineWidth', lw, 'DisplayName', case_labels{k});
end
xlabel('Flow Time (s)'); ylabel('X_{cm} Drift (mm)');
title('Fluid CoM Drift – X');
legend('Location', 'best', 'FontSize', 8);

% --- Subplot 2: Fluid CoM Drift - Y ---
subplot(2,2,2); hold on; grid on; set(gca,'Color','white');
for k = 1:n
    plot(T{k}, YCMDRIFT{k}, 'Color', colors{k}, 'LineStyle', ls{k}, 'LineWidth', lw, 'DisplayName', case_labels{k});
end
xlabel('Flow Time (s)'); ylabel('Y_{cm} Drift (mm)');
title('Fluid CoM Drift – Y');
legend('Location', 'best', 'FontSize', 8);

% --- Subplot 3: Total Moment Z (Yaw) ---
subplot(2,2,3); hold on; grid on; set(gca,'Color','white');
for k = 1:n
    plot(T{k}, MZ{k}, 'Color', colors{k}, 'LineStyle', ls{k}, 'LineWidth', lw, 'DisplayName', case_labels{k});
end
xlabel('Flow Time (s)'); ylabel('Moment Z (N·m)');
title('Total Moment Z (Yaw)');
legend('Location', 'best', 'FontSize', 8);

% --- Subplot 4: Total Force X ---
subplot(2,2,4); hold on; grid on; set(gca,'Color', 'white');
for k = 1:n
    plot(T{k}, FX{k}, 'Color', colors{k}, 'LineStyle', ls{k}, 'LineWidth', lw, 'DisplayName', case_labels{k});
end
xlabel('Flow Time (s)'); ylabel('Force X (N)');
title('Total Force X');
legend('Location', 'best', 'FontSize', 8);

% --- Global Figure Formatting ---
sgtitle('Sloshing Dynamics Comparison: Propellant Fill Levels (30%, 50%, 70%)', ...
        'FontSize', 14, 'FontWeight', 'bold');

fprintf('✓ Generated consolidated comparison figure.\n');
fprintf('Done!\n');

%% ════════════════════════════════════════════════════════════════════════
%  LOCAL FUNCTION – Read Fluent .out file
%  Skips 3-line header; returns struct with .time and .data vectors.
%  File column order: timestep  value  flow-time
% ════════════════════════════════════════════════════════════════════════
function s = readFluent(filepath)
    fid = fopen(filepath, 'r');
    if fid == -1
        error('Cannot open file:\n  %s', filepath);
    end
    for i = 1:3
        fgetl(fid);
    end
    raw = textscan(fid, '%f %f %f', 'CollectOutput', true);
    fclose(fid);
    raw    = raw{1};        % [timestep, value, flow_time]
    s.time = raw(:,3);
    s.data = raw(:,2);
end