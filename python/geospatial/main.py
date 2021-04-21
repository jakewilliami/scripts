### Math utils
import numpy as np


### Path utils
from pathlib import Path
import os 


### Image utils
# import tifffile
import rasterio
from rasterio import features
# import shapefile
# from osgeo import gdal, ogr, gdalconst
# from skimage import io
# from skimage.external import tifffile as tif

### Data utils
import pandas as pd
import geopandas as gpd

#############################################

## Path definitions
file_dir = Path(os.path.dirname(os.path.realpath(__file__)))
parent_dir = file_dir.parent.absolute()
data_dir = Path(os.path.join(parent_dir, "data"))
df_water_quality_file = os.path.join(data_dir, "NZRiverMaps_data", "NZRiverMaps_data_water_quality_2021-04-17.csv")
test_tiff = os.path.join(data_dir, "03_Healthy_local_waterways", "3A_Pansharpen_8band", "013930604250_01", "013930604250_01_P001_PSH", "20FEB24223135-S3DS_R2C1-013930604250_01_P001.TIF")
test_shape = os.path.join(data_dir, "lds-nz-river-polygons-topo-150k-SHP", "nz-river-polygons-topo-150k.shp")

#############################################

### main

'''
Constructions a n-tuple of numpy arrays, each array denoting one band/channel of the input file.
'''
def tiff_to_np_array(tiff_file):
    raster = rasterio.open(tiff_file)
    return tuple(raster.read(i) for i in range(1, raster.count))

# tiff_to_np_array(test_tiff)

## Load dataframe
# df_water_quality = pd.read_csv(df_water_quality_file)

## Load shape file
# sf = shapefile.Reader(test_shape)

def shp2tiff(shape_file, tiff_file, out_file):
    river_polygons = gpd.read_file(shape_file)
    rst = rasterio.open(tiff_file)
    meta = rst.meta.copy()
    meta.update(compress='lzw')
    
    with rasterio.open(out_file, 'w+', **meta) as out:
        out_arr = out.read(1)
        
        # this is where we create a generator of geom, value pairs to use in rasterizing
        shapes = ((geom,value) for geom, value in zip(river_polygons.geometry, river_polygons.t50_fid))
        shapes = river_polygons
        
        burned = features.rasterize(shapes=shapes, fill=0, out=out_arr, transform=out.transform)
        out.write_band(1, burned)

# shp2tiff(test_shape, test_tiff, "rasterised.tif")
