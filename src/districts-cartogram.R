


cartogramMap <- function(districts, var, title, low = "gray92", high) {
  districts <- subset(districts, PARTIDO == var)
  ggplot(districts, aes(map_id = id)) + 
    geom_map(aes(fill = per), map=cartogram, color="gray30", size = .1) +
    geom_polygon(data = state_cartogram, aes(long,lat, group=group),
                 color = "black", size = .25, fill = "transparent") +
    expand_limits(x = cartogram$long, y = cartogram$lat) +
    coord_map()+
    theme_bw() +
    ggtitle(title) +
    scale_fill_gradient("percent", low = "gray92", high = high, labels = percent) +
    theme(panel.border=element_blank()) +
    theme(panel.grid=element_blank()) +
    theme(axis.ticks=element_blank()) +
    theme(axis.text=element_blank()) + 
    labs(x=NULL, y=NULL)
  #ggsave(str_c("graphs/", title, ".png"), width = 9, height = 7, dpi = 100)
}

cartogramMap(districts, "PRI", high = "#ec242a", 
             title = "PRI vote equal area cartogram, by state") %>%
  savePlot("PRI-cartograma")
cartogramMap(districts, "PVEM", high = "#2ca25f", 
             title = "PVEM vote equal area cartogram, by state")%>%
  savePlot("PVEM-cartograma")
cartogramMap(districts,  "PAN", high = "#02569b", 
             title = "PAN vote equal area cartogram, by state")%>%
  savePlot("PAN-cartograma")
cartogramMap(districts, "PRD", high = "#fec44f", 
             title = "PRD vote equal area cartogram, by state")%>%
  savePlot("PRD-cartograma")
cartogramMap(districts,  "MORENA", high = "#d95f0e", 
             title = "MORENA vote equal area cartogram, by state")%>%
  savePlot("MORENA-cartograma")
cartogramMap(districts,  "MOVIMIENTO_CIUDADANO", high = "#f58e1e", 
             title = "MC vote equal area cartogram, by state")%>%
  savePlot("MC-cartograma")

cartogramMap(districts, "NUEVA_ALIANZA", high = "#37b4b7", 
             title = "PANAL vote equal area cartogram, by state")%>%
  savePlot("PANAL-cartograma")
cartogramMap(districts,  "PT", high = "#e8122e", 
             title = "PT vote equal area cartogram, by state")%>%
  savePlot("PT-cartograma")
cartogramMap(districts,  "PH", high = "#a7448b", 
             title = "PH vote equal area cartogram, by state")%>%
  savePlot("PH-cartograma")
cartogramMap(districts,  "PS", high = "#643179", 
             title = "Encuentro Social vote equal area cartogram, by state")%>%
  savePlot("ES-cartograma")

