
#topojson -o final.json -e topo.csv --id-property=+CLAVEGEO -p PRI=+PRI_T,+PAN,PRD=+PRD_T,+MORENA,PVEM=+PVEM_T,+MOVIMIENTO_CIUDADANO,+NUEVA_ALIANZA,+PS,PRIPVEM=+C_PRI_PVEM_T,PRDPT=+C_PRD_PT_T,INDEP=CAND_IND_1,NOMDISTRITO,color -- distritos.json
head(districts)
names <- read_csv("data/distrito-names.csv")
names$NOMDISTRITO <- str_c(names$NOMDISTRITO, " - ", names$DISTRITO)
topo <- districts[,c("ESTADO", "DISTRITO", "PARTIDO", "per", "id")] %>%
  mutate(per = round(per, 3)) %>%
  spread(PARTIDO, per) %>%
  left_join(winner) %>%
  rename(CLAVEGEO = id) %>%
  left_join(names)
topo$color <- plyr::revalue(topo$winner, c("PRI" = "#ec242a", "PAN" = "#02569b", "PRD" = "#ffff00",
                                           "MORENA" = "#610200", "PVEM" = "#2ca25f", "MOVIMIENTO_CIUDADANO" = "#f58e1e",
                                           "NUEVA_ALIANZA" = "#37b4b7",
                                           "C_PRI_PVEM_T" = "#bd0026",
                                           "C_PRD_PT_T" = "#d5b60a",
                                           "CAND_IND_1" = "#4d4d4d")) 
write.csv(topo, "map/topo.csv", row.names = FALSE)

which.max(topo$C_PRI_PVEM_T)
max(districts$per)
