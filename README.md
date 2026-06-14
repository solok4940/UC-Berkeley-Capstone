# UC-Berkeley-Capstone

ORDER OF COMMANDS TO GET CSV VALUES

1:

cd /Users/alexsolakhyan/Desktop/satellite_slosh_analysis

2:

preprocess_cfd_data

3:

clear sim

4:

sim('slosh_attitude_sim')

5:

>> out = ans;
>> attitude_out = out.attitude_out;
>> position_out = out.position_out;
>> velocity_out = out.velocity_out;
>> rates_out = out.rates_out;

%% Export Simulation Data to CSV
if ~exist('attitude_out', 'var')
    error('Run simulation first!');
end

% Attitude
att_table = table(attitude_out.time, ...
    attitude_out.signals.values(:,1), ...
    attitude_out.signals.values(:,2), ...
    attitude_out.signals.values(:,3), ...
    'VariableNames', {'Time_s', 'Roll_rad', 'Pitch_rad', 'Yaw_rad'});
writetable(att_table, 'attitude_data.csv');

% Position
pos_table = table(position_out.time, ...
    position_out.signals.values(:,1), ...
    position_out.signals.values(:,2), ...
    position_out.signals.values(:,3), ...
    'VariableNames', {'Time_s', 'X_m', 'Y_m', 'Z_m'});
writetable(pos_table, 'position_data.csv');

% Velocity  
vel_table = table(velocity_out.time, ...
    velocity_out.signals.values(:,1), ...
    velocity_out.signals.values(:,2), ...
    velocity_out.signals.values(:,3), ...
    'VariableNames', {'Time_s', 'Vx_ms', 'Vy_ms', 'Vz_ms'});
writetable(vel_table, 'velocity_data.csv');

% Rates
rates_table = table(rates_out.time, ...
    rates_out.signals.values(:,1), ...
    rates_out.signals.values(:,2), ...
    rates_out.signals.values(:,3), ...
    'VariableNames', {'Time_s', 'p_rads', 'q_rads', 'r_rads'});
writetable(rates_table, 'rates_data.csv');

fprintf('✓ Exported 4 CSV files:\n');
fprintf('  - attitude_data.csv\n');
fprintf('  - position_data.csv\n');
fprintf('  - velocity_data.csv\n');
fprintf('  - rates_data.csv\n');

Now, the 6DOF outputs are created in the original folder. Rename them and move it to the correct folder based on the type of analysis 
