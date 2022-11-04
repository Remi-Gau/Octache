function output = renderer(varargin)
    %
    % Render a mustache template with a data scope and partial capability.
    %
    % USAGE::
    %
    %   output = renderer(template, ...
    %                       'data', data, ...
    %                       'partials_path', pwd, ...
    %                       'partials_ext', 'mustache', ...
    %                       'scopes', {}, ...
    %                       'l_del', '{{', ...
    %                       'r_del', '}}', ...
    %                       'padding', '', ...
    %                       'partials_dict', struct([]), ...
    %                       'warn', true, ...
    %                       'keep', true);
    %
    % :param template: the path to a mustache file, a string or a cell of tokens to render
    % :type template: path or char or a (n X 2) cell
    %
    % :param data: The content of a json data file or a string
    % :type data: structure or char
    %
    % :param path: The path where your partials reside. Default is ``pwd``.
    % :type path: path
    %
    % :param ext: The extension for your mustache partials, ``mustache`` by default
    % :type ext: (1 x n) char
    %
    % :param scopes: A stash organized as a cell of structure that ``get_key`` will look through.
    %                Default: ``{}``.
    % :type scopes: cell
    %
    % :param l_del: The default left delimiter, ``{{`` by default
    % :type l_del: (1 x n) char
    %
    % :param r_del: The default right delimiter, ``}}`` by default
    % :type r_del: (1 x n) char
    %
    % :param padding: This is for padding partials, and shouldn't be used
    %                  (but can be if you really want to)
    % :type padding: (1 x n) char
    %
    % :param partials_dict: Will be search for partials before the filesystem is.
    %                  ``struct('include', 'foo')`` is the same
    %                  as a file called ``include.mustache``. Defaults: ``struct([])``.
    % :type partials_dict: structure
    %
    % :param warn: Print a warning for each undefined template key encountered
    % :type warn: boolean
    %
    % :param keep: Keep unreplaced tags when a template substitution isn't found in the data
    % :type keep: boolean
    %
    % :returns: - :output: (char) A string containing the rendered template.
    %
    %
    % **EXAMPLE 1**::
    %
    %   output = renderer('"Hello {{value}}! {{>who}}"', ...
    %                     'data', struct('value', 'world'), ...
    %                     'partials_dict', struct('who', 'I am Octache'))
    %
    %
    % **EXAMPLE 2**:
    %
    % Given the file structure::
    %
    %   |- main.ms
    %   |- main.m
    %   |__ partials
    %       |- part.ms
    %
    % then `main.m` would make the following call::
    %
    %   output = renderer(fullefile(pwd, 'main.ms'), ...
    %                       'data', struct('value', 'world'), ...
    %                       'partials_path', fullefile(pwd, 'partials'), ...
    %                       'partials_ext', 'ms', ...
    %                       'scopes', {}, ...
    %                       'warn', true, ...
    %                       'keep', true)
    %
    %
    % (C) Copyright 2022 Remi Gau

    args = inputParser;

    args.addRequired('template');
    args.addParameter('data', struct([]));
    args.addParameter('partials_path', pwd, @isdir);
    args.addParameter('partials_ext', 'mustache', @ischar);
    args.addParameter('scopes', {}, @iscell);
    args.addParameter('l_del', '{{', @ischar);
    args.addParameter('r_del', '}}', @ischar);
    args.addParameter('padding', '', @ischar);
    args.addParameter('partials_dict', struct([]));
    args.addParameter('warn', true, @islogical);
    args.addParameter('keep', true, @islogical);

    args.parse(varargin{:});

    template = args.Results.template;
    data = args.Results.data;
    partials_path = args.Results.partials_path;
    partials_ext = args.Results.partials_ext;
    scopes = args.Results.scopes;
    l_del = args.Results.l_del;
    r_del = args.Results.r_del;
    padding  = args.Results.padding;
    partials_dict = args.Results.partials_dict;
    warn = args.Results.warn;
    keep = args.Results.keep;

    output = '';

    if isempty(scopes)
        scopes = {data};
    end

    if isempty(template)
        return
    end

    if iscell(template) && size(template, 2) == 2
        % allows recursive calls when dealing with sections
        tokens = template;

    else
        tokens = tokenize(template, 'l_del', l_del, 'r_del', r_del);

    end

    % Run through the tokens as a stash we pop things from
    while ~isempty(tokens)

        tag = tokens{1, 1};
        key = tokens{1, 2};
        tokens(1, :) = [];

        if strcmp(tag, 'end')
            % Pop out of the latest scope
            % scopes(1) = [];

            % If the current scope is falsy and not the only scope
            % elseif not current_scope && length(scopes) ~= 1
            %     if tag in ['section', 'inverted section']:
            %         % Set the most recent scope to a falsy value
            %         % (I heard False is a good one)
            %         scopes.insert(0, False)

        elseif strcmp(tag, 'literal')
            % Add padding to the key and add it to the output
            output = [output, strrep(key, newlinebreak, [newlinebreak,  padding])];

        elseif strcmp(tag, 'variable')
            % Add the html escaped key to the output
            thing = get_key(key, scopes, warn, keep, l_del, r_del);
            % if thing is True and key == '.':
            % if we've coerced into a boolean by accident
            % (inverted tags do this)
            % then get the un-coerced object (next in the stack)
            %     thing = scopes[1]

            if isnumeric(thing)
                thing = num2str(thing);

            elseif isstruct(thing)
                % in case we get a scope and not a value, try to list its content
                % TODO what if the scope contains a structure or something else
                % than a string
                fields = fieldnames(thing);
                tmp = '';
                assert(numel(fields) == 1);
                for i = 1:numel(fields)
                    if ischar(thing.(fields{i}))
                        tmp = [tmp, thing.(fields{i})];
                    elseif isnumeric(thing.(fields{i}))
                        % TODO remove
                        % tmp = [tmp, num2str(thing.(fields{i}))];
                    end
                end
                thing =  tmp;
                clear tmp;

            end

            output = [output, html_escape(thing)];

            % If we're a no html escape tag
        elseif strcmp(tag, 'no escape')
            % Just lookup the key and add it
            thing = get_key(key, scopes, warn, keep, l_del, r_del);

            if isnumeric(thing)
                thing = num2str(thing);
            end

            output = [output, thing];

        elseif strcmp(tag, 'section')

            thing = get_key(key, scopes, warn, keep, l_del, r_del);

            [tags, tokens] = get_tags_this_section(tokens, 'section');

            text = '';

            if (islogical(thing) && ~thing) || isempty(thing)

            elseif isstruct(thing) || iscell(thing) || isnumeric(thing)

                for i = 1:numel(thing)

                    if isstruct(thing)
                        scopes = cat(1, {thing(i)}, scopes);
                    elseif iscell(thing) || isnumeric(thing)
                        scopes = cat(1, thing(i), scopes);
                    end

                    tmp = renderer(tags, ...
                                   'scopes', scopes, ...
                                   'partials_path', partials_path, ...
                                   'partials_ext', partials_ext, ...
                                   'l_del', l_del, ...
                                   'r_del', r_del, ...
                                   'padding', padding, ...
                                   'partials_dict', partials_dict, ...
                                   'warn', warn, ...
                                   'keep', keep);

                    text = [text, tmp];

                    scopes(1) = [];

                end

            elseif thing

                text = renderer(tags, ...
                                'scopes', scopes, ...
                                'partials_path', partials_path, ...
                                'partials_ext', partials_ext, ...
                                'l_del', l_del, ...
                                'r_del', r_del, ...
                                'padding', padding, ...
                                'partials_dict', partials_dict, ...
                                'warn', warn, ...
                                'keep', keep);

            end

            assert(ischar(text));
            output = [output, text];

        elseif strcmp(tag, 'inverted section')

            % Add the flipped scope to the scopes
            thing = get_key(key, scopes, warn, keep, l_del, r_del);

            if (islogical(thing) && thing) || ~isempty(thing)
                [~, tokens] = get_tags_this_section(tokens, 'inverted section');
            end

            % TODO
            % scopes.insert(0, not scope)

        elseif strcmp(tag, 'partial')

            partial = get_partial(key, partials_dict, partials_path, partials_ext);

            % Find what to pad the partial with
            left = regexp(output, newlinebreak, 'split');
            part_padding = padding;
            if all(isspace(left{end}))
                part_padding = [part_padding, left{end}];
            end

            % Render the partial
            part_out =  renderer(partial, ...
                                 'partials_path', partials_path, ...
                                 'partials_ext', partials_ext, ...
                                 'scopes', scopes, ...
                                 'l_del', l_del, ...
                                 'r_del', r_del, ...
                                 'padding', part_padding, ...
                                 'partials_dict', partials_dict, ...
                                 'warn', warn, ...
                                 'keep', keep);

            % If the partial was indented then remove the spaces from the end
            if all(isspace(left{end}))
                part_out(end - (numel(left{end}) - 1):end) = [];
            end

            % Add the partials output to the output
            output = [output, part_out];

        end

        % output

    end

end

function [tags, tokens] = get_tags_this_section(tokens, section_type)
    %
    % Gets all the tags from the current section or inverted section
    % and pops them from the tokens stash
    %

    tags = {};

    nested_section = 0;
    while ~isempty(tokens)

        section_tag = tokens{1, 1};
        section_key = tokens{1, 2};
        tokens(1, :) = [];

        if strcmp(section_tag, section_type)
            nested_section = nested_section + 1;
        end
        if strcmp(section_tag, 'end')
            nested_section = nested_section - 1;
        end
        if nested_section < 0
            break
        end

        tags{end + 1, 1} = section_tag;
        tags{end, 2} = section_key;

    end

end
