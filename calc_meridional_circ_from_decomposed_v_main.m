clear all;

%%

    season = "JJA";


model = "mean";

load(strjoin(['ua_interp_hist_',model,'_',season],''));
load(strjoin(['va_interp_hist_',model,'_',season],''));
eval(strjoin(['u_mean = flip(ua_interp_',season,',2);'],''));
eval(strjoin(['v_mean = flip(va_interp_',season,',2);'],''));

eval(strjoin(['long_dependent_meridional_circ_',season, '= decompose_velocity_and_calc_circulation(u_mean,v_mean);'],''));


