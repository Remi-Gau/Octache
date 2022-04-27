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

        if iscell(tmp)
            on_newline = tmp{1};

            % If the stuff to the right of us are spaces we're a standalone
            if isempty(on_newline) || all(isspace(on_newline))
                status = true;

            else
                status = false;

            end

        else
            % octave does not return cell when it cannot split
            status = false;

        end

        % If we're a tag can't be a standalone
    else
        status = false;

    end

end
