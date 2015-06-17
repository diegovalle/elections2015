


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

cartogramMap(districts, "PRI_T", high = "#ec242a", 
             title = "PRI votes equal area cartogram, by district") %>%
  savePlot("PRI-cartograma")
cartogramMap(districts, "PVEM_T", high = "#2ca25f", 
             title = "PVEM votes equal area cartogram, by district")%>%
  savePlot("PVEM-cartograma")
cartogramMap(districts,  "PAN", high = "#02569b", 
             title = "PAN votes equal area cartogram, by district")%>%
  savePlot("PAN-cartograma")
cartogramMap(districts, "PRD_T", high = "#fec44f", 
             title = "PRD votes equal area cartogram, by district")%>%
  savePlot("PRD-cartograma")
cartogramMap(districts,  "MORENA", high = "#d95f0e", 
             title = "MORENA votes equal area cartogram, by district")%>%
  savePlot("MORENA-cartograma")
cartogramMap(districts,  "MOVIMIENTO_CIUDADANO", high = "#f58e1e", 
             title = "MC votes equal area cartogram, by district")%>%
  savePlot("MC-cartograma")

cartogramMap(districts, "NUEVA_ALIANZA", high = "#37b4b7", 
             title = "PANAL votes equal area cartogram, by district")%>%
  savePlot("PANAL-cartograma")
cartogramMap(districts,  "PT", high = "#e8122e", 
             title = "PT votes equal area cartogram, by district")%>%
  savePlot("PT-cartograma")
cartogramMap(districts,  "PH", high = "#a7448b", 
             title = "PH votes equal area cartogram, by district")%>%
  savePlot("PH-cartograma")
cartogramMap(districts,  "PS", high = "#643179", 
             title = "Encuentro Social votes equal area cartogram, by district")%>%
  savePlot("ES-cartograma")

cartogramMap(districts,  "C_PRI_PVEM_T", high = "#ec242a", 
             title = "PRI and PVEM votes equal area cartogram, by district")%>%
  savePlot("PRIPVEM-cartograma")

cartogramMap(districts,  "C_PRD_PT_T", high = "#fec44f", 
             title = "PRD and PT votes equal area cartogram, by district")%>%
  savePlot("PRDPT-cartograma")

cartogramMap(districts,  "CAND_IND_1", high = "#4d4d4d", 
             title = "Independent candidate votes equal area cartogram, by district")%>%
  savePlot("INDEP1-cartograma")
