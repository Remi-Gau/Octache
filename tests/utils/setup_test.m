function [tpl_file, data, expected, partials_path] = setup_test(test_type)
    %
    % (C) Copyright 2022 Remi Gau

    if ~isempty(test_type)
        test_type = ['_' test_type];
    end

    partials_path = fullfile(path_test(), 'data');

    data = jsonread(fullfile(partials_path, 'data.json'));

    tpl_file = fullfile(partials_path, ['test' test_type '.mustache']);

    expected = load_template(fullfile(path_test(), 'expected', ['test' test_type '.rendered']));

end
