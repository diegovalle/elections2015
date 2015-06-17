addSource <- function(plot, text = " Cómputos Distritales 2015 sobre la elección de Diputados Federales. Faltan impuganciones por el TRIFE") {
  plot <- arrangeGrob(plot, 
                      sub = textGrob(text,
                                     x = 0, hjust = -0.1, vjust=0.1,
                                     gp = gpar(fontface = "italic", fontsize = 9,
                                               col = "gray30")))
  return(plot)
}
# dip2009 <- read_delim("data/2009-03090433.txt", delim = ";",
#                       col_names = c("CIRCUNSCRIPCION" ,"CLAVE ENTIDAD" ,"ENTIDAD FEDERATIVA" ,"DISTRITO" ,"CABECERA DISTRITAL" ,"SECCIONES" ,"CASILLAS" ,"PAN" ,"PRI" ,"PRD" ,"PVEM" ,"PT" ,"CONVERGENCIA" ,"NUEVA_ALIANZA" ,"PSD" ,"PRIMERO_MEXICO" ,"SALVEMOS_MEXICO" ,"NO_REG" ,"NULOS" ,"TOTAL_VOTOS" ,"LISTA_NOMINAL" ,"OBSERVACIONES", "null"),
#                       skip = 1)
# 
# dip2012 <- read_delim("data/2012-03120434.txt", delim = "|", skip = 0) %>%
#   rename(ENTIDAD = `CLAVE ENTIDAD`) %>%
#   group_by(ENTIDAD, DISTRITO) %>%
#   summarise(per09 = sum(as.numeric(temp), na.rm = TRUE) / 
#               (sum(as.numeric(TOTAL_VOTOS), na.rm = TRUE) -
#                  sum(as.numeric(NULOS), na.rm = TRUE) -
#                  sum(as.numeric(NO_REG), na.rm = TRUE)))%>%
#   mutate(id = str_c(str_pad(ENTIDAD, 2, pad = "0"), 
#                     str_c(str_pad(DISTRITO, 3, pad = "0"))))
# districts <- left_join(districts, districts2009)
# districts$diff <- districts$per - districts$per09


#Download the latest version of the PREP
#temp <- tempfile()
#download.file("http://computos2015.ine.mx/20150611_1043-listaActas.tar.gz",temp)
#untar(temp, "./diputados.csv")
dip = read_delim("data/diputados.csv", delim = "|", skip = 7,
                 col_names = c("ESTADO","DISTRITO","SECCION","ID_CASILLA","TIPO_CASILLA","EXT_CONTIGUA","UBICACION_CASILLA","TIPO_ACTA","NUM_BOLETAS_SOBRANTES","TOTAL_CIUDADANOS_VOTARON","NUM_BOLETAS_EXTRAIDAS","PAN","PRI","PRD","PVEM","PT","MOVIMIENTO_CIUDADANO","NUEVA_ALIANZA","MORENA","PH","PS","C_PRI_PVEM","C_PRD_PT","CAND_IND_1","CAND_IND_2","NO_REGISTRADOS","NULOS","TOTAL_VOTOS","LISTA_NOMINAL","OBSERVACIONES","CONTABILIZADA", "null"))
#unlink(temp)

#download the hex grid map
download("https://gist.githubusercontent.com/diegovalle/7d198d31c53adbbc8597/raw/25e301eaecace2123a4a38c54d9a3dd58318a854/mx_hexgrid.json",
         "map/mx_hexgrid.json")
map <- readOGR("map/mx_hexgrid.json", "OGRGeoJSON")
#state abbreviations and coordinates for naming the states on the map
centers <- coordinates(map)
centers <- cbind(centers, map@data)
names(centers)[1:3] <- c("lat", "long", "id")

zero <- function(x) {
  x <- as.numeric(x)
  x[is.na(x)] <- 0
  x
}

districts <- dip %>%
  filter(TIPO_ACTA != 4) %>%
  gather(PARTIDO, VOTOS, PAN:CAND_IND_2) %>%
  group_by(ESTADO, DISTRITO, PARTIDO) %>%
  summarise(TOTAL_VOTOS = sum(as.numeric(TOTAL_VOTOS), na.rm = TRUE),
    VOTOS = sum(as.numeric(VOTOS), na.rm = TRUE)) %>%
  spread(PARTIDO, VOTOS) %>%
  mutate(PRI_T = ifelse(PRI > PVEM,  PRI + ceiling(zero(C_PRI_PVEM) / 2),
                        PRI + floor(zero(C_PRI_PVEM) / 2))) %>%
  mutate(PVEM_T = ifelse(PVEM > PRI, PVEM + ceiling(zero(C_PRI_PVEM) / 2),
                         PVEM + floor(zero(C_PRI_PVEM) / 2))) %>%
  mutate(PRD_T = ifelse(PRD > PT,  PRD + ceiling(zero(C_PRD_PT) / 2),
                        PRD + floor(zero(C_PRD_PT) / 2))) %>%
  mutate(PT_T = ifelse(PT > PRD, PT + ceiling(zero(C_PRD_PT) / 2),
                       PT + floor(zero(C_PRD_PT) / 2))) %>%
  mutate(C_PRI_PVEM_T = ifelse(C_PRI_PVEM, PRI + PVEM + C_PRI_PVEM, 0)) %>%
  mutate(C_PRD_PT_T = ifelse(C_PRD_PT, PRD + PT + C_PRD_PT, 0)) %>%
  gather(PARTIDO, VOTOS, PAN:C_PRD_PT_T) %>%
  mutate(per = VOTOS / TOTAL_VOTOS) %>%
  mutate(id = str_c(str_pad(ESTADO, 2, pad = "0"), 
                    str_c(str_pad(DISTRITO, 3, pad = "0")))) %>%
  arrange(ESTADO, DISTRITO)
  
  
estados <- districts %>%
  group_by(ESTADO, PARTIDO)  %>%
  summarise(per = sum(as.numeric(VOTOS), na.rm = TRUE) / 
              (sum(as.numeric(TOTAL_VOTOS), na.rm = TRUE)),
            VOTOS = sum(as.numeric(VOTOS), na.rm = TRUE),
            TOTAL_VOTOS = sum(as.numeric(TOTAL_VOTOS), na.rm = TRUE)) %>%
  rename(state_code = ESTADO)

winner <- districts %>%
  group_by(id) %>%
  summarise(max = max(per), winner = PARTIDO[which.max(per)[1]])
unique(winner$winner)




pripvem_ids <- filter(winner, winner %in% c("C_PRI_PVEM_T"))$id
prdpt_ids <- filter(winner, winner %in% c("C_PRD_PT_T"))$id
winner.party <- rbind(filter(districts, id %in% pripvem_ids & PARTIDO %in% c("PRI_T", "PVEM_T")),
      filter(districts, id %in% prdpt_ids & PARTIDO %in% c("PRD_T", "PT_T")),
      filter(districts, !id %in% c(pripvem_ids, prdpt_ids)))%>%
  group_by(id) %>%
  summarise(max = max(per), winner = PARTIDO[which.max(per)[1]])

#map data
cartogram_shp <- readOGR("map/distrito.shp", "distrito")
#create a state map
state_cartogram_shp <- unionSpatialPolygons(cartogram_shp, cartogram_shp@data$ENTIDAD)
cartogram <- fortify(cartogram_shp, region="CLAVEGEO")
state_cartogram <- fortify(state_cartogram_shp, region="ENTIDAD")


