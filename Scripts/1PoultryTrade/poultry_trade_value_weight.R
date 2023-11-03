library(ggplot2)

poultry_trade_data <- read.delim(file='poultry_trade_data.txt')

poultry_trade_nonzero <- poultry_trade_data %>%
  filter(Netweight..kg.!=0)

ggplot(data=poultry_trade_nonzero,aes(Trade.Value..US..,Netweight..kg.)) +
  geom_point(size=0.6)+
  geom_smooth(method='lm') +
  theme_bw() +
  labs(x='Trade value ($)',y='Net weight (kg)')
lm_fit <- lm(Netweight..kg. ~ Trade.Value..US.., data=poultry_trade_data)
summary(lm_fit)


