% Directory where ROI files are stored
roi_dir = uigetdir('', 'Select the directory where ROI files are stored');

% Directory where lesion data files are stored
lesion_data_dir = uigetdir('', 'Select the directory where lesion files are stored');

% List of ROI files
roi_files = dir(fullfile(roi_dir, '*.mat'));

% List of lesion data files (assuming they are NIfTI files)
lesion_files = dir(fullfile(lesion_data_dir, '*.nii'));

% Initialize a matrix to store mean values
% Rows represent participants, columns represent ROIs
mean_values = zeros(length(lesion_files), length(roi_files));

% Loop through each participant's lesion data
for i = 1:length(lesion_files)
    lesion_data_path = fullfile(lesion_files(i).folder, lesion_files(i).name);
    lesion_data = spm_vol(lesion_data_path);

    % Loop through each ROI
    for j = 1:length(roi_files)
        roi_path = fullfile(roi_files(j).folder, roi_files(j).name);
        roi_obj = maroi('load', roi_path);  % Load the ROI object

        % Extract mean value from the ROI
        y = get_marsy(roi_obj, lesion_data, 'mean');
        mean_vals = summary_data(y);  % Extract mean value
        mean_values(i, j) = mean_vals;
    end
end

% Save the mean values to a .mat file
save('mean_values.mat', 'mean_values');
