function template = load_template(tpl)
    %
    % USAGE::
    %
    %   template = load_template(tpl)
    %
    % :param tpl: template to read from
    % :type tpl: path or cellstr
    %
    %
    % (C) Copyright 2022 Remi Gau

    % factored out from
    % gllmflndn/bids-matlab/blob/gllmflndn-report-template/%2Bbids/%2Binternal/parse_template.m

    if ischar(tpl)
        fid = fopen(tpl, 'rt', 'native', 'UTF-8');
        if fid == -1
            % TODO add test error
            msg = sprintf('Cannot open template file "%s".', tpl);
            octache_error(mfilename(), 'cannotOpenTemplate', msg);
        end
        template = fscanf(fid, '%c');
        fclose(fid);

    elseif iscellstr(tpl)
        template  = char(tpl);

    else
        % TODO add test error
        octache_error(mfilename(), 'invalidTemplate', 'Invalid template.');

    end

end
