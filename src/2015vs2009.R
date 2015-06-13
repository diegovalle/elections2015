

cartogramDiffMap <- function(dip2009, districts, var, title) {
  districts <- subset(districts, PARTIDO == var)
  dip2009$temp <- dip2009[[var]]
  districts2009 <- dip2009 %>%
    rename(ENTIDAD = `CLAVE ENTIDAD`) %>%
    group_by(ENTIDAD, DISTRITO) %>%
    summarise(per09 = sum(as.numeric(temp), na.rm = TRUE) / 
                (sum(as.numeric(TOTAL_VOTOS), na.rm = TRUE) -
                   sum(as.numeric(NULOS), na.rm = TRUE) -
                   sum(as.numeric(NO_REG), na.rm = TRUE)))%>%
    mutate(id = str_c(str_pad(ENTIDAD, 2, pad = "0"), 
                      str_c(str_pad(DISTRITO, 3, pad = "0"))))
  districts <- left_join(districts, districts2009)
  districts$diff <- districts$per - districts$per09
  ggplot(districts, aes(map_id = id)) + 
    geom_map(aes(fill = diff), map=cartogram, color="gray30", size = .1) +
    geom_polygon(data = state_cartogram, aes(long,lat, group=group),
                 color = "black", size = .25, fill = "transparent") +
    expand_limits(x = cartogram$long, y = cartogram$lat) +
    coord_map()+
    theme_bw() +
    ggtitle(title) +
    #scale_fill_distiller("diferencia\nen % de votos", palette = "RdYlBu", labels = percent) +
    scale_fill_gradient2("difference\nin vote %", low = "#d73027", high = "#4575b4", midpoint = 0, mid = "#ffffbf",
                         labels = percent) +
    theme(panel.border=element_blank()) +
    theme(panel.grid=element_blank()) +
    theme(axis.ticks=element_blank()) +
    theme(axis.text=element_blank()) + 
    labs(x=NULL, y=NULL)
  #ggsave(str_c("graphs/", title, ".png"), width = 9, height = 7, dpi = 100)
}

cartogramDiffMap(dip2009, districts,  "PAN", title = "PAN 2015 vs 2009")%>%
  savePlot("PAN15-09")
cartogramDiffMap(dip2009, districts,  "PVEM", title = "PVEM 2015 vs 2009")%>%
  savePlot("PVEM15-09")
cartogramDiffMap(dip2009, districts,  "PRI", title = "PRI 2015 vs 2009")%>%
  savePlot("PRI15-09")
cartogramDiffMap(dip2009, districts,  "PRD", title = "PRD 2015 vs 2009")%>%
  savePlot("PRD15-09")
