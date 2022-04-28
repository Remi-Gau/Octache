function test_suite = test_renderer %#ok<*STOUT>
    %
    % (C) Copyright 2022 Remi Gau

    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end

    initTestSuite;

end

function test_renderer_unicode_partial()

    % GIVEN
    [tpl_file, data, expected, partials_path] = setup_test('unicode_partial');

    % WHEN
    output = renderer(tpl_file, ...
                      'data', data, ...
                      'partials_path', partials_path);
    % THEN
    assertEqual(output, expected);

end

function test_renderer_delimiter()

    % GIVEN
    [tpl_file, data, expected, partials_path] = setup_test('delimiter');

    % WHEN
    output = renderer(tpl_file, ...
                      'data', data, ...
                      'partials_path', partials_path);
    % THEN
    assertEqual(output, expected);

end

function test_renderer_section_list()

    % GIVEN
    data = struct('list', {{ struct('item', 1), struct('item', 2), struct('item', 3)}});
    template = '{{#list}}{{item}}{{/list}}';

    % WHEN
    output = renderer(template, ...
                      'data', data);
    % THEN
    assertEqual(output, '123');

end

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

% TODO?
% function test_renderer_inverted_section()
%
%     % GIVEN
%     [tpl_file, data, expected, partials_path] = setup_test('inverted_section');
%
%     % WHEN
%     output = renderer(tpl_file, ...
%                       'data', data, ...
%                       'partials_path', partials_path);
%     % THEN
%     assertEqual(output, expected);
%
% end

function test_renderer_scope()

    % GIVEN
    [tpl_file, data, expected, partials_path] = setup_test('scope');

    % WHEN
    output = renderer(tpl_file, ...
                      'data', data, ...
                      'partials_path', partials_path);
    % THEN
    assertEqual(output, expected);

end

function test_renderer_variable()

    % GIVEN
    [tpl_file, data, expected, partials_path] = setup_test('variable');

    % WHEN
    output = renderer(tpl_file, ...
                      'data', data, ...
                      'partials_path', partials_path);
    % THEN
    assertEqual(output, expected);

end

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

function test_renderer_section_falsy()

    % GIVEN
    [tpl_file, data, expected, partials_path] = setup_test('section_falsy');

    % WHEN
    output = renderer(tpl_file, ...
                      'data', data, ...
                      'partials_path', partials_path);
    % THEN
    assertEqual(output, expected);

end

function test_renderer_partial()

    % GIVEN
    [tpl_file, data, expected, partials_path] = setup_test('partial');

    % WHEN
    output = renderer(tpl_file, ...
                      'data', data, ...
                      'partials_path', partials_path, ...
                      'keep', false, ...
                      'warn', false);
    % THEN
    assertEqual(output, expected);

end

function test_renderer_list()

    % GIVEN
    [tpl_file, data, expected, partials_path] = setup_test('list');

    % WHEN
    output = renderer(tpl_file, ...
                      'data', data, ...
                      'partials_path', partials_path);
    % THEN
    assertEqual(output, expected);

end

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

function test_renderer_basic()

    % GIVEN
    [tpl_file, data, expected, partials_path] = setup_test(''); %#ok<ASGLU>

    % WHEN
    output = renderer(tpl_file, ...
                      'data', data, ...
                      'partials_path', partials_path, ...
                      'warn', false);
    % THEN
    % TODO
    % assertEqual(output, expected);

end
