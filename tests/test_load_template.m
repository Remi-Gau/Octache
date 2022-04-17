function test_suite = test_load_template %#ok<*STOUT>
    %
    % (C) Copyright 2022 Remi Gau

    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end

    initTestSuite;

end

function test_load_template_basic()

    test_dir = fileparts(mfilename('fullpath'));

    % GIVEN
    tpl_file = fullfile(test_dir, 'data', 'test.mustache');

    % WHEN
    template = load_template(tpl_file);

    % THEN
    assertEqual(size(template), [1, 1302]);

end

function test_load_template_cellstr()

    % GIVEN
    tpl = {'foo'; 'bar '};

    % WHEN
    template = load_template(tpl);

    % THEN
    assert(ischar(template));
    assertEqual(size(template), [2, 4]);

end
