% HK_CH_TRADE FROM UN COMTRADE DATA
% G_lpt from P1_CNH5N1 gravity model calculation
hk_ch_trade = sum(HK_CH_TRADE);
ratio = hk_ch_trade/sum(G_lpt(:,32));
ch_trade = ratio.*G_lpt;
NChina = [1:8,15,16,27,28,30];
SChina = [9:14,17:25,32];
QH = 29;
CA = [26,31];
region = {NChina,SChina,QH,CA};
ch_region_trade = zeros(4);
for i=1:1:4
    for j=1:1:4
        ch_region_trade(i,j) = sum(sum(ch_trade(region{i},region{j})));
    end
end

h_pop=mean(humanPopulation97_14,2);
h_region_pop = zeros(4,1);
for t=1:1:4
    h_region_pop(t)=sum(h_pop(region{t}));
end

p_pop=nanmean(poultryPopulation97_14,2);
p_region_pop = zeros(4,1);
for t=1:1:4
    p_region_pop(t)=sum(p_pop(region{t}));
end