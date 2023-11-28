% Script to adapt output of OligoMiner to tab-separated input required for the MS and BS inputs of OligoLego.

% Custom inputs
OligoMiner_output_file = 'Region1\unmasked\region_1_unmasked_homology.csv'; % Path to OligoMiner output
OligoLego_input_file = 'Region1\unmasked\region_1_oligolego.txt'; % Path to desired file - will be OligoLego input
start_region = 7180500; % First coordinate of the region in bps.
end_region = 7214499; % Last coordinate of the region in bps
chromosome = "chr12";
region_name = "region1_PEX5";

% Read data - OligoMiner output
OligoMiner_output_data = readtable(OligoMiner_output_file, "Filetype", "text", "Delimiter", ",");
n_probes = height(OligoMiner_output_data);

% Create OligoLego input data
OligoLego_input_data = table(repmat(chromosome, n_probes, 1), ...
    repmat(start_region, n_probes, 1), ...
    repmat(end_region, n_probes, 1), ...
    repmat(region_name, n_probes, 1), ...
    repmat(chromosome, n_probes, 1), ...
    OligoMiner_output_data.start + start_region - 1, ... % If MATLAB throws an error, modify first term by str2double(OligoMiner_output_data.start)
    OligoMiner_output_data.stop + start_region -1, ... % If MATLAB throws an error, modify first term by str2double(OligoMiner_output_data.stop)
    OligoMiner_output_data.sequence, ...
    OligoMiner_output_data.Tm);

% Save file
writetable(OligoLego_input_data, OligoLego_input_file, 'Delimiter', '\t', 'WriteVariableNames', false)
