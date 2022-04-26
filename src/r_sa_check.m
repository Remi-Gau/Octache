function status = r_sa_check(template, tag_type, is_standalone)
    %
    % Right standalone check
    % Do a final check to see if a tag could be a standalone
    %
    % USAGE::
    %
    %   status = r_sa_check(template, tag_type, is_standalone)
    %
    %
    % (C) Copyright 2022 Remi Gau

    % Check right side if we might be a standalone
    if is_standalone && ~ismember(tag_type, {'variable', 'no escape'})
        tmp = regexp(template, newlinebreak, 'split', 'once');
        on_newline = tmp{1};

        % If the stuff to the right of us are spaces we're a standalone
        if isempty(on_newline) || isspace(on_newline(1))
            status = true;
        else
            status = false;
        end

        % If we're a tag can't be a standalone
    else
        status = false;

    end

end
