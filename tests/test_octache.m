function test_suite = test_octache %#ok<*STOUT>
    %
    % (C) Copyright 2022 Remi Gau

    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end

    initTestSuite;

end

function test_octache_hello_world()

    output = octache('"Hello {{value}}! {{who}}"', ...
                     'data', struct('value', 'world', ...
                                    'who', 'I am Octache'));

    assertEqual(output,  '"Hello world! I am Octache"');

end

function test_octache_basic()

    % GIVEN
    partials_path = fullfile(path_test(), 'data');

    data = fullfile(partials_path, 'data.json');

    tpl_file = fullfile(partials_path, 'test.mustache');

    expected = load_template(fullfile(path_test(), 'expected', 'test.rendered'));

    % WHEN
    output = octache(tpl_file, ...
                     'data', data, ...
                     'partials_path', partials_path, ...
                     'warn', false);

    % THEN
    % TODO
    %     assertEqual(output, expected);

end
