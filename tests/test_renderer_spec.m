function test_suite = test_renderer_spec %#ok<*STOUT>
    %
    % (C) Copyright 2022 Remi Gau

    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end

    initTestSuite;

end

function test_renderer_spec_partials()

    fprintf(1, '\n');

    spec = jsonread(fullfile(spec_path(), 'partials.json'));

    st = dbstack;
    name_str = st.name;

    % TODO Failing tests
    % 8, 9
    for i = [10 1:7, 10:11] % 1:numel(spec.tests)

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

    for i = 1:numel(spec.tests)

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
    % 7 15:16 18 21
    for i = [1:5 6 8:14 17 19 20 22] % 1:numel(spec.tests)

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

function test_renderer_spec_delimiters()

    fprintf(1, '\n');

    spec = jsonread(fullfile(spec_path(), 'delimiters.json'));

    st = dbstack;
    name_str = st.name;

    for i = 1:numel(spec.tests)

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

function test_renderer_spec_sections()

    fprintf(1, '\n');

    spec = jsonread(fullfile(spec_path(), 'sections.json'));

    st = dbstack;
    name_str = st.name;

    % TODO Failing tests
    % lineskip and space related: 8, 11, 23, 24, 26:27 29
    for i = [1:7, 9:10, 12:22, 28, 30] % 1:numel(spec.tests)

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
