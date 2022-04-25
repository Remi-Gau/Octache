function test_suite = test_renderer %#ok<*STOUT>
    %
    % (C) Copyright 2022 Remi Gau

    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end

    initTestSuite;

end

% TODO?
% function test_renderer_variable()
%
%     % GIVEN
%     [tpl_file, data, expected, partials_path] = setup_test('variable');
%
%     % WHEN
%     output = renderer(tpl_file, ...
%                       'data', data, ...
%                       'partials_path', partials_path);
%     % THEN
%     assertEqual(output, expected);
%
% end

function test_renderer_unicode_no_escape()

    % GIVEN
    [tpl_file, data, expected, partials_path] = setup_test('unicode_no_escape');

    % WHEN
    output = renderer(tpl_file, ...
                      'data', data, ...
                      'partials_path', partials_path);
    % THEN
    assertEqual(output, expected);

end

% TODO?
% function test_renderer_unicode_partial()
%
%     % GIVEN
%     [tpl_file, data, expected, partials_path] = setup_test('unicode_partial');
%
%     % WHEN
%     output = renderer(tpl_file, ...
%                       'data', data, ...
%                       'partials_path', partials_path);
%     % THEN
%     assertEqual(output, expected);
%
% end

function test_renderer_unicode_variable()

    % GIVEN
    [tpl_file, data, expected, partials_path] = setup_test('unicode_variable');

    % WHEN
    output = renderer(tpl_file, ...
                      'data', data, ...
                      'partials_path', partials_path);
    % THEN
    assertEqual(output, expected);

end

function test_renderer_unicode()

    % GIVEN
    [tpl_file, data, expected, partials_path] = setup_test('unicode');

    % WHEN
    output = renderer(tpl_file, ...
                      'data', data, ...
                      'partials_path', partials_path);
    % THEN
    assertEqual(output, expected);

end

% TODO
% function test_renderer_section_falsy()
%
%     % GIVEN
%     [tpl_file, data, expected, partials_path] = setup_test('section_falsy');
%
%     % WHEN
%     output = renderer(tpl_file, ...
%                       'data', data, ...
%                       'partials_path', partials_path);
%     % THEN
%     assertEqual(output, expected);
%
% end

function test_renderer_section_truthy()

    % GIVEN
    [tpl_file, data, expected, partials_path] = setup_test('section_truthy');

    % WHEN
    output = renderer(tpl_file, ...
                      'data', data, ...
                      'partials_path', partials_path);
    % THEN
    assertEqual(output, expected);

end

% TODO
% function test_renderer_delimiter()
%
%     % GIVEN
%     [tpl_file, data, expected, partials_path] = setup_test('delimiter');
%
%     % WHEN
%     output = renderer(tpl_file, ...
%                       'data', data, ...
%                       'partials_path', partials_path);
%     % THEN
%     assertEqual(output, expected);
%
% end

% TODO
% function test_renderer_partial()
%
%     % GIVEN
%     [tpl_file, data, expected, partials_path] = setup_test('partial');
%
%     % WHEN
%     output = renderer(tpl_file, ...
%                       'data', data, ...
%                       'partials_path', partials_path, ...
%                       'keep', false);
%     % THEN
%     assertEqual(output, expected);
%
% end

% TODO
% function test_renderer_list()
%
%     % GIVEN
%     [tpl_file, data, expected, partials_path] = setup_test('list');
%
%     % WHEN
%     output = renderer(tpl_file, ...
%                       'data', data, ...
%                       'partials_path', partials_path);
%     % THEN
%     assertEqual(output, expected);
%
% end

function test_renderer_html_escape_normal()

    % GIVEN
    [tpl_file, data, expected, partials_path] = setup_test('html_escape_normal');

    % WHEN
    output = renderer(tpl_file, ...
                      'data', data, ...
                      'partials_path', partials_path);
    % THEN
    assertEqual(output, expected);

end

function test_renderer_html_escape()

    % GIVEN
    [tpl_file, data, expected, partials_path] = setup_test('html_escape');

    % WHEN
    output = renderer(tpl_file, ...
                      'data', data, ...
                      'partials_path', partials_path);
    % THEN
    assertEqual(output, expected);

end

function test_renderer_html_triple_brackets()

    % GIVEN
    [tpl_file, data, expected, partials_path] = setup_test('html_triple_brackets');

    % WHEN
    output = renderer(tpl_file, ...
                      'data', data, ...
                      'partials_path', partials_path);
    % THEN
    assertEqual(output, expected);

end

function test_renderer_comment()

    % GIVEN
    [tpl_file, data, expected, partials_path] = setup_test('comment');

    % WHEN
    output = renderer(tpl_file, ...
                      'data', data, ...
                      'partials_path', partials_path);
    % THEN
    assertEqual(output, expected);

end

% TODO
% function test_renderer_basic()
%
%     % GIVEN
%     [tpl_file, data, expected, partials_path] = setup_test('');
%
%     % WHEN
%     output = renderer(tpl_file, ...
%                       'data', data, ...
%                       'partials_path', partials_path);
%
%     % THEN
%     assertEqual(output, expected);
%
% end
