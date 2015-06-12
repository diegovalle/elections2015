
ggplot(winner, aes(map_id = id)) + 
  geom_map(aes(fill = winner), map=cartogram, color="gray30", size = .1) +
  geom_polygon(data = state_cartogram, aes(long,lat, group=group),
               color = "black", size = .25, fill = "transparent") +
  expand_limits(x = cartogram$long, y = cartogram$lat) +
  coord_map()+
  theme_bw() +
  scale_fill_manual("party", values = c("PRI" = "#ec242a", "PAN" = "#02569b", "PRD" = "#ffcb01",
                                        "MORENA" = "#610200", "PVEM" = "#2ca25f", "MOVIMIENTO_CIUDADANO" = "#f58e1e",
                                        "NUEVA_ALIANZA" = "#37b4b7"), 
                    breaks = c("PRI", "PAN", "PRD", 
                               "MORENA", "PVEM", "MOVIMIENTO_CIUDADANO", 
                               "NUEVA_ALIANZA"),
                    labels = c("PRI", "PAN", "PRD", 
                               "MORENA", "PVEM", "MC", 
                               "PANAL")) +
  ggtitle("Winning party, by district") +
  theme(panel.border=element_blank()) +
  theme(panel.grid=element_blank()) +
  theme(axis.ticks=element_blank()) +
  theme(axis.text=element_blank()) + 
  labs(x=NULL, y=NULL)
ggsave(str_c("graphs/", "winner", ".png"), width = 9, height = 7, dpi = 100)
