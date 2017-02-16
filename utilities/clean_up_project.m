function clean_up_project()
%clean_up_project   Clean up local customizations of the environment
% 
%   the settings applied in "set_up_project". It is set to Run at Shutdown.

%   Copyright 2011-2014 The MathWorks, Inc.

% Reset the location where generated code and other temporary files are
% created (slprj) to the default:
Simulink.fileGenControl('reset');

end
