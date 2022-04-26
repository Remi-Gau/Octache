function [literal, template] = grab_literal(template, l_del)
    %
    % Parse a literal from the template
    %
    % USAGE::
    %
    %   grab_literal(template, l_del)
    %
    %
    % (C) Copyright 2022 Remi Gau

    global CURRENT_LINE

    try
        % Look for the next tag and move the template to it
        tmp = strsplit(template, l_del);
        literal = tmp{1};
        template = strjoin(tmp(2:end), l_del);
        new_lines = regexp(literal, newlinebreak, 'match');
        CURRENT_LINE = CURRENT_LINE + numel(new_lines);

        % There are no more tags in the template?
    catch ME
        % Then the rest of the template is a literal
        literal = template;
        template = '';

    end

end
