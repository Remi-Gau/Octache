function test_suite = test_parse_tag %#ok<*STOUT>
    %
    % (C) Copyright 2022 Remi Gau

    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end

    initTestSuite;

end

function test_parse_tag_error_unclosed_tag()

    % GIVEN
    template = '#foo';

    % WHEN
    assertExceptionThrown(@() parse_tag(template), 'Octache:parse_tag:unclosedTag');

end

function test_parse_tag_error_unclosed_delimiter_tag()

    % GIVEN
    template = '=||}} foo';

    % WHEN
    assertExceptionThrown(@() parse_tag(template), 'Octache:parse_tag:unclosedDelimiterTag');

end

function test_parse_tag_basic()

    % GIVEN
    template = ' foo  }}.';

    % WHEN
    [tag_type, tag_key, template] = parse_tag(template);

    % THEN
    assertEqual(tag_type, 'variable');
    assertEqual(tag_key, 'foo');
    assertEqual(template, '.');

end

function test_parse_tag_others()

    % GIVEN
    template_type_key = {'> foo}}.', 'partial', 'foo'; ...
                         '=(( ))=}}.', 'set delimiter', '(( ))'; ...
                         '{html_escaped}}}.', 'no escape', 'html_escaped'};

    for i = 1:size(template_type_key, 1)

        fprintf(1, ['\n\t' template_type_key{i, 2}]);

        % WHEN
        [tag_type, tag_key, template] = parse_tag(template_type_key{i, 1});

        % THEN
        assertEqual(tag_type, template_type_key{i, 2});
        assertEqual(tag_key, template_type_key{i, 3});
        assertEqual(template, '.');

    end

    fprintf(1, '\n');

end
