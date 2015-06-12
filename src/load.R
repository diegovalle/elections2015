
dip2009 <- read_delim("data/03090433.txt", delim = ";",
                      col_names = c("CIRCUNSCRIPCION" ,"CLAVE ENTIDAD" ,"ENTIDAD FEDERATIVA" ,"DISTRITO" ,"CABECERA DISTRITAL" ,"SECCIONES" ,"CASILLAS" ,"PAN" ,"PRI" ,"PRD" ,"PVEM" ,"PT" ,"CONVERGENCIA" ,"NUEVA_ALIANZA" ,"PSD" ,"PRIMERO_MEXICO" ,"SALVEMOS_MEXICO" ,"NO_REG" ,"NULOS" ,"TOTAL_VOTOS" ,"LISTA_NOMINAL" ,"OBSERVACIONES", "null"),
                      skip = 1)


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

#sum(as.numeric(dip$TOTAL_VOTOS), na.rm = TRUE) - sum(as.numeric(dip$NO_REGISTRADOS), na.rm = TRUE)- sum(as.numeric(dip$NULOS), na.rm = TRUE)
#sum(as.numeric(dip$NULOS), na.rm = TRUE)- sum(as.numeric(dip$NO_REGISTRADOS), na.rm = TRUE)
#sum(as.numeric(dip$PAN), na.rm = TRUE)


estados <- dip %>%
  gather(PARTIDO, VOTOS, PAN:C_PRD_PT) %>%
  group_by(ESTADO, PARTIDO) %>%
  summarise(per = sum(as.numeric(VOTOS), na.rm = TRUE) / 
              (sum(as.numeric(TOTAL_VOTOS), na.rm = TRUE))) %>%
  rename(state_code = ESTADO)

districts <- dip %>%
  gather(PARTIDO, VOTOS, PAN:C_PRD_PT) %>%
  group_by(ESTADO, DISTRITO, PARTIDO) %>%
  summarise(per = sum(as.numeric(VOTOS), na.rm = TRUE) / 
              sum(as.numeric(TOTAL_VOTOS), na.rm = TRUE)) %>%
  mutate(id = str_c(str_pad(ESTADO, 2, pad = "0"), 
                    str_c(str_pad(DISTRITO, 3, pad = "0"))))

winner <- districts %>%
  group_by(ESTADO, DISTRITO, id) %>%
  summarise(max = max(per), winner = PARTIDO[which.max(per)[1]])


#map data
cartogram <- readOGR("map/distrito.shp", "distrito")
#create a state map
state_cartogram <- unionSpatialPolygons(cartogram, cartogram@data$ENTIDAD)
cartogram <- fortify(cartogram, region="CLAVEGEO")
state_cartogram <- fortify(state_cartogram, region="ENTIDAD")


