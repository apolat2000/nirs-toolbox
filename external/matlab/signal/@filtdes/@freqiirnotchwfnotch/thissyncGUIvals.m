function thissyncGUIvals(h, d, fr)
%THISSYNCGUIVALS

%   Author(s): J. Schickler
%   Copyright 1988-2003 The MathWorks, Inc.

set(d, 'Fnotch', evaluatevars(get(fr, 'Fnotch')));

% [EOF]