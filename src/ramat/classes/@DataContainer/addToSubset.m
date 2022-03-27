function addToSubset(self, subsetHandle, new_group_name)
    %ADDTOSUBSET
    % Adds the current dataset to an existing analysis subset

    arguments
        self;
        subsetHandle Analysis;
        new_group_name string = "";
    end

    if (new_group_name == "")
        new_group_name = self(1).Group.Name;
    end
    
    subsetHandle.append_data(self, new_group_name);
end

