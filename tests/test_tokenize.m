function test_suite = test_tokenize %#ok<*STOUT>
    %
    % (C) Copyright 2022 Remi Gau

    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end

    initTestSuite;

end

function test_tokenize_basic()

    % GIVEN
    template = 'This is \n: {{ foo  }}.';

    % WHEN
    output = tokenize(template);

    % THEN
    expected = {'literal', 'This is \n: '; ...
                'variable', 'foo'; ...
                'literal', '.'};
    assertEqual(output, expected);

end
