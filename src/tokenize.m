function tokens = tokenize(varargin)
    %
    % Tokenizes a mustache template in a generator fashion,
    % using file-like objects. It also accepts a string containing
    % the template.
    %
    % USAGE::
    %
    %   tokens = tokenize(template, 'l_del', '{{', 'r_del', '}}')
    %
    %
    % Arguments:
    %
    % :param template: the path to a mustache file or a string to render
    % :type template: path or char
    %
    % :param l_del: The default left delimiter, ``{{`` by default
    % :type l_del: (1 x n) char
    %
    % :param r_del: The default right delimiter, ``}}`` by default
    % :type r_del: (1 x n) char
    %
    %
    % :returns: - :tokens: A n x 2 cell of mustache tags in the form ``{tag_type, tag_key}``
    %
    % Where ``tag_type`` is one of:
    %
    % - ``literal``
    % - ``section``
    % - ``inverted section``
    % - ``end``
    % - ``partial``
    % - ``no escape``
    % - ``set delimiter``
    %
    % And ``tag_key`` is either the key or in the case of a literal tag,
    % the literal itself.
    %
    %
    % (C) Copyright 2022 Remi Gau

    global CURRENT_LINE
    global LAST_TAG_LINE

    CURRENT_LINE = 1;
    LAST_TAG_LINE = [];

    tokens = {};

    is_file = @(x) exist(x, 'file');

    args = inputParser;

    args.addRequired('template');
    args.addParameter('l_del', '{{', @ischar);
    args.addParameter('r_del', '}}', @ischar);

    args.parse(varargin{:});

    template = args.Results.template;
    l_del = args.Results.l_del;
    r_del = args.Results.r_del;

    is_standalone = true;
    open_sections = {};

    if is_file(template)
        template = load_template(template);
    end

    % TODO ensure that we have newline characters and not \n?

    while true

        [literal, template] = grab_literal(template, l_del);

        % If the template is completed
        % Then yield the literal and leave
        if strcmp(template, '')
            tokens{end + 1, 1} = 'literal';
            tokens{end, 2} = literal;
            break
        end

        % Do the first check to see if we could be a standalone
        is_standalone = l_sa_check(literal, is_standalone);

        [tag_type, tag_key, template] = parse_tag(template, l_del, r_del);

        % Special tag logic
        switch tag_type

            % If we are a set delimiter tag
            case 'set delimiter'
                % Then get and set the delimiters
                tag_key = strtrim(tag_key);
                dels = strsplit(tag_key, ' ');
                l_del = dels{1};
                r_del = dels{end};

                % If we are a section tag
            case {'section', 'inverted section'}
                % Then open a new section
                open_sections{end + 1} = tag_key;
                LAST_TAG_LINE = CURRENT_LINE;

            case 'end'
                % Then check to see if the last opened section
                % is the same as the one we are closing
                try
                    last_section = open_sections{end};
                    open_sections(end) = [];
                catch
                    msg = sprintf(['Trying to close tag "%s".\n', ...
                                   'Looks like it was not opened.\n', ...
                                   'line %i'], ...
                                  tag_key, CURRENT_LINE + 1);
                    id = 'closingUnopenedSection';
                    octache_error(mfilename(), id, msg);
                end

                % Otherwise we need to complain
                if ~strcmp(tag_key, last_section)
                    msg = sprintf(['Trying to close tag "%s".\n', ...
                                   'Last open tag is "%s"\n', ...
                                   'line %i'], ...
                                  tag_key, last_section, CURRENT_LINE + 1);
                    id = 'closingSectionNotMatchedToLastOpened';
                    octache_error(mfilename(), id, msg);
                end
        end

        % Do the second check to see if we're a standalone
        is_standalone = r_sa_check(template, tag_type, is_standalone);

        % Which if we are
        if is_standalone
            % Remove the stuff before the newlinebreak
            if ~strcmp(template, newlinebreak)
                tmp = regexp(template, newlinebreak, 'split', 'once');
                if numel(tmp) == 2
                    template = tmp{2};
                else
                    template = tmp{1};
                end
            end

            %   Partials need to keep the spaces on their left but other tags don't
            %     if ~strcmp(tag_type, 'partial')
            %         % Cannot use strip / deblank only as it turns newline into empty string
            %         % because REASONS (???!!!)
            %         tmp = strsplit(literal, newlinebreak);
            %         tmp{1} = strip(tmp{1}, 'left');
            %         literal = strjoin(tmp, newlinebreak);
            %     end

            % Remove spaces after linebreak and before standalone
            if ismember(tag_type, {'comment', 'set delimiter', 'section', 'inverted section'})
                tmp = regexp(literal, newlinebreak, 'split');
                tmp{end} = strip(tmp{end}, 'left');
                literal = strjoin(tmp, newlinebreak);
            end

        end

        % Start returning
        % Ignore literals that are empty
        if ~strcmp(literal, '')
            tokens{end + 1, 1} = 'literal';
            tokens{end, 2} = literal;
        end

        % Ignore comments and set delimiters
        if ~ismember(tag_type, {'comment', 'set delimiter?'})
            tokens{end + 1, 1} = tag_type;
            tokens{end, 2} = tag_key;
        end

    end

    % If there are any open sections when we're done we need to complain
    if ~isempty(open_sections)

        msg = sprintf(['Unexpected EOF\n', ...
                       'the tag "%s" was never closed\n', ...
                       'was opened at line %i'], ...
                      open_sections{end}, LAST_TAG_LINE);

        id = 'sectionUnclosed';
        octache_error(mfilename(), id, msg);

    end

end

function str = strip(str, side)
    %
    % removes white space on a side
    %
    % shadows a toolbox function from MATLAB but makes it available in Octave

    if strcmp(side, 'right')
        str = deblank(str);
    elseif strcmp(side, 'left')
        str = fliplr(str);
        str = deblank(str);
        str = fliplr(str);
    end
end
