### ML/AI/Geodata utils
# from pyrsgis import raster
# import torch
import numpy as np
import matplotlib.pyplot as plt
# from torch.utils.data import Dataset, DataLoader
# from torchvision import transforms, utils
import fiona
import rioxarray
from rioxarray import merge
import rasterio
import rasterstats
from rasterio import Affine # or from affine import Affine
from rasterio.mask import mask
from rasterio.plot import show, reshape_as_image
from rasterio.features import rasterize
from shapely.geometry import mapping, Point, Polygon
from shapely.ops import cascaded_union
import cv2
# import shapefile # pyshp
# for evaluating the model
# from torch.autograd import Variable
# from torch.nn import Linear, ReLU, CrossEntropyLoss, Sequential, Conv2d, MaxPool2d, Module, Softmax, BatchNorm2d, Dropout
# from torch.optim import Adam, SGD

### Path utils
from pathlib import Path
import os
import glob

### Data utils
import pandas as pd
import geopandas as gpd

##########################################################################################

import sys, math

def nztm2latlong(X, Y):
    a = 6378137
    f = 1 / 298.257222101
    phizero = 0
    lambdazero = 173
    Nzero = 10000000
    Ezero = 1600000
    kzero = 0.9996
    N, E  = Y, X
    b = a * (1 - f)
    esq = 2 * f - pow(f, 2)
    Z0 = 1 - esq / 4 - 3 * pow(esq, 2) / 64 - 5 * pow(esq, 3) / 256
    A2 = 0.375 * (esq + pow(esq, 2) / 4 + 15 * pow(esq, 3) / 128)
    A4 = 15 * (pow(esq, 2) + 3 * pow(esq, 2) / 4) / 256
    A6 = 35 * pow(esq, 3) / 3072
    Nprime = N - Nzero
    mprime = Nprime / kzero
    smn = (a - b) / (a + b)
    G = a * (1 - smn) * (1 - pow(smn, 2)) * (1 + 9 * pow(smn, 2) / 4 + 225 * pow(smn, 4) / 64) * math.pi / 180.0
    sigma = mprime * math.pi / (180 * G)
    phiprime = sigma + (3 * smn / 2 - 27 * pow(smn, 3) / 32) * math.sin(2 * sigma) + (21 * pow(smn, 2) / 16 - 55 * pow(smn, 4) / 32) * math.sin(4 * sigma) + (151 * pow(smn, 3) / 96) * math.sin(6 * sigma) + (1097 * pow(smn, 4) / 512) * math.sin(8 * sigma)
    rhoprime = a * (1 - esq) / pow(pow((1 - esq * math.sin(phiprime)), 2), 1.5)
    upsilonprime = a / math.sqrt(1 - esq * pow(math.sin(phiprime), 2))
    psiprime = upsilonprime / rhoprime
    tprime = math.tan(phiprime)
    Eprime = E - Ezero
    chi = Eprime / (kzero * upsilonprime)
    term_1 = tprime * Eprime * chi / (kzero * rhoprime * 2)
    term_2 = term_1 * pow(chi, 2) / 12 * (-4 * pow(psiprime, 2) + 9 * psiprime * (1 - pow(tprime, 2)) + 12 * pow(tprime, 2))
    term_3 = tprime * Eprime * pow(chi, 5) / (kzero * rhoprime * 720) * (8 * pow(psiprime, 4) * (11 - 24 * pow(tprime, 2)) - 12 * pow(psiprime, 3) * (21 - 71 * pow(tprime, 2)) + 15 * pow(psiprime, 2) * (15 - 98 * pow(tprime, 2) + 15 * pow(tprime, 4)) + 180 * psiprime * (5 * pow(tprime, 2) - 3 * pow(tprime, 4)) + 360 * pow(tprime, 4))
    term_4 = tprime * Eprime * pow(chi, 7) / (kzero * rhoprime * 40320) * (1385 + 3633 * pow(tprime, 2) + 4095 * pow(tprime, 4) + 1575 * pow(tprime, 6))
    term1 = chi * (1 / math.cos(phiprime))
    term2 = pow(chi, 3) * (1 / math.cos(phiprime)) / 6 * (psiprime + 2 * pow(tprime, 2))
    term3 = pow(chi, 5) * (1 / math.cos(phiprime)) / 120 * (-4 * pow(psiprime, 3) * (1 - 6 * pow(tprime, 2)) + pow(psiprime, 2) * (9 - 68 * pow(tprime, 2)) + 72 * psiprime * pow(tprime, 2) + 24 * pow(tprime, 4))
    term4 = pow(chi, 7) * (1 / math.cos(phiprime)) / 5040 * (61 + 662 * pow(tprime, 2) + 1320 * pow(tprime, 4) + 720 * pow(tprime, 6))
    latitude = (phiprime - term_1 + term_2 - term_3 + term_4) * 180 / math.pi
    longitude = lambdazero + 180 / math.pi * (term1 - term2 + term3 - term4)
    return (latitude,  longitude)

