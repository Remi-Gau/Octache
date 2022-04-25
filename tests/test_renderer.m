function test_suite = test_renderer %#ok<*STOUT>
    %
    % (C) Copyright 2022 Remi Gau

    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end

    initTestSuite;

end

function test_renderer_basic()

    partials_path = fullfile(fileparts(mfilename('fullpath')), 'data');
    partials_path = '/home/remi/github/mashlab/tests/data';

    % GIVEN
    tpl_file = fullfile(partials_path, 'test.mustache');
    data = jsonread(fullfile(partials_path, 'data.json'));

    % WHEN
    renderer(tpl_file, ...
             'data', data, ...
             'partials_path', partials_path);

end
