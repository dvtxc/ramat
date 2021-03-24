function addToSubset(self, subsetHandle)
    %ADDTOSUBSET
    % Adds the current dataset to an existing analysis subset
    
    subsetHandle.append_data(self);
end

