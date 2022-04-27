function test_suite = test_l_sa_check %#ok<*STOUT>
    %
    % (C) Copyright 2022 Remi Gau

    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end

    initTestSuite;

end

function test_l_sa_check_true()

    % GIVEN
    is_standalone = true;
    literal = ['foo ' newlinebreak '   '];

    % WHEN
    status = l_sa_check(literal, is_standalone);

    % THEN
    assertEqual(status, true);

end

function test_l_sa_check_false()

    % GIVEN
    is_standalone = true;
    literal = ['foo ' newlinebreak '   '];

    % WHEN
    status = l_sa_check(literal, is_standalone);

    % THEN
    assertEqual(status, true);

end

function test_l_sa_check_false_2()

    % GIVEN
    is_standalone = false;
    literal = 'foo    ';

    % WHEN
    status = l_sa_check(literal, is_standalone);

    % THEN
    assertEqual(status, true);

end
