function string = html_escape(string)
    %
    % HTML escape all of these "& < >"
    %
    %
    %
    % (C) Copyright 2022 Remi Gau

    html_codes = {'"', '&quot;'; ...
                  '<', '&lt;'; ...
                  '>', '&gt;'};

    % & must be handled first
    string = strrep(string, '&', '&amp;');

    for i = 1:size(html_codes, 1)
        string = strrep(string, html_codes{i, 1}, html_codes{i, 2});
    end

end
