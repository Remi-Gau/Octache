function octache_error(varargin)
    %
    % USAGE::
    %
    %  octache_error(functionName, id, msg, tolerant, verbose)
    %
    % :param functionName:
    % :type functionName: string
    % :param id: Error or warning id
    % :type id: string
    % :param msg: Message to print
    % :type msg: string
    %
    % EXAMPLE::
    %
    %  msg = sprintf('this error happened with this file %s', filename)
    %  id = 'thisError';
    %  octache_error(mfilename(), id, msg)
    %
    %
    % (C) Copyright 2022 Remi Gau

    default_fn_name = '';
    default_id = 'unspecified';
    default_msg = 'unspecified';

    p = inputParser;

    addOptional(p, 'functionName', default_fn_name, @ischar);
    addOptional(p, 'id', default_id, @ischar);
    addOptional(p, 'msg', default_msg, @ischar);

    parse(p, varargin{:});

    [~, functionName] = fileparts(p.Results.functionName);

    id = ['Octache:' functionName, ':' p.Results.id];

    errorStruct.identifier = id;
    errorStruct.message = sprintf(['\n' p.Results.msg]);
    error(errorStruct);

end
