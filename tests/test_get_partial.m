function test_suite = test_get_partial %#ok<*STOUT>
    %
    % (C) Copyright 2022 Remi Gau

    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end

    initTestSuite;

end

function test_get_partial_basic()

    test_dir = fileparts(mfilename('fullpath'));

    % GIVEN
    partials_path = fullfile(test_dir, 'data');
    partials_ext = 'mustache';
    partials_dict = struct([]);

    % WHEN
    partial = get_partial('partial', partials_dict, partials_path, partials_ext);

    % THEN
    assertEqual(partial, ['this is a partial{{excited}}' newlinebreak]);

end

function test_get_partial_no_path()

    test_dir = fileparts(mfilename('fullpath'));

    % GIVEN
    partials_path = '';
    partials_ext = 'mustache';
    partials_dict = struct([]);

    % WHEN
    partial = get_partial('partial', partials_dict, partials_path, partials_ext);

    % THEN
    assertEqual(partial, '');

end

function test_get_partial_dict()

    test_dir = fileparts(mfilename('fullpath'));

    % GIVEN
    partials_path = '';
    partials_ext = 'mustache';
    partials_dict = struct('partial', 'foo');

    % WHEN
    partial = get_partial('partial', partials_dict, partials_path, partials_ext);

    % THEN
    assertEqual(partial, 'foo');

end
