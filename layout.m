

cfg = [];
cfg.baseline     = [-0.2 -0.1];
cfg.baselinetype = 'absolute';
cfg.zlim         = [];
cfg.showlabels   = 'yes';
figure
ft_multiplotTFR(cfg, TFdata);

Channel=load('/media/Work/Data_RhythmProject/Data_Analysis/channel65.xyz');
dat = [];

Nchan          = length(Channel);
dat.elec.pnt   = zeros(Nchan,3);
%dat.elec.label = Channel.Name;

for i = [1:Nchan]
    dat.elec.label{i} = ['E' int2str(Channel(i,4))];
    % this channel has a position
    %             dat.elec.pnt(i,1) = -Channel(i).Loc(2); % X
    %             dat.elec.pnt(i,2) = -Channel(i).Loc(3); % Y
    %             dat.elec.pnt(i,3) = Channel(i).Loc(1); % Z
    
    dat.elec.pnt(i,1) = Channel(i,3); % X
    dat.elec.pnt(i,2) = Channel(i,1); % Y
    dat.elec.pnt(i,3) = Channel(i,2); % Z
    
    
end;

% Code for verification of sensor positions in 3Dfigure
    figure(100)
        sens = dat.elec.pnt;
        plot3(sens(:,1),sens(:,2),sens(:,3),'.')
        hold on
        ChLabels = dat.elec.label;
        text(sens(:,1),sens(:,2),sens(:,3),ChLabels)
        axis equal
        grid on
    %%

cfg = [];
cfg.rotate =-90;
%cfg.elecfile='/home/perrine/Dropbox/Experience/Imagerie/eeglab_modifP/sample_locs/GSNReal65v2_0.sfp'

EGI = ft_prepare_layout(cfg, dat)

% dirlist  = dir('/home/perrine/Dropbox/Experience/Imagerie/eeglab_modifP/sample_locs/*2_0.sfp'); 
% filename = '/media/Work/Data_RhythmProject/Data_Analysis/channel65.xyz'
% for i=1:1%length(filename)
%   elec = ft_read_sens(filename);
%   figure
%   ft_plot_sens(elec);
%   title(filename);
%   grid on
%   rotate3d
% end

cfg = [];
cfg.layout = EGI;
cfg.method = 'triangulation';
cfg.planarmethod = 'sincos';
cfg.feedback      = 'yes'
cfg_neighb.method    = 'distance';

cfg.neighbours       = ft_prepare_neighbours(cfg_neighb, TFdata);


cfg=[];
cfg.layout=EGI;
cfg.parameter ='powspctrm';
cfg.baseline=[-0.3 0];
cfg.markers='labels';
cfg.highlight    =  'labels';
figure(100)
ft_multiplotTFR(cfg, TFdata)

