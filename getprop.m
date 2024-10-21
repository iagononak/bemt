function [geo] = getprop (filename)

[~,txt,~] = xlsread(filename);
[NRows,~] = size(txt);

section_aux = sprintf('A3:A%d',NRows);
pitch_aux = sprintf('B3:B%d',NRows);
chord_aux = sprintf('C3:C%d',NRows);
inflowangle_aux = sprintf('D3:D%d',NRows);
%foil_aux = sprintf('E3:E%d',NRows);


geo.section = xlsread(filename, section_aux);     % section [m]
geo.pitch = xlsread (filename, pitch_aux);      % pitch
geo.chord = xlsread (filename, chord_aux);      % chord [m]
geo.phi = xlsread (filename, inflowangle_aux);      % inflow angle
%geo.thtoch = xlsread (Filename, 'B3:B14');     % thickness [m] 
geo.foil = txt(3:NRows, 5);       % aerofoil name

end