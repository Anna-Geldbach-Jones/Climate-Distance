library(terra)

setwd("/Volumes/Kew Back Up 2/Cluster_Code")

# Stitch the GEE export tiles together (works for one file or several)
vrt(list.files("crop/export", pattern = "\\.tif$", full.names = TRUE),
    filename = "cropland_03_19.vrt", overwrite = TRUE)
crop_all <- rast("cropland_03_19.vrt")
names(crop_all) <- c("Cropland_03", "Cropland_19", "Crop_Expansion", "Crop_Loss", "Crop_Constant")

# Pad the rows north of 70N and south of 60S with 0 to match the cluster output grid
output_rast <- rast("ALL_OUTPUT.tif")
crop_all <- extend(crop_all, output_rast, fill = 0)

# Confirm the grids line up exactly (errors if they don't)
compareGeom(crop_all, output_rast)

# Sanity check: values should be 0 and 1 only
freq(crop_all$Cropland_03)

plot(crop_all)

# Save all five crop layers as one file
writeRaster(crop_all, "crop_output.tif", datatype = "INT1U", overwrite = TRUE)