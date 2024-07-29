

#########
# MAP 1 #
#########

' The geodatabase of the Ministry of Education and Higher Education of Quebec (called Donnees_Ouvertes_MEES.gdb) contains
 several vector data layers about educational institutions in Quebec.
'

library(sf)

st_layers("Donnees_Ouvertes_MEES.gdb")
Driver: OpenFileGDB 
Available layers:
                layer_name geometry_type features fields                 crs_name
1                   CS_STA Multi Polygon        3      9 WGS 84 / Pseudo-Mercator
2                   CS_FRA Multi Polygon       60      9 WGS 84 / Pseudo-Mercator
3                   CS_ANG Multi Polygon        9      9 WGS 84 / Pseudo-Mercator
4               CS_STA_GEN Multi Polygon        3      9 WGS 84 / Pseudo-Mercator
5               CS_ANG_GEN Multi Polygon        9      9 WGS 84 / Pseudo-Mercator
6               CS_FRA_GEN Multi Polygon       60      9 WGS 84 / Pseudo-Mercator
7               CS_FRA_SDA Multi Polygon       60      9 WGS 84 / Pseudo-Mercator
8               CS_ANG_SDA Multi Polygon        9      9 WGS 84 / Pseudo-Mercator
9               CS_STA_SDA Multi Polygon        3      9 WGS 84 / Pseudo-Mercator
10  PPS_Public_SSocial_Org         Point     2748     24 WGS 84 / Pseudo-Mercator
11  PPS_Prive_Installation         Point      350     24 WGS 84 / Pseudo-Mercator
12 PPS_Prive_Etablissement         Point      261     15 WGS 84 / Pseudo-Mercator
13      PPS_Gouvernemental         Point       37     22 WGS 84 / Pseudo-Mercator
14   PPS_Public_SSocial_CS         Point       72     16 WGS 84 / Pseudo-Mercator
15        ES_Universitaire         Point       22     17 WGS 84 / Pseudo-Mercator
16        PPS_Public_Ecole         Point     5202     29 WGS 84 / Pseudo-Mercator
17     PPS_Public_Immeuble         Point     4641     22 WGS 84 / Pseudo-Mercator
18            ES_Collegial         Point      311     17 WGS 84 / Pseudo-Mercator

' List of names given to the layers making up the geodatabase.
  Layers whose names begin with CS_ contain vector data relating to school service centers. Since each of these centers
  covers its own territory, they are multipolygons.
  Layers whose names begin with PPS_ and ES_ contain vector data relating to primary, secondary and higher education institutions.
  Since each of these institutions is identified by a pair of coordinates, they are points.
'

# Let's choose public schools, private schools, college-level institutions (e.g. CEGEP) and universities.
# public schools
ecoles_pub <- st_read("Donnees_Ouvertes_MEES.gdb", layer = "PPS_Public_Ecole")

head(ecoles_pub)
Simple feature collection with 6 features and 29 fields
Geometry type: POINT
Dimension:     XY
Bounding box:  xmin: -7665998 ymin: 6156083 xmax: -7590441 ymax: 6205128
Projected CRS: WGS 84 / Pseudo-Mercator
         DT_MAJ_GDUNO COMBINE_NUO_NUI CD_ORGNS                         NOM_COURT_ORGNS                                        NOM_OFFCL_ORGNS
1 2020-06-21 20:00:00          940954   712405                  CFP de Mont-Joli-Mitis Centre de formation professionnelle de Mont-Joli-Mitis
2 2020-06-21 20:00:00          940754   712321                  CFA de Mont-Joli-Mitis     Centre de formation des adultes de Mont-Joli-Mitis
3 2020-06-21 20:00:00          940055   712030                        École des Alizés                                       École des Alizés
4 2020-06-21 20:00:00         9377101   712001    École de l'Écho-des-Montagnes-Lavoie                   École de l'Écho-des-Montagnes-Lavoie
5 2020-06-21 20:00:00         9391102   712015 École de Mont-Saint-Louis-Saint-Rosaire                École de Mont-Saint-Louis-Saint-Rosaire
6 2020-06-21 20:00:00         9390103   712014                       École des Sources                                      École des Sources
   ADRS_GEO_L1_GDUNO_ORGNS ADRS_GEO_L2_GDUNO_ORGNS CD_POSTL_GDUNO_ORGNS CD_MUNCP_GDUNO_ORGNS    NOM_MUNCP_GDUNO_ORGNS CD_IMM
