function subsetHandle = addToNewSubset(self)
    %ADDTONEWSUBSET
    
    % Get Project
    projectParent = self(1).ProjectParent;
    
    % Add to new analysis subset
    subsetHandle = projectParent.add_analysis(self);
end

