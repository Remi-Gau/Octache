function partial = get_partial(name, partials_dict, partials_path, partials_ext)
    %
    % Load a partial
    %
    % USAGE::
    %
    %   partial = get_partial(name, partials_dict, partials_path, partials_ext)
    %
    %
    %
    % (C) Copyright 2022 Remi Gau

    partial = '';

    % Maybe the partial is in the dictionary
    if isfield(partials_dict, name)
        partial = partials_dict.(name);
        return
    end

    % Don't try loading from the file system if the partials_path empty
    if isempty(partials_path)
        return
    end

    % Nope...
    try
        % Maybe it's in the file system
        partial_path = fullfile(partials_path, [name, '.', partials_ext]);
        partial = load_template(partial_path);

    catch % IOError
        % Alright I give up on you
        return
    end
