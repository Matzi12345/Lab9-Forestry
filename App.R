library(terra)
library(tmap)
library(sf)


dem <- rast("~/Downloads/Lab Material/unit2.img")



slope <- terrain(dem, v = "slope", unit = "degrees", neighbors = 8)


aspect <- terrain(dem, v = "aspect", unit = "degrees")


tmap_mode("view")

tm_shape(slope, alpha = 0.5) +
  tm_raster(style = "cont", alpha = 0.6, title = "Slope (deg)")

tm_shape(aspect) +
  tm_raster(style = "cont")


asp_class <- matrix(c(
  0, 45, 1,
  45, 135, 2,
  135, 225, 3,
  225, 315, 4,
  315, 360, 1
), ncol = 3, byrow = TRUE)

asp <- classify(aspect, asp_class)


tmap_mode("view")
tm_shape(asp) +
  tm_raster(style = "cat", palette = c("white", "blue", "green", "yellow"),
            labels = c("North", "East", "South", "West"), alpha = 0.2)


sum_u2 <- read.csv("~/Downloads/sum_u2.csv")
svy_pts <- st_read("~/Downloads/Lab Material/HEE_Overstory_Survey_Points_2017 - Copy.shp")
svy_pts <- st_transform(svy_pts, 32616) # Project to WGS 84 UTM 16 N
survey_pts <- subset(svy_pts, Unit == '2') # Subset for unit 2


sum_u2 <- merge.data.frame(sum_u2, survey_pts, all.x = TRUE)
unique(sum_u2$Plot)
unique(survey_pts$Plot)


sum_u2 <- st_as_sf(sum_u2, coords = c("X", "Y"), crs = 32616)


sf_plot <- st_buffer(sum_u2, dist = 17.83)


crs(sf_plot)
crs(asp)


asp_crs <- crs(asp)
sf_plot_crs <- st_transform(sf_plot, crs = asp_crs)


tmap_mode("view")
tm_shape(asp, alpha = 0.5) +
  tm_raster(style = "cat", palette = c("white", "blue", "green", "yellow"),
            showNA = FALSE, alpha = 0.2, labels = c("North", "East", "South", "West")) +
  tm_shape(sf_plot_crs) +
  tm_polygons('Common.name') +
  tm_layout(legend.outside = TRUE, legend.outside.size = 0.2) +
  tm_text("Plot", ymod = -0.9)


tmap_mode("view")
tm_shape(slope, alpha = 0.5) +
  tm_raster(style = "cont", alpha = 0.6, title = "Slope (deg)") +
  tm_shape(sf_plot_crs) +
  tm_polygons('Common.name', title = "Dom_Species", alpha = 0.6) +
  tm_layout(title = "Dominant trees by slope",
            legend.outside = TRUE, legend.outside.size = 0.2) +
  tm_text("Plot", ymod = -0.9, size = 1.2)


tmap_mode("view")
tm_shape(sf_plot_crs) +
  tm_polygons('BA', title = "Basal Area (sq_ft/acre)", palette = "brewer.spectral") +
  tm_layout(title = "Basal Area Distribution",
            legend.outside = TRUE, legend.outside.size = 0.2) +
  tm_text("Plot", ymod = -1.5, size = 1.2) +
  tm_scale_bar()


tmap_mode("view")
tm_shape(sf_plot_crs) +
  tm_polygons('TPA', title = "Trees Per Acre", palette = "brewer.spectral") +
  tm_layout(title = "TPA Distribution",
            legend.outside = TRUE, legend.outside.size = 0.2) +
  tm_text("Plot", ymod = -1.5, size = 1.2) +
  tm_scale_bar()


tmap_mode("view")
tm_shape(sf_plot_crs) +
  tm_polygons('bm_pa', title = "Biomass (tons/ac)", palette = "brewer.spectral") +
  tm_layout(title = "Biomass Distribution",
            legend.outside = TRUE, legend.outside.size = 0.2) +
  tm_text("Plot", ymod = -1.5, size = 1.2) +
  tm_scale_bar()



