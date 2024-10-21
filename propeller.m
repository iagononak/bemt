function [prop] = propeller (x)
n = 8;
r = 0.8724;
hub = 0.1524;         % 0.15 hub radius [m]

for i=1:n
    prop.section(i,1) = hub + (i-1)*(r-hub)/(n-1);
    if i < x(3)
        prop.foil_n(i,1) = x(1);
    else
        prop.foil_n(i,1) = x(2);
    end
end
% prop.section = prop.section';
prop.B = 2;


prop.phi = polyval([x(4) x(5) x(6)], prop.section);

prop.pitch = polyval([x(7) x(8)], prop.section)+prop.phi;

prop.chord = polyval([x(9) x(10) x(11)], prop.section);
prop.chord = abs(prop.chord);
for i=1:n-1
    if prop.chord(i)<0.04
        prop.chord(i) = 0.04;
    end
end

prop.chord(n) = 0;

% figure
% plot(prop.section,prop.phi,'-+',prop.section,prop.beta,'-+')
% legend('phi','beta');
% 
% figure
% plot(prop.section,prop.chord,'-+')
%axis([0 0.7 0 0.5])

fprintf('x = [');
fprintf('%.3f ', x);
fprintf(']\n');

fprintf('Inflow angle = [');
fprintf('%.1f ', prop.phi);
fprintf(']\n');

fprintf('Pitch angle = [');
fprintf('%.1f ', prop.pitch);
fprintf(']\n');

fprintf('Sections = [');
fprintf('%.2f ', prop.section);
fprintf(']\n');

fprintf('Chords = [');
fprintf('%.3f ', prop.chord);
fprintf(']\n');

end