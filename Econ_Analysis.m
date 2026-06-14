% Global Constants
m_low = 118.496;    % kg
m_high = 205.112;   % kg
m_xenon = 23.38;    % kg
t_orbit = 90 * 60;  % 90 min orbit in seconds
T_sc = 21 + 273.15; % K
T_lv = 270;         % K
T_bus_low = -20 + 273.15; % K
T_bus_med = 15 + 273.15; %K
T_bus_high = 50 + 273.15; % K

% Calculations
% Heat radiation calculations
P_heat_sc_high = heat_radiation(T_sc, T_bus_high) + heat_conduction(T_sc, T_bus_high);
P_heat_sc_med = heat_radiation(T_sc, T_bus_med) + heat_conduction(T_sc, T_bus_med);
P_heat_sc_low  = heat_radiation(T_sc, T_bus_low) + heat_conduction(T_sc, T_bus_low);
P_heat_lv_high = heat_radiation(T_lv, T_bus_high) + heat_conduction(T_lv, T_bus_high);
P_heat_lv_med = heat_radiation(T_lv, T_bus_med) + heat_conduction(T_lv, T_bus_med);
P_heat_lv_low  = heat_radiation(T_lv, T_bus_low) + heat_conduction(T_lv, T_bus_low);

% Print Statements
fprintf('--- Heat Radiation Results ---\n');
fprintf('P_heat_sc_high : %.4f W\n', P_heat_sc_high);
fprintf('P_heat_sc_medium : %.4f W\n', P_heat_sc_med);
fprintf('P_heat_sc_low  : %.4f W\n', P_heat_sc_low);
fprintf('P_heat_lv_high : %.4f W\n', P_heat_lv_high);
fprintf('P_heat_lv_medium : %.4f W\n', P_heat_lv_med);
fprintf('P_heat_lv_low  : %.4f W\n', P_heat_lv_low);

delta_E = t_orbit * (P_heat_sc_med - P_heat_lv_med);
fprintf('Energy Saved : %.4f J\n', delta_E);

% =========================================================================
% Local Functions (Must remain at the bottom of the script in MATLAB)
% =========================================================================

function q_rad = heat_radiation(T_prop, T_bus)
    % Constants for Radiation Loss
    boltzmann = 5.67e-8;
    emissivity = 0.016;
    l_tank = 0.4;
    w_tank = 0.25;
    h_tank = 0.2;
    A_prop = 2 * (l_tank * w_tank + l_tank * h_tank + w_tank * h_tank);

    if T_prop < T_bus
        q_rad = 0; % No heat radiation loss
    else
        q_rad = emissivity * boltzmann * A_prop * (T_prop^4 - T_bus^4);
    end
end

function q_cond = heat_conduction(T_prop, T_bus)
    % Constants for Conduction Loss
    k = 6.7; % W/MK
    A_strut = 0.01 * 0.01; 
    A_strut_total = 4 * A_strut;
    l_strut = 0.03;

    if T_prop < T_bus
        q_cond = 0; % No heat transfer loss
    else
        q_cond = k * A_strut_total / l_strut * (T_prop - T_bus); 
    end
end

%==================================================================

P_ss = 10; %W
P_max = 100; %W

tau_max = 0.1; %Nm

C_tau = (P_max - P_ss) / tau_max; % W / Nm

torque_data = readtable('/Users/alexsolakhyan/Desktop/satellite_slosh_analysis/ATTITUDE_OUTPUTS/torque_data_translational.csv');

time = torque_data{:, 1}; 
torque = torque_data{:, 4}; 


wattage_baseline = P_ss * ones(size(time));
wattage_penalty = C_tau * abs(torque);
wattage_total = wattage_baseline + wattage_penalty;

additional_energy_J = trapz(time, wattage_penalty);
total_energy_J = trapz(time, wattage_total);

additional_energy_Wh = additional_energy_J / 3600;
total_energy_Wh = total_energy_J / 3600;

maneuver_duration = time(end) - time(1);
avg_additional_watts = additional_energy_J / maneuver_duration;

% Print Results to Command Window
fprintf('--- Reaction Wheel Energy Results ---\n');
fprintf('Maneuver Duration: %.1f seconds\n', time(end) - time(1));
fprintf('Baseline Energy Cost: %.2f Joules (%.4f Wh)\n', trapz(time, wattage_baseline), trapz(time, wattage_baseline)/3600);
fprintf('Additional Slosh Penalty: %.2f Joules (%.4f Wh)\n', additional_energy_J, additional_energy_Wh);
fprintf('Total Energy Consumed: %.2f Joules (%.4f Wh)\n\n', total_energy_J, total_energy_Wh);
fprintf('Average Additional Watts: %.2f Watts (%.4f Wh)\n\n', avg_additional_watts);

% --- Plotting ---
figure('Name', 'Reaction Wheel Power Draw', 'Color', 'w');
plot(time, wattage_total, 'r', 'LineWidth', 1.5); hold on;
plot(time, wattage_baseline, 'b--', 'LineWidth', 2);

% Optional: Fill the area between the baseline and total power to show the penalty
x_fill = [time', fliplr(time')];
y_fill = [wattage_total', fliplr(wattage_baseline')];
fill(x_fill, y_fill, 'r', 'FaceAlpha', 0.1, 'EdgeColor', 'none');

title('Reaction Wheel Power Draw During Translational Slosh Maneuver');
xlabel('Time (s)');
ylabel('Power (W)');

grid on;