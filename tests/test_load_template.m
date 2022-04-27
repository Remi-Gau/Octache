function test_suite = test_load_template %#ok<*STOUT>
    %
    % (C) Copyright 2022 Remi Gau

    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end

    initTestSuite;

end

function test_load_template_error_2()

    template = 'non_existing_file.ms';
    assertExceptionThrown(@() load_template(template), 'Octache:load_template:cannotOpenTemplate');

end

function test_load_template_error_1()

    template = struct([]);
    assertExceptionThrown(@() load_template(template), 'Octache:load_template:invalidTemplate');

end

function test_load_template_basic()

    test_dir = fileparts(mfilename('fullpath'));

    % GIVEN
    tpl_file = fullfile(test_dir, 'data', 'test.mustache');

    % WHEN
    template = load_template(tpl_file);

    % THEN
    if is_octave
        assertEqual(size(template), [1 1392]);

    else
        assertEqual(size(template), [1, 1302]);

    end

end

function test_load_template_cellstr()

    % GIVEN
    tpl = {'foo\n'; 'bar '};

    % WHEN
    template = load_template(tpl);

    % THEN
    assert(ischar(template));
    assertEqual(size(template), [2, 5]);

end
