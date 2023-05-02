function run_tests()
    %
    % run tests with code coverage
    %
    % USAGE::
    %
    %   run_tests()
    %
    % (C) Copyright 2022 Remi Gau

    tic;

    cd(fileparts(mfilename('fullpath')));

    setup();

    fprintf('\nHome is %s\n', getenv('HOME'));

    folder_to_cover = fullfile(pwd, 'src');

    test_folder = fullfile(pwd, 'tests');

    addpath(fullfile(test_folder, 'utils'));

    success = moxunit_runtests(test_folder, ...
                               '-verbose', '-recursive', '-with_coverage', ...
                               '-cover', folder_to_cover, ...
                               '-cover_xml_file', 'coverage.xml', ...
                               '-cover_html_dir', fullfile(pwd, 'coverage_html'));

    fileID = fopen('test_report.log', 'w');
    if success
        fprintf(fileID, '0');
    else
        fprintf(fileID, '1');
    end
    fclose(fileID);

    toc;

end
