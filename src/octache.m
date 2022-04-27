function output = octache(varargin)
    %
    % Renders mustache templates
    %
    % USAGE::
    %
    %   output = octache(path_to_file_to_render, ...
    %                   'data', path_data_JSON, ...
    %                   'partials_path', pwd, ...
    %                   'partials_ext', 'mustache', ...
    %                   'l_del', '{{', ...
    %                   'r_del', '}}', ...
    %                   'warn', true, ...
    %                   'keep', true);
    %
    %
    % :param template: The file or string to render
    % :type template: path or char
    %
    % :param partials_path: The directory where your partials reside. Default is ``pwd``.
    % :type partials_path: path
    %
    % :param data: The json data file or an equivalent structure
    % :type data: path
    %
    % :param partials_ext: The extension for your mustache partials, ``mustache`` by default
    % :type partials_ext: (1 x n) char
    %
    % :param left_delim: The default left delimiter, ``{{`` by default
    % :type left_delim: (1 x n) char
    %
    % :param right_delim: The default right delimiter, ``}}`` by default
    % :type right_delim: (1 x n) char
    %
    % :param warn: Print a warning for each undefined template key encountered
    % :type warn: boolean
    %
    % :param keep: Keep unreplaced tags when a template substitution isn't found in the data
    % :type keep: boolean
    %
    % **EXAMPLE 1**::
    %
    %   output = octache('"Hello {{value}}! {{who}}"', ...
    %                    'data', struct('value', 'world', ...
    %                                   'who', 'I am Octache'))
    %
    %
    % (C) Copyright 2022 Remi Gau

    is_file = @(x) exist(x, 'file');

    args = inputParser;

    args.addRequired('template');
    args.addParameter('data', struct([]));
    args.addParameter('partials_path', pwd, @isdir);
    args.addParameter('partials_ext', 'mustache', @ischar);
    args.addParameter('l_del', '{{', @ischar);
    args.addParameter('r_del', '}}', @ischar);
    args.addParameter('warn', true, @islogical);
    args.addParameter('keep', true, @islogical);

    args.parse(varargin{:});

    template = args.Results.template;
    data = args.Results.data; % TODO add input validation on "data"
    partials_path = args.Results.partials_path;
    partials_ext = args.Results.partials_ext;
    l_del = args.Results.l_del;
    r_del = args.Results.r_del;
    warn = args.Results.warn;
    keep = args.Results.keep;

    if ~isstruct(data) && is_file(data)
        % requires JSONio
        data = jsonread(data);
    end

    output = renderer(template, ...
                      'data', data, ...
                      'partials_path', partials_path, ...
                      'partials_ext', partials_ext, ...
                      'l_del', l_del, ...
                      'r_del', r_del, ...
                      'warn', warn, ...
                      'keep', keep);

end