1    1414, rue des Érables                    <NA>               G5H4A8                09077                Mont-Joli 712009
2        1632, rue Lindsay                    <NA>               G5H3A6                09077                Mont-Joli 712009
3  45, avenue de la Grotte                    <NA>               G5H1W4                09077                Mont-Joli 712010
4 10, 8e Avenue Lefrançois                    <NA>               G0L2Z0                10070             Saint-Fabien 712060
5    136, rue de la Grotte                    <NA>               G0L1B0                10043                 Rimouski 712061
6         20, rue Banville                    <NA>               G0K1H0                10030 Saint-Anaclet-de-Lessard 712062
                 NOM_IMM    ADRS_GEO_L1_GDUNO_IMM ADRS_GEO_L2_GDUNO_IMM CD_MUNCP_GDUNO_IMM      NOM_MUNCP_GDUNO_IMM CD_POSTL_GDUNO_IMM PRESC
1 CFA de Mont-Joli-Mitis        1632, rue Lindsay                  <NA>              09077                Mont-Joli             G5H3A6     0
2 CFA de Mont-Joli-Mitis        1632, rue Lindsay                  <NA>              09077                Mont-Joli             G5H3A6     0
3            Alizés, des  45, avenue de la Grotte                  <NA>              09077                Mont-Joli             G5H1W4     1
4 Écho-des-Montagnes, l  10, 8e Avenue Lefrançois                  <NA>              10070             Saint-Fabien             G0L2Z0     1
5       Mont-Saint-Louis    136, rue de la Grotte                  <NA>              10043                 Rimouski             G0L1B0     1
6           Sources, des         20, rue Banville                  <NA>              10030 Saint-Anaclet-de-Lessard             G0K1H0     1
  PRIM SEC FORM_PRO ADULTE                       SITE_WEB_ORGNS COORD_X_LL84_IMM COORD_Y_LL84_IMM                           ORDRE_ENS  CD_CS
1    0   0        1      0      http://www.csphares.qc.ca/cfpmm        -68.18821         48.58440           Formation professionnelle 712000
2    0   0        0      1     http://www.csphares.qc.ca/cfamj/        -68.18821         48.58440               Éducation aux adultes 712000
3    1   0        0      0  http://ecole.csphares.qc.ca/alizes/        -68.18609         48.58733              Préscolaire - Primaire 712000
4    1   1        0      0 http://www.csphares.qc.ca/st-fabien/        -68.86483         48.29506 Préscolaire - Primaire - Secondaire 712000
5    1   1        0      0                                 <NA>        -68.70762         48.37037 Préscolaire - Primaire - Secondaire 712000
6    1   0        0      0                                 <NA>        -68.42263         48.47628              Préscolaire - Primaire 712000
  TYPE_CS                     STYLE_CART                    SHAPE
1  Franco             8_OrgImm_Franco_Fp POINT (-7590676 6204635)
2  Franco            9_OrgImm_Franco_Adu POINT (-7590676 6204635)
3  Franco     4_OrgImm_Franco_presc_prim POINT (-7590441 6205128)
4  Franco 5_OrgImm_Franco_presc_prim_sec POINT (-7665998 6156083)
5  Franco 5_OrgImm_Franco_presc_prim_sec POINT (-7648497 6168694)
6  Franco     4_OrgImm_Franco_presc_prim POINT (-7616772 6186459)

# private schools
ecoles_priv <- st_read("Donnees_Ouvertes_MEES.gdb", layer = "PPS_Prive_Etablissement")

