function  [tag_type, tag_key, template] = parse_tag(template, l_del, r_del)
    %
    % Parse a tag from a template
    %
    %
    %
    % (C) Copyright 2022 Remi Gau

    global CURRENT_LINE

    tag_types = {
                 '!', 'comment'
                 '#', 'section'
                 '^', 'inverted section'
                 '/', 'end'
                 '>', 'partial'
                 '=', 'set delimiter?'
                 '{', 'no escape?'
                 '&', 'no escape'
                };

    % Get the tag
    try
        tmp = regexp(template, r_del, 'split', 'once');
        tag = tmp{1};
        template = tmp{2};
        cler tmp;
    catch
        error('unclosed tag at line %i', CURRENT_LINE);
    end

    % Find the type meaning of the first character
    idx = cellfun(@(x) strcmp(x, tag(0)), tag_types(:, 1));
    if isempty(idx)
        tag_type = 'variable';
    else
        tag_type = tag_types{idx, 2};
    end

    % If the type is not a variable
    if ~strcmp(tag_type, 'variable')
        % Then that first character is not needed
        tag = tag(2:end);
    end

    % If we might be a set delimiter tag
    if strcmp(tag_type, 'set delimiter?')

        % Double check to make sure we are
        if ~strcmp(tag(end), '=')

            error('unclosed tag at line %i', CURRENT_LINE);

        end

        tag_type = 'set delimiter';
        % Remove the equal sign
        tag = tag(1:end - 1);

        % If we might be a no html escape tag
    elseif strcmp(tag_type, 'no escape?')
        % And we have a third curly brace
        % (And are using curly braces as delimiters)
        if strcmp(l_del, '{{') && strcmp(r_del, '}}') && strcmp(template(1), '}')
            % Then we are a no html escape tag
            template = template(2:end);
            tag_type = 'no escape';
        end
    end

    % Strip the whitespace off the key and return
    tag_key = strtrim(tag);

end
