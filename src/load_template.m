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

    % adapted from
    % gllmflndn/bids-matlab/blob/gllmflndn-report-template/%2Bbids/%2Binternal/parse_template.m

    if ischar(tpl)

        if is_octave
            % for old octave?
            % https://savannah.gnu.org/bugs/?55826
            fid = fopen(tpl, 'rt', 'native');
        else
            fid = fopen(tpl, 'rt', 'native', 'UTF-8');
        end

        if fid == -1
            msg = sprintf('Cannot open template file "%s".', tpl);
            octache_error(mfilename(), 'cannotOpenTemplate', msg);
        end

        template = fscanf(fid, '%c');
        fclose(fid);

    elseif iscellstr(tpl)
        % TODO: is this ever used in practice?
        template  = char(tpl);

    else
        octache_error(mfilename(), 'invalidTemplate', 'Invalid template.');

    end

end
