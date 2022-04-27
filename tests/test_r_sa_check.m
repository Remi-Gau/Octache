function test_suite = test_r_sa_check %#ok<*STOUT>
    %
    % (C) Copyright 2022 Remi Gau

    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end

    initTestSuite;

end

function test_r_sa_check_false()

    % GIVEN
    is_standalone = false;
    template = ['  ' newlinebreak '  something '];
    tag_type = 'who cares';

    % WHEN
    status = r_sa_check(template, tag_type, is_standalone);

    % THEN
    assertEqual(status, false);

end

function test_r_sa_check_true()

    % GIVEN
    is_standalone = true;
    template = ['  ' newlinebreak '  something '];
    tag_type = 'who cares';

    % WHEN
    status = r_sa_check(template, tag_type, is_standalone);

    % THEN
    assertEqual(status, true);

end

function test_r_sa_check_false_2()

    % GIVEN
    is_standalone = true;
    template = [' a ' newlinebreak '  something '];
    tag_type = 'who cares';

    % WHEN
    status = r_sa_check(template, tag_type, is_standalone);

    % THEN
    assertEqual(status, false);

end
