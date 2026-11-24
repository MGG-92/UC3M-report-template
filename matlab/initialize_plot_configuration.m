function initialize_plot_configuration()
% set the size of the ticks on the axes
set(groot , 'defaultLegendFontSize' , 12);
% set the default size of the text
set(groot , 'defaultTextFontSize' , 12);
% set the default axes font size.
set(groot , 'defaultAxesFontSize' , 12);

% set the width of the axes
set(groot , 'defaultAxesLineWidth' , 1);
%activate the minor ticks of the axes
set(groot , 'defaultAxesXMinorTick', 'on' );
set(groot , 'defaultAxesYMinorTick' , 'on' );
%deactivate the legend by default
set(groot , 'defaultLegendBox' , 'on' );
%define the default line width in the plots
set(groot , 'defaultLineLineWidth' , 1.3);
%define the default line marker size
%set(groot , 'defaultLineMarkerSize' , 4);%  
% set the font of the axes ticks to Latex
set(groot , 'defaultAxesTickLabelInterpreter' , 'latex' );
% define the font for the default text for the rest of
% objects (labels , titles , legend , etc ...)
set(groot , 'defaultTextInterpreter' , 'latex' );
set(groot , 'defaultLegendInterpreter' , 'latex' );
