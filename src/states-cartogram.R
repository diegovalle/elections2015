
savePlot <- function(p, title) {
  ggsave(plot = addSource(p), 
         str_c("graphs/", title, ".png"), width = 8, height = 5, dpi = 100)
}

#Hex Grid Map
mapStates <- function(map, estados, centers, party, low = "gray90", high, title = "") {
  map@data <- left_join(map@data, subset(estados, PARTIDO == party))
  mx_map <- fortify(map, region="state_abbr")
  ggplot() + 
    geom_map(map=mx_map, data = mx_map, color="black", 
             aes(map_id=id, x = long, y = lat)) +
    geom_map(map=mx_map, data = map@data, color="white", 
             aes(map_id = state_abbr, fill = per)) +
    coord_map() +
    geom_text(data = centers, 
              aes(label=id, x=lat, y=long), color="white", size=4.5) +
    scale_fill_gradient("percent", low = low, high = high, labels = percent) +
    theme_bw() +
    ggtitle(title) +
    theme(panel.border=element_blank()) +
    theme(panel.grid=element_blank()) +
    theme(axis.ticks=element_blank()) +
    theme(axis.text=element_blank()) + 
    labs(x=NULL, y=NULL)
  #ggsave(str_c("graphs/", title, ".png"), width = 8, height = 5, dpi = 100)
}


mapStates(map, estados, centers, "PRI_T", high = "#ec242a", 
          title = "PRI votes, by state") %>%
  savePlot("PRI-estados")
mapStates(map, estados, centers, "PVEM_T", high = "#2ca25f", 
          title = "PVEM votes, by state")%>%
  savePlot("PVEM-estados")
mapStates(map, estados, centers, "PAN", high = "#02569b", 
          title = "PAN votes, by state")%>%
  savePlot("PAN-estados")
mapStates(map, estados, centers, "PRD_T", high = "#fec44f", 
          title = "PRD votes, by state")%>%
  savePlot("PRD-estados")
mapStates(map, estados, centers, "MORENA", high = "#d95f0e", 
          title = "MORENA votes, by state")%>%
  savePlot("MORENA-estados")
mapStates(map, estados, centers, "MOVIMIENTO_CIUDADANO", high = "#f58e1e", 
          title = "MC votes, by state")%>%
  savePlot("MC-estados")

mapStates(map, estados, centers, "NUEVA_ALIANZA", high = "#37b4b7", 
          title = "PANAL votes, by state")%>%
  savePlot("PANAL-estados")
mapStates(map, estados, centers, "PT_T", high = "#e8122e", 
          title = "PT votes, by state")%>%
  savePlot("PT-estados")
mapStates(map, estados, centers, "PH", high = "#a7448b", 
          title = "PH votes, by state")%>%
  savePlot("PH-estados")
mapStates(map, estados, centers, "PS", high = "#643179", 
          title = "Encuentro Social votes, by state")%>%
  savePlot("ES-estados")
mapStates(map, estados, centers, "C_PRI_PVEM_T", high = "#ec242a", 
          title = "PRI + PVEM votes, by state")%>%
  savePlot("PRIPVEM-estados")
mapStates(map, estados, centers, "C_PRD_PT_T", high = "#fec44f", 
          title = "PRD + PT votes, by state")%>%
  savePlot("PRDPT-estados")

mapStates(map, estados, centers, "CAND_IND_1", high = "gray30", 
          title = "Independent candidate votes, by state")%>%
  savePlot("INDEP1-estados")

# mapStates(map, estados, centers, "CAND_IND_2", high = "gray30", 
#           title = "Independent candidate 2 votes, by state")%>%
#   savePlot("INDEP2-estados")
#mapStates(map, NULO, high = "#ffffff", title = "Porcentaje de Voto NULO (PREP), por Estado")

#Voto MORENA como porcentaje del voto PRD
MPRD <- estados[,c("per", "PARTIDO", "state_code")] %>%
  filter(PARTIDO %in% c("MORENA", "PRD_T")) %>%
  spread(PARTIDO, per) %>%
  mutate(PARTIDO = "MPRD") 
MPRD$per <- MPRD$MORENA - MPRD$PRD_T
mapStates(map, MPRD, centers, "MPRD", low = "#d8b365", high = "#5ab4ac", 
          title = "MORENA votes - PRD votes") +
  scale_fill_gradient2("percent", high = "#991b06", low = "#f7cf00", midpoint = 0, mid = "#f5f5f5",
                       labels = percent) 
ggsave(str_c("graphs/", "morenavsprd-estados", ".png"), width = 8, height = 5, dpi = 100)

#Voto NULO
NULO <- dip %>%
  group_by(ESTADO) %>%
  summarise(per = sum(as.numeric(NULOS), na.rm = TRUE) /
              sum(as.numeric(TOTAL_VOTOS), na.rm = TRUE)) %>%
  mutate(PARTIDO = "NULOS") %>%
  rename(state_code = ESTADO)
mapStates(map, NULO, centers, "NULOS", low = "gray90", high = "black", 
          title = "Null votes") 
ggsave(str_c("graphs/", "nulo-estados", ".png"), width = 8, height = 5, dpi = 100)





