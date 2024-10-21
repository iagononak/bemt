function [UpperReUpperM, LowerReUpperM, UpperReLowerM, LowerReLowerM, dist] = SearchPolars (Re, Mach, foil)
foil = string(foil);

step_Re = 5e4;
Step_Mach = 0.05;

Re_aux = 5e4:step_Re:5e6;
Mach_aux = 0:Step_Mach:0.5;

path_directory = 'polars';
original_files=dir([path_directory '/*.mat']);
foilnames = struct2cell(original_files)';
foilnames = foilnames(:,1);

if Mach < max(Mach_aux) && Re < max(Re_aux)

% Definir os valores maiores e menores de Reynolds e Mach
Previous_Re = interp1(Re_aux, Re_aux, Re, 'previous');
Next_Re = interp1(Re_aux, Re_aux, Re, 'next');
Previous_Mach = interp1(Mach_aux, Mach_aux, Mach, 'previous');
Next_Mach = interp1(Mach_aux, Mach_aux, Mach, 'next');

% Definir a distância do Reynolds e do Mach real com os da database
dist = [(Re-Previous_Re)/step_Re, (Mach-Previous_Mach)/Step_Mach];

% Definir a parte final Foil + Reynolds + Mach
UpReUpM = sprintf('%s_%d_%.2f',foil,Next_Re,Next_Mach);
LoReUpM = sprintf('%s_%d_%.2f',foil,Previous_Re,Next_Mach);
UpReLoM = sprintf('%s_%d_%.2f',foil,Next_Re,Previous_Mach);
LoReLoM = sprintf('%s_%d_%.2f',foil,Previous_Re,Previous_Mach);


% Definir o indíce para pegar o código
Index_UpReUpM = find(contains(foilnames,UpReUpM));
Index_LoReUpM = find(contains(foilnames,LoReUpM));
Index_UpReLoM = find(contains(foilnames,UpReLoM));
Index_LoReLoM = find(contains(foilnames,LoReLoM));

% Pegar o código pelo indíce da database
UpReUpM = original_files(Index_UpReUpM).name;
LoReUpM = original_files(Index_LoReUpM).name;
UpReLoM = original_files(Index_UpReLoM).name;
LoReLoM = original_files(Index_LoReLoM).name;

% Definir o nome do arquivo da database
UpperReUpperM = sprintf("polars/%s",UpReUpM);
LowerReUpperM = sprintf("polars/%s",LoReUpM);
UpperReLowerM = sprintf("polars/%s",UpReLoM);
LowerReLowerM = sprintf("polars/%s",LoReLoM);

% Carregar o arquivo da database
UpperReUpperM = load(UpperReUpperM);
LowerReUpperM = load(LowerReUpperM);
UpperReLowerM = load(UpperReLowerM);
LowerReLowerM = load(LowerReLowerM);

else

Previous_Re = interp1(Re_aux, Re_aux, Re, 'previous');
Next_Re = interp1(Re_aux, Re_aux, Re, 'next');

% Definir a parte final Foil + Reynolds + Mach
UpReUpM = sprintf('%s_%d_%.2f',foil,Next_Re,max(Mach_aux));
LoReUpM = sprintf('%s_%d_%.2f',foil,Previous_Re,max(Mach_aux));

dist = [(Re-Previous_Re)/step_Re, 0];

% Definir o indíce para pegar o código
Index_UpReUpM = find(contains(foilnames,UpReUpM));
Index_LoReUpM = find(contains(foilnames,LoReUpM));

% Pegar o código pelo indíce da database
UpReUpM = original_files(Index_UpReUpM).name;
LoReUpM = original_files(Index_LoReUpM).name;

% Definir o nome do arquivo da database
UpperReUpperM = sprintf("polars/%s",UpReUpM);
LowerReUpperM = sprintf("polars/%s",LoReUpM);

% Carregar o arquivo da database
UpperReUpperM = load(UpperReUpperM);
LowerReUpperM = load(LowerReUpperM);
UpperReLowerM = UpperReUpperM;
LowerReLowerM = LowerReUpperM;
end


end