head(ecoles_priv)
Simple feature collection with 6 features and 15 fields
Geometry type: POINT
Dimension:     XY
Bounding box:  xmin: -8259532 ymin: 5691542 xmax: -8174792 ymax: 5784675
Projected CRS: WGS 84 / Pseudo-Mercator
         DT_MAJ_GDUNO CD_ORGNS                          NOM_COURT                          NOM_OFFCL
1 2020-06-21 20:00:00   001500           Académie Antoine Manseau           Académie Antoine Manseau
2 2020-06-21 20:00:00   003500 L'Académie Beth Rivkah pour filles L'Académie Beth Rivkah pour filles
3 2020-06-21 20:00:00   004500      Académie Chrétienne Rive Nord      Académie Chrétienne Rive Nord
4 2020-06-21 20:00:00   017500                 Collège Laurentien                 Collège Laurentien
5 2020-06-21 20:00:00   019500             Académie Louis-Pasteur             Académie Louis-Pasteur
6 2020-06-21 20:00:00   024500              Académie Marie-Claire              Académie Marie-Claire
                        ADRS_GEO_L1_GDUNO ADRS_GEO_L2_GDUNO CD_MUNCP NOM_MUNCP STAT_MUNCP CD_POSTL_GDUNO
1 20, rue St-Charles Borromée S. C.P. 410              <NA>    61025  Joliette          V         J6E3Z9
2                       5001, rue Vézina               <NA>    66023  Montréal          V         H3W1C2
3                         790, 18e Avenue              <NA>    65005     Laval          V         H7R4P3
4                        1200, 14e Avenue              <NA>    78005 Val-Morin          M         J0T2R0
5                7220, rue Marie-Victorin              <NA>    66023  Montréal          V         H1G2J5
6                  18190, boulevard Elkas              <NA>    66102  Kirkland          V         H9J3Y4
                          TYPE_ORGNS RESEAU                     SITE_WEB COORD_X_LL84 COORD_Y_LL84                    SHAPE
1 Établissement d'enseignement privé  Privé           www.amanseau.qc.ca    -73.43540     46.02699 POINT (-8174792 5784675)
2 Établissement d'enseignement privé  Privé                         <NA>    -73.64569     45.49480 POINT (-8198200 5699757)
3 Établissement d'enseignement privé  Privé                         <NA>    -73.85186     45.55879 POINT (-8221151 5709925)
4 Établissement d'enseignement privé  Privé     www.collegelaurentien.ca    -74.19664     46.01475 POINT (-8259532 5782713)
5 Établissement d'enseignement privé  Privé www.academielouispasteur.com    -73.60236     45.61726 POINT (-8193377 5719226)
6 Établissement d'enseignement privé  Privé                 www.amcca.ca    -73.88337     45.44305 POINT (-8224660 5691542)

# CEGEP
college <- st_read("Donnees_Ouvertes_MEES.gdb", layer = "ES_Collegial")

> head(college)
Simple feature collection with 6 features and 17 fields
Geometry type: POINT
Dimension:     XY
Bounding box:  xmin: -8432289 ymin: 5688156 xmax: -7628606 ymax: 6181951
Projected CRS: WGS 84 / Pseudo-Mercator
         DT_MAJ_GDUNO CD_ORGNS                               NOM_COURT
1 2020-06-21 20:00:00   020510    Conservatoire de musique de Rimouski
2 2020-06-21 20:00:00   100501    Conservatoire de musique de Saguenay
3 2020-06-21 20:00:00   190504                        ITA La Pocatière
4 2020-06-21 20:00:00   260504 Conservatoire de musique Trois-Rivières
5 2020-06-21 20:00:00   440512                        ITA St-Hyacinthe
6 2020-06-21 20:00:00   470502    Conservatoire de musique de Gatineau
                                                           NOM_OFFCL            ADRS_GEO_L1_GDUNO ADRS_GEO_L2_GDUNO