## Path definitions
file_dir = Path(os.path.dirname(os.path.realpath(__file__)))
parent_dir = file_dir.parent.absolute()
data_dir = Path(os.path.join(parent_dir, "data"))
df_water_quality_file = os.path.join(data_dir, "NZRiverMaps_data", "NZRiverMaps_data_water_quality_2021-04-17.csv")
test_tiff = os.path.join(data_dir, "03_Healthy_local_waterways", "3A_Pansharpen_8band", "013930604250_01", "013930604250_01_P001_PSH", "20FEB24223135-S3DS_R2C1-013930604250_01_P001.TIF")
rivers_poly_filename = os.path.join(data_dir, "lds-nz-river-polygons-topo-150k-SHP", "nz-river-polygons-topo-150k.shp")
rivers_line_filename = os.path.join(data_dir, "lds-nz-river-centrelines-topo-150k-SHP", "nz-river-centrelines-topo-150k.shp")

test_dir = os.path.join(data_dir, "03_Healthy_local_waterways", "3A_Pansharpen_8band", "013930604250_01", "013930604250_01_P001_PSH")
train_dir = os.path.join(data_dir, "03_Healthy_local_waterways", "3A_Pansharpen_8band", "013930604250_01", "013930604250_01_P002_PSH")

all_images = glob.glob(os.path.join(test_dir, "*.TIF")) + glob.glob(os.path.join(train_dir, "*.TIF"))

## Merge data together
def merge_tiffs(all_image_files):
    # all_image_files = glob.glob(os.path.join(dir_path, "*.TIF"))
    elements = []
    
    for im in all_image_files:
        elements.append(rioxarray.open_rasterio(im))
    
    return merge.merge_arrays(elements, nodata=0.0)

all = merge_tiffs(all_images)

# print(all_test)
all.rio.to_raster("out.TIF")

## Load dataframe
df_water_quality = pd.read_csv(df_water_quality_file)
column_of_latlong_tuples = [nztm2latlong(a, b) for (a, b) in zip(df_water_quality["NZTM_Easting"], df_water_quality["NZTM_Northing"])]
df_water_quality['lat'] = [t[0] for t in column_of_latlong_tuples]
df_water_quality['long'] = [t[1] for t in column_of_latlong_tuples]

print(df_water_quality.columns)

## load tiff as raster array
tiff_arr = rioxarray.open_rasterio(test_tiff)

# load datafile as shapefile
points_shape = gpd.GeoDataFrame(df_water_quality, geometry = gpd.points_from_xy(df_water_quality.NZTM_Easting, df_water_quality.NZTM_Northing), crs = tiff_arr.rio.crs)
# tiff_arr = None

# load river shapefiles
# rivers_poly = shapefile.Reader(rivers_poly_filename)
rivers_poly = gpd.read_file(rivers_poly_filename)
# rivers_line = shapefile.Reader(rivers_line_filename)
rivers_line = gpd.read_file(rivers_line_filename)


print(points_shape)
print(rivers_poly)
print(rivers_line)




# def extract_shp_from_tiff(vector, raster_file):
#     # extract the geometry in GeoJSON format
#     geoms = vector.geometry.values # list of shapely geometries
#     geometry = geoms[0] # shapely geometry
#     # transform to GeJSON format
#     geoms = [mapping(geoms[0])]
#     # extract the raster values values within the polygon
#     with rasterio.open(raster_file) as src:
#          out_image, out_transform = mask(src, geoms, crop=True)
#     return out_image
#     # no data values of the original raster
#     # no_data=src.nodata
#     # extract the values of the masked array
#     # data = out_image.data[0]
#     # extract the row, columns of the valid values
#     # row, col = np.where(data != no_data)
    # # elev = np.extract(data != no_data, data)
    # # T1 = out_transform * Affine.translation(0.5, 0.5) # reference the pixel centre
    # rc2xy = lambda r, c: (c, r) * T1
    

# Normalised difference water index
# NDWI = (XGreen - XNIR) / (XGreen + XNIR)
# NDVI = (NIR - Red) / (NIR + RED)
# def NDWI(raster_file):
    # with rasterio.open as src:
# with rasterio.open(url+redband) as src:
    # profile = src.profile
    # oviews = src.overviews(1) # list of overviews from biggest to smallest
    # oview = oviews[1]  # Use second-highest resolution overview
    # print('Decimation factor= {}'.format(oview))
    # red = src.read(1, out_shape=(1, int(src.height // oview), int(src.width // oview)))
    
# for _, geom in rivers_poly.geometry.apply(mapping).iteritems():
    # clipped = tiff_arr.rio.clip([geom], rivers_poly.crs)
    # cropped.rio.to_raster("out.TIF")



# with Raster(raster, affine, nodata, band_num) as rast:
    # features_iter = read_features(vectors, layer)
    # for i, feat in enumerate(features_iter):
        # geom = shape(feat['geometry'])

        # if 'Point' in geom.type:
            # geom = boxify_points(geom, rast)

        # geom_bounds = tuple(geom.bounds)

        # fsrc = rast.read(bounds=geom_bounds)

        # create ndarray of rasterized geometry
        # rv_array = rasterize_geom(geom, like=fsrc, all_touched=all_touched)




