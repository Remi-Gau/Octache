function output = get_key(key, scopes, warn, keep, l_del, r_del)
    % Get a key from the current scope
    %
    % value = get_key(key, scopes, warn, keep, l_del, r_del)
    %
    % (C) Copyright 2022 Remi Gau

    output = {};

    % If the key is a dot
    if strcmp(key,  '.')
        % Then just return the current scope
        output = scopes{1};
        return
    end

    sub_keys = strsplit(key, '.');

    key_found = false;

    % TODO if possible refactor this nested loop
    for idx_scope = 1:numel(scopes)

        scope = scopes{idx_scope};

        for i_list = 1:numel(scope)

            value = '';
            sub_scope = scope(i_list);

            for i_key = 1:numel(sub_keys)

                if isfield(sub_scope, sub_keys{i_key})
                    sub_scope = sub_scope.(sub_keys{i_key});
                    if i_key == numel(sub_keys)
                        value = sub_scope;
                        key_found = true;
                    end
                end

            end

            if key_found
                break
            end

        end

        if key_found
            output{end + 1} = value;
            break
        end

    end

    % We couldn't find the key in any of the scopes
    if isempty(output)

        output = '';

        if warn
            warning('Could not find key %s', key);
        end

        if keep
            output = [l_del key r_del];
        end

    end

    if numel(output) == 1
        output = output{1};
    end

end