plotWinner <- function(winner, cartogram, state_cartogram, values, breaks, labels, legend, 
                       title) {
  ggplot(winner, aes(map_id = id)) + 
    geom_map(aes(fill = winner), map=cartogram, color="gray30", size = .1) +
    geom_polygon(data = state_cartogram, aes(long,lat, group=group),
                 color = "black", size = .25, fill = "transparent") +
    expand_limits(x = cartogram$long, y = cartogram$lat) +
    coord_map()+
    theme_bw() +
    scale_fill_manual(legend, values = values, 
                      breaks = breaks,
                      labels = labels) +
    ggtitle(title) +
    theme(panel.border=element_blank()) +
    theme(panel.grid=element_blank()) +
    theme(axis.ticks=element_blank()) +
    theme(axis.text=element_blank()) + 
    labs(x=NULL, y=NULL)
}
p <- plotWinner(winner, cartogram, state_cartogram,
           values = c("PRI" = "#ec242a", "PAN" = "#02569b", "PRD" = "#ffff00",
                      "MORENA" = "#610200", "PVEM" = "#2ca25f", "MOVIMIENTO_CIUDADANO" = "#f58e1e",
                      "NUEVA_ALIANZA" = "#37b4b7",
                      "C_PRI_PVEM_T" = "#bd0026",
                      "C_PRD_PT_T" = "#d5b60a",
                      "CAND_IND_1" = "gray50"), 
           breaks = c("PRI", "PAN", "PRD", 
                      "MORENA", "PVEM", "MOVIMIENTO_CIUDADANO", 
                      "NUEVA_ALIANZA", "C_PRI_PVEM_T", "C_PRD_PT_T", "CAND_IND_1"),
           labels = c("PRI", "PAN", "PRD", 
                      "MORENA", "PVEM", "MC", 
                      "PANAL", "PRI+PVEM", "PRD+PT", "INDEP"),
           legend = "party or coalition",
           title = "Winning party or coalition, by district")
ggsave(plot = addSource(p), str_c("graphs/", "winner", ".png"), width = 12, height = 9, dpi = 100)

p <- plotWinner(winner.party, cartogram, state_cartogram,
           values = c("PRI_T" = "#ec242a", "PRI" = "#ec242a", "PAN" = "#02569b", "PRD_T" = "#ffcb01",
                      "PRD" = "#ffcb01",
                      "MORENA" = "#610200", "PVEM_T" = "#2ca25f", "PVEM" = "#2ca25f",
                      "MOVIMIENTO_CIUDADANO" = "#f58e1e",
                      "NUEVA_ALIANZA" = "#37b4b7",
                      "C_PRI_PVEM_T" = "#bd0026",
                      "C_PRD_PT_T" = "#d5b60a",
                      "CAND_IND_1" = "gray50"), 
           breaks = c("PRI_T", "PAN", "PRD_T", 
                      "MORENA", "PVEM_T", "MOVIMIENTO_CIUDADANO", 
                      "NUEVA_ALIANZA", "C_PRI_PVEM_T", "C_PRD_PT_T", "CAND_IND_1"),
           labels = c("PRI", "PAN", "PRD", 
                      "MORENA", "PVEM", "MC", 
                      "PANAL", "PRI+PVEM", "PRD+PT", "INDEP"),
           legend = "party",
           title = "Winning party, by district")
ggsave(plot = addSource(p), str_c("graphs/", "winner-party", ".png"), width = 12, height = 9, dpi = 100)