1                               Conservatoire de musique de Rimouski         22, rue Sainte-Marie              <NA>
2                               Conservatoire de musique de Saguenay 202, rue Jacques-Cartier Est              <NA>
3    Institut de technologie agroalimentaire, campus de La Pocatière               401, rue Poiré              <NA>
4                         Conservatoire de musique de Trois-Rivières            587, rue Radisson              <NA>
5 Institut de technologie agroalimentaire, campus de Saint-Hyacinthe            3230, rue Sicotte           C.P. 70
6                               Conservatoire de musique de Gatineau   430, boul. Alexandre-Taché              <NA>
  CD_MUNCP       NOM_MUNCP STAT_MUNCP CD_POSTL_GDUNO            TYPE_ORGNS         RESEAU
1    10043        Rimouski          V         G5L4E2 École gouvernementale Gouvernemental
2    94068        Saguenay          V         G7H6R8 École gouvernementale Gouvernemental
3    14085    La Pocatière          V         G0R1Z0 École gouvernementale Gouvernemental
4    37067  Trois-Rivières          V         G9A2C8 École gouvernementale Gouvernemental
5    54048 Saint-Hyacinthe          V         J2S7B3 École gouvernementale Gouvernemental
6    81017        Gatineau          V         J9A1M7 École gouvernementale Gouvernemental
                                            SITE_WEB COORD_X_LL84 COORD_Y_LL84 ORDRE_ENS       STYLE_CART
1 http://www.conservatoire.gouv.qc.ca/rimouski/index    -68.52894     48.44942 Collégial 3_Gouvernemental
2 http://www.conservatoire.gouv.qc.ca/saguenay/index    -71.06132     48.42598 Collégial 3_Gouvernemental
3                              http://www.ita.qc.ca/    -70.03911     47.36484 Collégial 3_Gouvernemental
4 http://www.conservatoire.gouv.qc.ca/reseau/conserv    -72.54645     46.34382 Collégial 3_Gouvernemental
5                               http://www.ita.qc.ca    -72.96775     45.61887 Collégial 3_Gouvernemental
6                http://www.conservatoire.gouv.qc.ca    -75.74854     45.42170 Collégial 3_Gouvernemental
                     SHAPE
1 POINT (-7628606 6181951)
2 POINT (-7910510 6178018)
3 POINT (-7796718 6001830)
4 POINT (-8075834 5835619)
5 POINT (-8122733 5719482)
6 POINT (-8432289 5688156)

# universities
univ <- st_read("Donnees_Ouvertes_MEES.gdb", layer = "ES_Universitaire")

> head(univ)
Simple feature collection with 6 features and 17 fields
Geometry type: POINT
Dimension:     XY
Bounding box:  xmin: -8795234 ymin: 5699713 xmax: -7928407 ymax: 6145323
Projected CRS: WGS 84 / Pseudo-Mercator
         DT_MAJ_GDUNO CD_ORGNS                                NOM_COURT                                      NOM_OFFCL
1 2020-06-21 20:00:00   978006  Université Québec Abitibi-Témiscamingue  Université du Québec en Abitibi-Témiscamingue
2 2020-06-21 20:00:00   978007  École nationale administration publique      École nationale d'administration publique
3 2020-06-21 20:00:00   978008 Inst. national de recherche scientifique Institut national de la recherche scientifique
4 2020-06-21 20:00:00   978010          École de technologie supérieure                École de technologie supérieure
5 2020-06-21 20:00:00   978011                          Télé-université                                Télé-université
6 2020-06-21 20:00:00   978012      Université du Québec (siège social)            Université du Québec (siège social)
               ADRS_GEO_L1_GDUNO ADRS_GEO_L2_GDUNO CD_MUNCP     NOM_MUNCP STAT_MUNCP CD_POSTL_GDUNO   TYPE_ORGNS     RESEAU
