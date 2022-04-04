# RNG Expectation Calculation #
expect.func <- function(p) {
  (1-(1-p)**300)/p
}

library(ggplot2)
library(plotly)

r = ggplot(data.frame(x = c(0, .1) ), aes(x = x )) +
  # scale_x_continuous(limits = c(0, 1),breaks = seq(0,1,0.1))+
  theme_minimal() +
  theme(
    axis.text.x = element_text(size = 8, vjust = 1.0),
    axis.text.y = element_text(size = 12, vjust = 1.2),
    plot.title = element_text(size = 18, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 16, hjust = 0.5),
    plot.caption = element_text(size = 10),
    axis.title.x = element_text(size = 14, face = "bold"),
    axis.title.y = element_text(size = 14, face = "bold")
  ) +
  scale_y_continuous(breaks = seq(0, 500, 20)) +
  labs(
    x = "Probability",
    y = "Expected Draws" ,
    title = "保底期望抽數圖",
    subtitle = "某個很香的手遊",
    caption = "source: Custom ; Author: PeterWang"
  ) +
  geom_vline(
    aes(xintercept = 0.007,color = "SSR.Prob"),
    linetype = "dashed",
    size = 1
  ) +
  scale_color_manual(name = " ", values = c(SSR.Prob = "darkred"))+
  annotate("text", label = "p=0.007", x = 0.014, y = 260 , size = 6 , colour = "navyblue")+
  stat_function(fun = expect.func)

ggplotly(r) 



