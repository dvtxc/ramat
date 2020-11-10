classdef Dummy
    %DUMMY Summary of this class goes here
    %   Detailed explanation goes here
    %   Testing things
    
    properties
        Property1;
        Name;
        prop3;
    end

    properties (Access = private)
        Data;
    end
    
    methods
        function obj = Dummy(inputArg1,inputArg2,arg3)
            %DUMMY Construct an instance of this class
            %   Detailed explanation goes here
            
            obj.Property1 = inputArg1 + inputArg2;
            %obj.Data = SpecData('f',[34 4],[2 4]);
            
            if isempty(arg3)
                obj.Name = 'gf';
            end
            
            if nargin == 2
                obj.prop3 = 'nothing passed to me';
            elseif nargin == 3
                obj.prop3 = arg3;
            end
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
        
%         function out = table(obj)
%             for i = 1:numel(obj)
%                 out(i) = obj(i).Property1;
%             end
%             
%             out = table(out(:));
%         end
        function t = table(self)
            %TABLE Output data formatted as table
            %   This method overrides table() and replaces the need for
            %   struct2table()
            
            t = struct2table(struct(self));
            
        end
        
        function s = struct(self)
            %STRUCT Output data formatted as structure
            %   This method overrides struct()
            
            publicProperties = properties(self);
            s = struct();
            for i = 1:numel(self)
                for j = 1:numel(publicProperties)
                    s(i).(publicProperties{j}) = self(i).(publicProperties{j}); 
                end 
            end
            
        end
        
        
    end
    
    methods (Hidden)
        function checkProps(obj)
            keyboard
        end
    end
end

