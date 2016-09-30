classdef webserver
    properties
        url;
    end
    methods
        function handle = webserver(url)
           handle.url = url;
        end
        
        function put(obj, key, value)
           try
           result = urlread([obj.url '/put?key=' key '&value=' value]);
           catch
               warning('Couldn''t access remote server, value not stored!');
           end
        end
        function value = get(obj, key)
            try
            value = urlread([obj.url '/get?key=' key]);
            catch
                warning('Couldn''t access remote server, value not stored!');
            end
        end
    end
end