1 445, boulevard de l'Université              <NA>    86042 Rouyn-Noranda          V         J9X5E4 Constituante Sans objet
2     555, boulevard Charest Est              <NA>    23027        Québec          V         G1K9E5 Constituante Sans objet
3        490, rue de la Couronne              <NA>    23027        Québec          V         G1K9A9 Constituante Sans objet
4     1100, rue Notre-Dame Ouest              <NA>    66023      Montréal          V         H3C1K3 Constituante Sans objet
5             455, rue du Parvis              <NA>    23027        Québec          V         G1K9H6 Constituante Sans objet
6             475, rue du Parvis              <NA>    23027        Québec          V         G1K9H7 Siège social Sans objet
                      SITE_WEB COORD_X_LL84 COORD_Y_LL84     ORDRE_ENS STYLE_CART                    SHAPE
1          http://www.uqat.ca/    -79.00893     48.23071 Universitaire     1_Univ POINT (-8795234 6145323)
2          http://www.enap.ca/    -71.22246     46.81387 Universitaire     1_Univ POINT (-7928448 5911746)
3          http://www.inrs.ca/    -71.22439     46.81270 Universitaire     1_Univ POINT (-7928663 5911555)
4        http://www.etsmtl.ca/    -73.56260     45.49452 Universitaire     1_Univ POINT (-8188952 5699713)
5 http://www.teluq.uquebec.ca/    -71.22209     46.81340 Universitaire     1_Univ POINT (-7928407 5911669)
6       http://www.uquebec.ca/    -71.22209     46.81340 Universitaire     1_Univ POINT (-7928407 5911669)

' Let us select the institutions located in Montreal from the ecoles_pub, ecoles_priv, college and univ layers. 
  The name of the attribute associated with the municipality where the listed institutions are located is:
  - "NOM_MUNCP_GDUNO_IMM" for ecoles_pub
  - "NOM_MUNCP" for the other institutions
'
ecoles_pub_Mtl  <- ecoles_pub[ecoles_pub$NOM_MUNCP_GDUNO_IMM == "Montréal",]
ecoles_priv_Mtl <- ecoles_priv[ecoles_priv$NOM_MUNCP == "Montréal",]
college_Mtl 	<- college[college$NOM_MUNCP == "Montréal",]
univ_Mtl 		<- univ[univ$NOM_MUNCP == "Montréal",]

# To visualize these 4 shapefiles together in a single map, we first create individual maps.
library(mapview)
map_pub_mtl 	<- mapview(ecoles_pub_Mtl, cex = 2)
map_priv_mtl 	<- mapview(ecoles_priv_Mtl, color = "red", col.regions = "red", cex = 2)
map_college_mtl <- mapview(college_Mtl, color = "green", col.regions = "green", cex = 4)
map_univ_mtl 	<- mapview(univ_Mtl, color = "black", col.regions = "orange", cex = 6)

# We combine all the layers
map_pub_mtl + map_priv_mtl + map_college_mtl + map_univ_mtl



#########
# MAP 2 #
#########

library(sf)

# We use the shapefile of polygon type vector data which contains the land limits of the island of Montreal.
limites_terrestres <- st_read("terre_shp.shp")

# We use the shapefile of line type vector data representing the cycle paths on the island of Montreal.
pistes_cyclables <- st_read("pistes_cyclables_type.shp")

# We use the shapefile of point type vector data representing the positions of bicycles accidents in Montreal.
accidents_velo <- st_read("accidents2018_Mtl_velo.shp")

# We represent the vector data of the 3 shapefiles within the same map.
map_limites_terrestres <- mapview(limites_terrestres, col.regions = "darkgray", legend = NULL)
map_accidents <- mapview(accidents_velo, color = "red", col.regions = "red", cex = 1, legend = NULL)

# We create a palette containing six colors to clearly differentiate the different types of cycle path (because
# there are six possible values ​​for this attribute).
couleurs_voie <- c("black", "goldenrod", "cornflowerblue", "darkcyan", "hotpink", "mediumpurple")
map_pistes_cyclables <- mapview(pistes_cyclables, color=couleurs_voie, layer.name = "Types de pistes cyclables", lwd = 1)

