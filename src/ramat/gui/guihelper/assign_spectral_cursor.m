function assign_spectral_cursor(f, ax)
    %ASSIGN_SPECTRAL_CURSOR Checks if axes already have a cursor

    if ~isempty(f.UserData)
        if ~isempty(f.UserData.Cursor)
            % Re-assign axes
            f.UserData.Cursor.axes = ax;
            f.UserData.Cursor.draw();
            return;
        end
    end

    % Create cursor and assign axes
    f.UserData.Cursor = SpectralCursor(f, ax);

end

