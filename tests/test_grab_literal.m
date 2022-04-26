function test_suite = test_grab_literal %#ok<*STOUT>
    %
    % (C) Copyright 2022 Remi Gau

    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end

    initTestSuite;

end

function test_grab_literal_comment()

    % GIVEN
    template = ['comment test', newlinebreak, ...
                '===', newlinebreak, ...
                '{{!', newlinebreak, ...
                '    mustache comment', newlinebreak, ...
                '}}', newlinebreak, ...
                '===', newlinebreak, ...
                '==='];
    l_del = '{{';

    % WHEN
    [literal, template] = grab_literal(template, l_del);

    % THEN
    assertEqual(literal, ['comment test', newlinebreak, '===', newlinebreak]);
    assertEqual(template, ['!', newlinebreak, ...
                           '    mustache comment', newlinebreak, ...
                           '}}', newlinebreak, ...
                           '===', newlinebreak, ...
                           '===']);

end

function test_grab_literal_basic()

    % GIVEN
    template = 'this is:\n\n {{ foo }}';
    l_del = '{{';

    % WHEN
    [literal, template] = grab_literal(template, l_del);

    % THEN
    assertEqual(literal, 'this is:\n\n ');
    assertEqual(template, ' foo }}');

end

function test_grab_literal_only_literal()

    % GIVEN
    template = 'this is: foo';
    l_del = '{{';

    % WHEN
    [literal, template] = grab_literal(template, l_del);

    % THEN
    assertEqual(literal, 'this is: foo');
    assertEqual(template, '');

end
