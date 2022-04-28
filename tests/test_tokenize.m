function test_suite = test_tokenize %#ok<*STOUT>
    %
    % (C) Copyright 2022 Remi Gau

    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end

    initTestSuite;

end

function test_tokenize_indented_standalone()

    % GIVEN
    template = ['Begin.', newlinebreak, ...
                '  {{! Indented Comment Block! }}', newlinebreak, ...
                'End.'];

    tokens = tokenize(template);

    assertEqual(tokens{1, 2}, ['Begin.' newlinebreak]);
    assertEqual(tokens{2, 2}, 'End.');

end

function test_tokenize_error_unclosed_section()

    % GIVEN
    template = '"{{#boolean}}This should be rendered."';

    % WHEN
    assertExceptionThrown(@() tokenize(template), 'Octache:tokenize:sectionUnclosed');

end

function test_tokenize_error_unopened_section()

    % GIVEN
    template = '"This should be rendered.{{/boolean}}"';

    % WHEN
    assertExceptionThrown(@() tokenize(template), 'Octache:tokenize:closingUnopenedSection');

end

function test_tokenize_error_closing_wrong_section()

    % GIVEN
    template = '"{{#boolean}}{{#foo}}This should be rendered.{{/boolean}}{{/foo}}"';

    % WHEN
    assertExceptionThrown(@() tokenize(template), ...
                          'Octache:tokenize:closingSectionNotMatchedToLastOpened');

end

function test_tokenize_delimiters_2()

    % GIVEN
    template = ['===', newlinebreak, ...
                '{{= | | =}}', newlinebreak, ...
                '|test|', newlinebreak, ...
                '|= {{ }} =|', newlinebreak, ...
                'test'];

    % WHEN
    tokens = tokenize(template);

    assertEqual(tokens{4, 2}, newlinebreak);
end

function test_tokenize_delimiters_1()

    % GIVEN
    template = ['[', newlinebreak, ...
                '{{#section}}', newlinebreak, ...
                '  {{data}}', newlinebreak, ...
                '  |data|', newlinebreak, ...
                '{{/section}}', newlinebreak, newlinebreak, ...
                '{{= | | =}}', newlinebreak, ...
                '|#section|', newlinebreak, ...
                '  {{data}}', newlinebreak, ...
                '  |data|', newlinebreak, ...
                '|/section|', newlinebreak, ...
                ']'];

    % WHEN
    tokens = tokenize(template);

    % THEN
    assertEqual(tokens{9, 1}, 'section');
    assertEqual(tokens{9, 2}, 'section');

end

function test_tokenize_end_tokenize_space()

    % GIVEN
    template = ['  {{data}}  {{> partial}}', newlinebreak];

    % WHEN
    tokens = tokenize(template);

    % THEN
    assertEqual(tokens{3, 2}, '  ');

end

function test_tokenize_end_with_newline()

    % GIVEN
    template = ['{{>foo}}' newlinebreak];

    % WHEN
    tokens = tokenize(template);

    % THEN
    assertEqual(tokens{end, 2}, newlinebreak);

end

function test_tokenize_comment()

    % GIVEN
    tpl_file = setup_test('comment');

    % WHEN
    tokens = tokenize(tpl_file);

    % THEN
    expected = {'literal', ['comment test' newlinebreak '===' newlinebreak]; ...
                'literal', ['===' newlinebreak '===' newlinebreak]};
    assertEqual(tokens, expected);

end

function test_tokenize_basic()

    partials_path = fileparts(mfilename('fullpath'));

    % GIVEN
    tpl_file = fullfile(partials_path, 'data', 'test.mustache');

    % WHEN
    tokens = tokenize(tpl_file);

end
