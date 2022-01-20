clear all;


level = [1,5,10,20,30,50,70,100,150,200,250,300,400,500,600,700,800,925,1000]';
long = 0:2:358;
long = 0:2:360;
lat = -90:2:90;
lat = flipud(lat');
lat=lat(2:end-1);
level_pa = level.*100;
lat_new=lat(2:end-1);
season = "JJA";
x = 0:359; 
y = -89:90;
alpha = 0.05;
percent=20;
%%
figure;

fs = 16;
set(gcf,'units','normalized','position',[0.1500    0.5700    0.34    0.35]);
set(0,'defaulttextfontsize',fs); set(0,'defaultaxesfontsize',fs);
p=500;
%% 
indx =1;
ha = axes;
p=500;
load topo topo topomap1;
fs =16;
p_indx = find(level==p);

%%
s=0;
vt1 = -10000:2000:-2000;
vt2 = 2000:2000:10000;

 
load('long_dependent_meridional_circ_ssp585_and_historical.mat')
%long_dependent_meridional_circ_JJA_ssp585(end+1,:,:) = long_dependent_meridional_circ_JJA_ssp585(end,:,:);
%long_dependent_meridional_circ_JJA_historical(end+1,:,:) = long_dependent_meridional_circ_JJA_historical(end,:,:);

axes(ha(s+1));
map2 = colormap(ha(s+1),flipud(lbmap(10, 'RedBlue')));


diff_circ = long_dependent_meridional_circ_JJA_ssp585 - long_dependent_meridional_circ_JJA_historical;
diff_circ_sign = diff_circ;

contourf(ha(s+1),long, lat,diff_circ_sign(:,:,p_indx)','LevelStep',400,'linestyle', 'none','HandleVisibility','off'); hold on;
colormap(ha(s+1),[map2(1:4, :); ones(2, 3); map2(7:10, :)]);

contour(ha((s+1)),long,lat,long_dependent_meridional_circ_JJA_historical(:,:,p_indx)',[vt1 vt1],'--k','linewidth',0.7,'HandleVisibility','off');hold on;
contour(ha((s+1)),long,lat,long_dependent_meridional_circ_JJA_historical(:,:,p_indx)',[vt2 vt2],'k','linewidth',0.7,'HandleVisibility','off');hold on;
caxis(ha(s+1),[-2000 2000]);
contour(ha(s+1),x,y,topo,[0 0],'Color',[0.5 0.5 0.5],'HandleVisibility','off');ylim([-60 60]);hold on;
yticks(-30:30:30);
xticks(60:120:300);
yticklabels({'30S';'0';'30N'});
xticklabels({'60E';'180';'60W'});hold on; 

h=contourcbar('position',[0.83    0.11    0.03    0.815],'ticks',[-2000 -1200 0 1200 2000],'ticklabels',{'-2'; '-1.2' ;'0' ;'1.2' ;'2'});
text(0.26,1.2,'SSP585-Historical','Units','normalized','FontSize',fs-2);
text(1.07,1.06,'\times10^{3}','Units','normalized','FontSize',fs-3)
title1=['${\rm{kg\,s^{-1}\,m^{-1}}}$'];
ylabel(h,title1,'interpreter','latex','fontsize',14);

hold on;

ha(s+1).Position=[0.08    0.1100    0.72    0.8150]