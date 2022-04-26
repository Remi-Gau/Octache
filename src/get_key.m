function value = get_key(key, scopes, warn, keep, l_del, r_del)
    % Get a key from the current scope
    %
    % value = get_key(key, scopes, warn, keep, l_del, r_del)
    %
    % (C) Copyright 2022 Remi Gau

    value = '';

    % If the key is a dot
    if strcmp(key,  '.')
        % Then just return the current scope
        value = scopes{1};
        return
    end

    sub_keys = strsplit(key, '.');

    key_found = false;

    for idx_scope = 1:numel(scopes)

        scope = scopes{idx_scope};

        for i = 1:numel(sub_keys)

            if isfield(scope, sub_keys{i})
                scope = scope.(sub_keys{i});
                if i == numel(sub_keys)
                    value = scope;
                    key_found = true;
                end
            end

        end

        if key_found
            break
        end

    end

    % We couldn't find the key in any of the scopes
    if isempty(value)

        if warn
            warning('Could not find key %s', key);
        end

        if keep
            value = [l_del key r_del];
        end

    end

end
