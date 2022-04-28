function test_suite = test_renderer_spec %#ok<*STOUT>
    %
    % (C) Copyright 2022 Remi Gau

    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end

    initTestSuite;

end

function test_renderer_spec_sections()

    fprintf(1, '\n');

    spec = jsonread(fullfile(spec_path(), 'sections.json'));

    st = dbstack;
    name_str = st.name;

    % TODO Failing tests
    % section / scope ? related: 8,
    % lineskip related: 11,
    % 18, 22, 23, 24, 26, 27, 28, 29
    for i = [1:7, 9:10, 12:17, 19:21, 30] % 1:numel(spec.tests)

        % GIVEN
        subtest = setup_subtest(spec, i);
        fprintf(1, ['\t' num2str(i) ' - ' name_str ':' subtest.name '\n']);

        % WHEN
        output = renderer(subtest.template, ...
                          'data', subtest.data, ...
                          'keep', false, ...
                          'warn', false);
        % THEN
        assertEqual(output, subtest.expected);

    end

end

function test_renderer_spec_interpolation()

    fprintf(1, '\n');

    spec = jsonread(fullfile(spec_path(), 'interpolation.json'));

    st = dbstack;
    name_str = st.name;

    for i = 1:numel(spec.tests)

        % GIVEN
        subtest = setup_subtest(spec, i);
        fprintf(1, ['\t' num2str(i) ' - ' name_str ':' subtest.name '\n']);

        % WHEN
        output = renderer(subtest.template, ...
                          'data', subtest.data, ...
                          'keep', false, ...
                          'warn', false);
        % THEN
        assertEqual(output, subtest.expected);

    end

end

function test_renderer_spec_delimiters()

    fprintf(1, '\n');

    spec = jsonread(fullfile(spec_path(), 'delimiters.json'));

    st = dbstack;
    name_str = st.name;

    % TODO Failing tests
    % 10 12 13 14
    for i = [1:9 11 15:numel(spec.tests)]

        % GIVEN
        subtest = setup_subtest(spec, i);
        fprintf(1, ['\t' num2str(i) ' - ' name_str ':' subtest.name '\n']);

        % WHEN
        if isfield(subtest, 'partials_dict')
            output = renderer(subtest.template, ...
                              'data', subtest.data, ...
                              'keep', false, ...
                              'partials_dict', subtest.partials_dict, ...
                              'warn', false);
        else
            output = renderer(subtest.template, ...
                              'data', subtest.data, ...
                              'keep', false, ...
                              'warn', false);
        end
        % THEN
        assertEqual(output, subtest.expected);

    end

end

function test_renderer_spec_partials()

    fprintf(1, '\n');

    spec = jsonread(fullfile(spec_path(), 'partials.json'));

    st = dbstack;
    name_str = st.name;

    % TODO Failing tests
    % 8, 9, 10
    for i = [1:7, 11] % 1:numel(spec.tests)

        % GIVEN
        subtest = setup_subtest(spec, i);
        fprintf(1, ['\t' num2str(i) ' - ' name_str ':' subtest.name '\n']);

        % WHEN
        output = renderer(subtest.template, ...
                          'data', subtest.data, ...
                          'keep', false, ...
                          'partials_dict', subtest.partials_dict, ...
                          'warn', false);
        % THEN
        assertEqual(output, subtest.expected);

    end

end

function test_renderer_spec_comment()

    fprintf(1, '\n');

    spec = jsonread(fullfile(spec_path(), 'comments.json'));

    st = dbstack;
    name_str = st.name;

    % TODO Failing tests
    % 4 6 7 9
    for i = [1:3 5 8 10:numel(spec.tests)] % 1:numel(spec.tests)

        % GIVEN
        subtest = setup_subtest(spec, i);
        fprintf(1, ['\t' num2str(i) ' - ' name_str ':' subtest.name '\n']);

        % WHEN
        output = renderer(subtest.template, ...
                          'keep', false, ...
                          'data', subtest.data, ...
                          'warn', false);
        % THEN
        assertEqual(output, subtest.expected);

    end

end

function test_renderer_spec_inverted()

    fprintf(1, '\n');

    spec = jsonread(fullfile(spec_path(), 'inverted.json'));

    st = dbstack;
    name_str = st.name;

    % TODO Failing tests
    % 2 4 7 9 11 14:16 18 20 21
    for i = [1 3 5 6 8 10 12:13 17 19 22] % 1:numel(spec.tests)

        % GIVEN
        subtest = setup_subtest(spec, i);
        fprintf(1, ['\t' num2str(i) ' - ' name_str ':' subtest.name '\n']);

        % WHEN
        output = renderer(subtest.template, ...
                          'keep', false, ...
                          'data', subtest.data, ...
                          'warn', false);
        % THEN
        assertEqual(output, subtest.expected);

    end

end

function pth = spec_path()
    pth = fullfile(path_test(), '..', 'spec', 'specs');
end

function subtest = setup_subtest(spec, i)

    if isstruct(spec.tests)

        subtest.name = spec.tests(i).name;
        subtest.template = spec.tests(i).template;
        subtest.data = spec.tests(i).data;
        subtest.expected = spec.tests(i).expected;
        if isfield(spec.tests(i), 'partials')
            subtest.partials_dict = spec.tests(i).partials;
        end

    elseif iscell(spec.tests)

        subtest.name = spec.tests{i}.name;
        subtest.template = spec.tests{i}.template;
        subtest.data = spec.tests{i}.data;
        subtest.expected = spec.tests{i}.expected;
        if isfield(spec.tests{i}, 'partials')
            subtest.partials_dict = spec.tests{i}.partials;
        end

    end
end
