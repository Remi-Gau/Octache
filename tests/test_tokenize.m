function test_suite = test_tokenize %#ok<*STOUT>
    %
    % (C) Copyright 2022 Remi Gau

    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end

    initTestSuite;

end

function test_tokenize_end_tokenize_space()

    % GIVEN
    template = ['  {{data}}  {{> partial}}', newline];

    % WHEN
    tokens = tokenize(template);

    % THEN
    assertEqual(tokens{3, 2}, '  ');

end

function test_tokenize_end_with_newline()

    % GIVEN
    template = ['{{>foo}}' newline];

    % WHEN
    tokens = tokenize(template);

    % THEN
    assertEqual(tokens{end, 2}, newline);

end

function test_tokenize_comment()

    % GIVEN
    tpl_file = setup_test('comment');

    % WHEN
    tokens = tokenize(tpl_file);

    % THEN
    expected = {'literal', ['comment test' newline '===' newline]; ...
                'literal', ['===' newline '===' newline]};
    assertEqual(tokens, expected);

end

function test_tokenize_basic()

    partials_path = fileparts(mfilename('fullpath'));

    % GIVEN
    tpl_file = fullfile(partials_path, 'data', 'test.mustache');

    % WHEN
    tokens = tokenize(tpl_file);

end