# We combine all the layers
map_limites_terrestres + map_pistes_cyclables + map_accidents



#########
# MAP 3 #
#########

' The data is land cover raster data from a small region of Colorado, United States.
  The rasters Couvert_2001.tif and Couvert_2016.tif correspond to the land covers during the years 2001 and 2016 respectively.
'

library(raster)
library(FedData)

cover2001 <- raster("Couvert_2001.tif")
cover2016 <- raster("Couvert_2016.tif")

# Confirm that the extent, resolution and coordinate system are the same for both files.
extent(cover2001) == extent(cover2016)
[1] TRUE
res(cover2001) == res(cover2016)
[1] TRUE TRUE
st_crs(cover2001) == st_crs(cover2016)
[1] TRUE

# rasters dimensions
dim(cover2001)
[1] 2212 1701    1
dim(cover2016)
[1] 2212 1701    1

# Create two rasters, R2001 and R2016, by selecting a 500 x 500 cell square region inside the two initial land cover rasters.
R2001 <- cover2001[1000:1499, 1200:1699, drop=FALSE]
R2016 <- cover2016[1000:1499, 1200:1699, drop=FALSE]

# determine the class of values ​​included in the R2001 raster
class(getValues(R2001))
[1] "numeric"

# Since the R2001 and R0016 rasters represent land cover, the values ​​should be categorical. Transform the rasters into a factor.
R2001f <- as.factor(R2001)
R2016f <- as.factor(R2016)

# Determine how many different land cover categories exist.
dim(levels(R2001f)[[1]])[1]
[1] 15

# The legend
# To know what type of cover these categories correspond to, let's load the legend available in the FedData library.
legende <- pal_nlcd()

# Determine how many different land covers listed in this legend.
dim(legende)[1]
[1] 20

' We notice that the number of categories in the legend is greater than the number of categories in the R2001f categorical raster.
 Let us create a summary table that takes the legend elements while keeping only the cover types present in the R2001f raster.
'
sommaire <- legende[legende$ID %in% unique(R2001f), -4]
dim(sommaire)[1]
[1] 15

# From the new sommaire data.frame, we create a data.frame called "rat" which allows us to attach these attributes to the R2001f raster.
rat <- levels(R2001f)[[1]]
rat$classe <- sommaire$Class
rat
   ID                       classe
1  11                   Open Water
2  21        Developed, Open Space
3  22     Developed, Low Intensity
4  23  Developed, Medium Intensity
5  24     Developed High Intensity
6  31 Barren Land (Rock/Sand/Clay)
7  41             Deciduous Forest
8  42             Evergreen Forest
9  43                 Mixed Forest
10 52                  Shrub/Scrub
11 71         Grassland/Herbaceous
12 81                  Pasture/Hay
13 82             Cultivated Crops
14 90               Woody Wetlands
15 95 Emergent Herbaceous Wetlands

# We attach the rat attribute table to the R2001f raster.
levels(R2001f) <- rat 
R2001f
class      : RasterLayer 
dimensions : 500, 500, 250000  (nrow, ncol, ncell)
resolution : 30.1, 29.6  (x, y)
extent     : 340531.8, 355581.8, 4470698, 4485498  (xmin, xmax, ymin, ymax)
crs        : +proj=utm +zone=13 +datum=WGS84 +units=m +no_defs 
source     : memory
names      : layer 
values     : 11, 95  (min, max)
attributes :
       ID                       classe
 from: 11                   Open Water
  to : 95 Emergent Herbaceous Wetlands

# Visualize the categorical raster for the year 2001.
mapview(R2001f, col.regions = sommaire$Color, att = "classe", legend = TRUE)



###############
# Animation 4 #
###############

# Animate the longest bike journey and create a GIF file that illustrates this journey.



###############
# Animation 5 #
###############

# Animate profiles that correspond to the temporal evolution of temperatures (maximum and minimum) and average precipitation.
