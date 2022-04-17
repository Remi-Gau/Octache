function mashlab(varargin)
    %
    % Render mustache templates using json files as input data
    %
    % :param template: The mustache file
    % :type template: path
    %
    % :param path: The directory where your partials reside. Default is ``pwd``.
    % :type path: path
    %
    % :param data: The json data file
    % :type data: path
    %
    % :param ext: The extension for your mustache partials, ``mustache`` by default
    % :type ext: (1 x n) char
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
    % (C) Copyright 2022 Remi Gau

    is_file = @(x) exist(x, 'file');

    args = inputParser;

    args.addRequired('template', is_file);
    % only one json file allowed as data?
    args.addParameter('data', '');
    args.addParameter('path', pwd, @isdir);
    args.addParameter('ext', 'mustache', @ischar);
    args.addParameter('left_delim', '{{', @ischar);
    args.addParameter('right_delim', '}}', @ischar);
    args.addParameter('warn', true, @islogical);
    % args.addParameter('version', '');

    args.parse(varargin{:});

    % version = args.Results.version;
    % if strcmp(version, '')
    %     fprintf(1, [get_version(), '\n']);
    %     return
    % end

    template = args.Results.template;
    data = args.Results.data;
    path = args.Results.path;
    ext = args.Results.template;
    left_delim = args.Results.left_delim;
    right_delim = args.Results.right_delim;
    warn = args.Results.warn;

    if ~strcmp(data, '')
        if ~is_file(data)
            error('%i is not a file.', data);
        else
            % requires JSONio
            data = jsondecode(data);
        end
    end

end

% def main(template, data=None, **kwargs):
% with io.open(template, 'r', encoding='utf-8') as template_file:
%     yaml_loader = kwargs.pop('yaml_loader', None) or 'SafeLoader'

%     if data is not None:
%         with io.open(data, 'r', encoding='utf-8') as data_file:
%             data = _load_data(data_file, yaml_loader)
%     else:
%         data = {}

%     args = {
%         'template': template_file,
%         'data': data
%     }

%     args.update(kwargs)
%     return render(**args)
