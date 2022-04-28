%
% (C) Copyright 2022 Remi Gau

clear;
clc;

%%
output = octache('"Hello {{value}}! {{who}}"', ...
                 'data', struct('value', 'world', ...
                                'who', 'I am Octache'));

fprintf(1, output);

fprintf('\n\n');

%% from http://mustache.github.io/#demo
path_to_file_to_render = fullfile(pwd, 'demo.mustache');
path_data_JSON = fullfile(pwd, 'demo.json');

output = octache(path_to_file_to_render, ...
                 'data', path_data_JSON, ...
                 'warn', false, ...
                 'keep', false);

fprintf(1, output);

% Expected

% <h1>Colors</h1>
% <li><strong>red</strong></li>
% <li><a href="#Green">green</a></li>
% <li><a href="#Blue">blue</a></li>

fprintf('\n\n');

%% Something more complex

path_to_file_to_render = fullfile(pwd, 'main.mustache');
path_data_JSON = fullfile(pwd, 'anat.json');
path_folder_with_partials = fullfile(pwd, 'partials');

output = octache(path_to_file_to_render, ...
                 'data', path_data_JSON, ...
                 'partials_path', path_folder_with_partials, ...
                 'partials_ext', 'mustache', ...
                 'warn', true, ...
                 'keep', true);

fprintf(1, output);