# with fiona.open(rivers_poly_filename) as fds:
    # for row in fds:
        # clipped = tiff_arr.rio.clip([row["geometry"]], fds.crs_wkt)
        # clipped.rio.to_raster("out.TIF")

# with rasterio.open(test_tiff, "r") as src:
#     raster_img = src.read()
#     raster_meta = src.meta
#
# train_df = gpd.read_file(rivers_poly_filename)
#
# print("CRS Raster: {}, CRS Vector {}".format(train_df.crs, src.crs))
#
# def poly_from_utm(polygon, transform):
#     poly_pts = []
#
#     poly = cascaded_union(polygon)
#     for i in np.array(poly.exterior.coords):
#
#         # Convert polygons to the image CRS
#         poly_pts.append(~transform * tuple(i))
#
#     # Generate a polygon object
#     new_poly = Polygon(poly_pts)
#     return new_poly
#
#
# # Generate Binary maks
#
# poly_shp = []
# im_size = (src.meta['height'], src.meta['width'])
# for num, row in train_df.iterrows():
#     if row['geometry'].geom_type == 'Polygon':
#         poly = poly_from_utm(row['geometry'], src.meta['transform'])
#         poly_shp.append(poly)
#     else:
#         for p in row['geometry']:
#             poly = poly_from_utm(p, src.meta['transform'])
#             poly_shp.append(poly)
#
# mask = rasterize(shapes=poly_shp,
#                  out_shape=im_size)
#
# # Plot the mask
#
# plt.figure(figsize=(15,15))
# plt.imshow(mask)
#
# mask = mask.astype("uint8")
# save_path = "train.tif"
# bin_mask_meta = src.meta.copy()
# bin_mask_meta.update({'count': 1})
# with rasterio.open(save_path, 'w', **bin_mask_meta) as dst:
#     dst.write(mask * 255, 1)
#
#
#
# def generate_mask(raster_path, shape_path, output_path, file_name):
#
#     """Function that generates a binary mask from a vector file (shp or geojson)
#
#     raster_path = path to the .tif;
#
#     shape_path = path to the shapefile or GeoJson.
#
#     output_path = Path to save the binary mask.
#
#     file_name = Name of the file.
#
#     """
#
#     #load raster
#
#     with rasterio.open(raster_path, "r") as src:
#         raster_img = src.read()
#         raster_meta = src.meta
#
#     #load o shapefile ou GeoJson
#     train_df = gpd.read_file(shape_path)
#
#     #Verify crs
#     if train_df.crs != src.crs:
#         print(" Raster crs : {}, Vector crs : {}.\n Convert vector and raster to the same CRS.".format(src.crs,train_df.crs))
#
#
#     #Function that generates the mask
#     def poly_from_utm(polygon, transform):
#         poly_pts = []
#
#         poly = cascaded_union(polygon)
#         for i in np.array(poly.exterior.coords):
#
#             poly_pts.append(~transform * tuple(i))
#
#         new_poly = Polygon(poly_pts)
#         return new_poly
#
#
#     poly_shp = []
#     im_size = (src.meta['height'], src.meta['width'])
#     for num, row in train_df.iterrows():
#         if row['geometry'].geom_type == 'Polygon':
#             poly = poly_from_utm(row['geometry'], src.meta['transform'])
#             poly_shp.append(poly)
#         else:
#             for p in row['geometry']:
#                 poly = poly_from_utm(p, src.meta['transform'])
#                 poly_shp.append(poly)
#
#     mask = rasterize(shapes=poly_shp,
#                      out_shape=im_size)
#
#     #Salve
#     mask = mask.astype("uint8")
#
#     bin_mask_meta = src.meta.copy()
#     bin_mask_meta.update({'count': 1})
#     os.chdir(output_path)
#     with rasterio.open(file_name, 'w', **bin_mask_meta) as dst:
#         dst.write(mask * 255, 1)
#
#
# generate_mask(test_tiff, rivers_poly_filename, "./", "out.tif")







# with fiona.open(rivers_poly_filename, "r") as shapefile:
#     shapes = [feature["geometry"] for feature in shapefile]
#
# with rasterio.open(test_tiff) as src:
#     out_image, out_transform = rasterio.mask.mask(src, shapes, crop=True)
#     out_meta = src.meta
#
#
# out_meta.update({"driver": "GTiff",
#                  "height": out_image.shape[1],
#                  "width": out_image.shape[2],
#                  "transform": out_transform})
#
# with rasterio.open("RGB.byte.masked.tif", "w", **out_meta) as dest:
#     dest.write(out_image)




# print(rasterstats.zonal_stats(rivers_poly_filename, test_tiff, stats="count", raster_out=True)[0].keys())


# cropped.rio.to_raster("out.TIF")

# out_image = extract_shp_from_tiff(rivers_poly, test_tiff)
# print(out_image)

# write shape to file
# points_shape.to_file(driver = 'ESRI Shapefile', filename = os.path.join("datapoints", "data.shp"))
