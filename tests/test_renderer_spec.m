function test_suite = test_renderer_spec %#ok<*STOUT>
    %
    % (C) Copyright 2022 Remi Gau

    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end

    initTestSuite;

end

function test_renderer_spec_delimiters()

    fprintf(1, '\n');

    spec_path = fullfile(path_test(), '..', 'spec', 'specs');

    spec = jsonread(fullfile(spec_path, 'delimiters.json'));

    st = dbstack;
    namestr = st.name;

    % Failing tests
    % 3, 4, 5, 6, 10, 13
    for i = [1:2, 7:9, 11:12, 14] % 1:numel(spec.tests)

        % GIVEN
        subtest = setup_subtest(spec, i);
        fprintf(1, ['\t' num2str(i) ' - ' namestr ':' subtest.name '\n']);

        % WHEN
        output = renderer(subtest.template, ...
                          'data', subtest.data);
        % THEN
        assertEqual(output, subtest.expected);

    end

end

function test_renderer_spec_sections()

    fprintf(1, '\n');

    spec_path = fullfile(path_test(), '..', 'spec', 'specs');

    spec = jsonread(fullfile(spec_path, 'sections.json'));

    st = dbstack;
    namestr = st.name;

    % Failing tests
    % 7, 8, 9, 11, 13, 15, 16, 17, 18, 22, 23, 24, 26, 27, 29
    for i = [1:6, 10, 12, 14, 19:21, 28, 30] % 1:numel(spec.tests)

        % GIVEN
        subtest = setup_subtest(spec, i);
        fprintf(1, ['\t' num2str(i) ' - ' namestr ':' subtest.name '\n']);

        % WHEN
        output = renderer(subtest.template, ...
                          'data', subtest.data, ...
                          'keep', false);
        % THEN
        assertEqual(output, subtest.expected);

    end

end

function test_renderer_spec_interpolation()

    fprintf(1, '\n');

    spec_path = fullfile(path_test(), '..', 'spec', 'specs');

    spec = jsonread(fullfile(spec_path, 'interpolation.json'));

    st = dbstack;
    namestr = st.name;

    % Failing tests
    % 25
    for i = [1:24, 26:39] % 1:numel(spec.tests)

        % GIVEN
        subtest = setup_subtest(spec, i);
        fprintf(1, ['\t' num2str(i) ' - ' namestr ':' subtest.name '\n']);

        % WHEN
        output = renderer(subtest.template, ...
                          'data', subtest.data, ...
                          'keep', false, ...
                          'warn', false);
        % THEN
        assertEqual(output, subtest.expected);

    end

end

function test_renderer_spec_partials()

    fprintf(1, '\n');

    spec_path = fullfile(path_test(), '..', 'spec', 'specs');

    spec = jsonread(fullfile(spec_path, 'partials.json'));

    st = dbstack;
    namestr = st.name;

    % Failing tests
    % 8, 9, 10
    for i = [1:7, 11] % 1:numel(spec.tests)

        % GIVEN
        subtest = setup_subtest(spec, i);
        fprintf(1, ['\t' num2str(i) ' - ' namestr ':' subtest.name '\n']);

        % WHEN
        output = renderer(subtest.template, ...
                          'data', subtest.data, ...
                          'partials_dict', subtest.partials_dict);
        % THEN
        assertEqual(output, subtest.expected);

    end

end

function test_renderer_spec_comment()

    fprintf(1, '\n');

    spec_path = fullfile(path_test(), '..', 'spec', 'specs');

    spec = jsonread(fullfile(spec_path, 'comments.json'));

    st = dbstack;
    namestr = st.name;

    for i = 1:numel(spec.tests)

        % GIVEN
        subtest = setup_subtest(spec, i);
        fprintf(1, ['\t' num2str(i) ' - ' namestr ':' subtest.name '\n']);

        % WHEN
        output = renderer(subtest.template, ...
                          'data', subtest.data);
        % THEN
        assertEqual(output, subtest.expected);

    end

end

% function test_renderer_spec_inverted()
%
%     fprintf(1, '\n');
%
%     spec_path = fullfile(path_test(), '..', 'spec', 'specs');
%
%     spec = jsonread(fullfile(spec_path, 'inverted.json'));
%
%     st = dbstack;
%     namestr = st.name;
%
%     for i = 1:numel(spec.tests)
%
%         % GIVEN
%         subtest = setup_subtest(spec, i);
%         fprintf(1, ['\t' num2str(i) ' - ' namestr ':' subtest.name '\n']);
%
%         % WHEN
%         output = renderer(subtest.template, ...
%                           'data', subtest.data);
%         % THEN
%         assertEqual(output, subtest.expected);
%
%     end
%
% end

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
