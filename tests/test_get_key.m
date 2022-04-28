function test_suite = test_get_key %#ok<*STOUT>
    %
    % (C) Copyright 2022 Remi Gau

    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end

    initTestSuite;

end

function test_get_context_precedence()

    % GIVEN
    warn = false;
    keep = false;
    l_del = '{{';
    r_del = '}}';
    key = 'b.c';
    scopes = {struct('b', struct('c', [])); ...
              struct('a', struct('b', struct([])), 'b', struct('c', 'ERROR'))};

    % WHEN
    value = get_key(key, scopes, warn, keep, l_del, r_del);

    % THEN
    assert(isempty(value));

end

function test_get_key_warning_missing()

    warn = true;
    keep = false;
    l_del = '{{';
    r_del = '}}';
    key = 'foo';
    scopes = {struct('bar', 1)};

    if is_octave
        % TODO
        % failure: warning 'Octave:mixed-string-concat' was raised,
        % expected 'Octache:get_key:MissingKey'.
        return
    end

    assertWarning(@() get_key(key, scopes, warn, keep, l_del, r_del), ...
                  'Octache:get_key:MissingKey');

end

function test_get_key_dot()

    % GIVEN
    warn = false;
    keep = false;
    l_del = '{{';
    r_del = '}}';
    key = '.';
    scopes = {struct('foo', 1)
              struct('bar', 2)};

    % WHEN
    value = get_key(key, scopes, warn, keep, l_del, r_del);

    % THEN
    assertEqual(value,  struct('foo', 1));

end

function test_get_key_value()

    % GIVEN
    warn = false;
    keep = false;
    l_del = '{{';
    r_del = '}}';
    key = 'bar';
    scopes = {struct('foo', 1)
              struct('bar', 2)};

    % WHEN
    value = get_key(key, scopes, warn, keep, l_del, r_del);

    % THEN
    assertEqual(value,  '2');

end

function test_get_key_value_nested()

    % GIVEN
    warn = false;
    keep = false;
    l_del = '{{';
    r_del = '}}';
    key = 'for.bar.baz.foz';
    scopes = {struct('for', struct('bar', struct('baz', struct('foz', 2))))};

    % WHEN
    value = get_key(key, scopes, warn, keep, l_del, r_del);

    % THEN
    assertEqual(value,  '2');

end

function test_get_key_value_missing()

    % GIVEN
    warn = false;
    keep = false;
    l_del = '{{';
    r_del = '}}';
    key = 'for.bar.baz.foo';
    scopes = {struct('for', struct('bar', struct('baz', struct('foz', 2))))};

    % WHEN
    value = get_key(key, scopes, warn, keep, l_del, r_del);

    % THEN
    assertEqual(value,  '');

end
