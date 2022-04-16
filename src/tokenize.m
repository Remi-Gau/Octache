function tokenize(varargin)
    %
    % Tokenizes a mustache template in a generator fashion,
    % using file-like objects. It also accepts a string containing
    % the template.
    %
    % USAGE::
    %
    %   tokenize(template, 'def_ldel', '{{', 'def_rdel, '}}')
    %
    %
    % Arguments:
    %
    % template -- a file-like object, or a string of a mustache template
    %
    % def_ldel -- The default left delimiter
    %             ("{{" by default, as in spec compliant mustache)
    %
    % def_rdel -- The default right delimiter
    %             ("}}" by default, as in spec compliant mustache)
    %
    %
    % Returns:
    %
    % A generator of mustache tags in the form of a tuple
    %
    % -- (tag_type, tag_key)
    %
    % Where tag_type is one of:
    %  * literal
    %  * section
    %  * inverted section
    %  * end
    %  * partial
    %  * no escape
    %
    % And tag_key is either the key or in the case of a literal tag,
    % the literal itself.
    %
    %
    %
    % (C) Copyright 2022 Remi Gau

    global CURRENT_LINE
    global LAST_TAG_LINE

    CURRENT_LINE = 1;
    LAST_TAG_LINE = [];

    args = inputParser;

    args.addRequired('template', @isstruct);
    args.addParameter('def_ldel', '{{', @ischar);
    args.addParameter('def_rdel', '}}', @ischar);

    args.parse(varargin{:});

    template = args.Results.template;
    l_del = args.Results.def_ldel;
    r_del = args.Results.def_rdel;

    is_standalone = true;
    open_sections = {};

    template = load_template(template);

    while true

        [literal, template] = grab_literal(template, l_del);

        % If the template is completed
        % Then yield the literal and leave
        if strcmp(template, '')
            return
        end

        % Do the first check to see if we could be a standalone
        is_standalone = l_sa_check(template, literal, is_standalone);

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
                % is the same as us
                try
                    last_section = open_sections{end};
                    open_sections{end} = [];
                catch
                    error(['Trying to close tag %s.\n', ...
                           'Looks like it was not opened.\n', ...
                           'line %i'], ...
                          tag_key, CURRENT_LINE + 1);
                end

                % Otherwise we need to complain
                if ~strcmp(tag_key, last_section)
                    error(['Trying to close tag %s.\n', ...
                           'Last open tag is %s\n', ...
                           'line %i'], ...
                          tag_key, last_section, CURRENT_LINE + 1);
                end
        end

        % Do the second check to see if we're a standalone
        is_standalone = r_sa_check(template, tag_type, is_standalone);

        % Which if we are
        if is_standalone
            % Remove the stuff before the newline
            tmp = regexp(template, '\\n', 'split', 'once');
            template = tmp{2};

            % Partials need to keep the spaces on their left
            if tag_type ~= 'partial'
                % But other tags don't
                literal = deblank(literal);
            end
        end

        % Start returning
        % % Ignore literals that are empty
        % if ~strcmp(literal, '')
        %     yield ('literal', literal)
        % end

        % % Ignore comments and set delimiters
        % if ~ismember(tag_type, {'comment', 'set delimiter?'}
        %     yield (tag_type, tag_key)
        % end

    end

    % If there are any open sections when we're done
    if ~isempty(open_sections)
        % Then we need to complain
        error(['Unexpected EOF\n', ...
               'the tag %s was never closed\n', ...
               'was opened at line %i'], ...
              open_sections{end}, LAST_TAG_LINE);

    end

end
