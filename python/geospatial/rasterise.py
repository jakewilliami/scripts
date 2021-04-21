# A script to rasterise a shapefile to the same projection & pixel resolution as a reference image.
from osgeo import ogr, gdal
import subprocess

def main(Image, Shapefile, OutputImage, ExtractorBand):
    Shapefile_layer = Shapefile.GetLayer()
    
    # Rasterise
    print("Rasterising shapefile...")
    Output = gdal.GetDriverByName(gdalformat).Create(OutputImage, Image.RasterXSize, Image.RasterYSize, 1, datatype, options=['COMPRESS=DEFLATE'])
    Output.SetProjection(Image.GetProjectionRef())
    Output.SetGeoTransform(Image.GetGeoTransform()) 
    
    # Write data to band 1
    Band = Output.GetRasterBand(ExtractorBand)
    Band.SetNoDataValue(0)
    gdal.RasterizeLayer(Output, [ExtractorBand], Shapefile_layer, burn_values=[burnVal])
    
    # Close datasets
    Band = None
    Output = None
    Image = None
    Shapefile = None
    
    # Build image overviews
    subprocess.call("gdaladdo --config COMPRESS_OVERVIEW DEFLATE "+OutputImage+" 2 4 8 16 32 64", shell=True)
    print("Done.")


####################################################################################################################

# InputVector = '../data/lds-nz-river-polygons-topo-150k-SHP/nz-river-polygons-topo-150k.shp'
InputVector = '../data/river-health-from-csv/NZRiverMaps_data_water_quality_2021-04-17.shp'
# OutputImage = 'rasterised-river-polygons.tif'
OutputImage = 'rasterised-river-quality-from-csv.tif'

RefImage = 'test.TIF'

ExtractorBand = 1

gdalformat = 'GTiff'
datatype = gdal.GDT_Byte
burnVal = 1 # value for the output image pixels

##########################################################

# Get projection info from reference image
Image = gdal.Open(RefImage, gdal.GA_ReadOnly)

# Open Shapefile
Shapefile = ogr.Open(InputVector)

main(Image, Shapefile, OutputImage, ExtractorBand)

# src_ds.RasterCount
# rasterise every band the input image has
# for i in range(1, number_of_bands_in_shp_file + 1):
# for i in range(1, 2 + 1):
    # main(Image, Shapefile, str(i) + OutputImage, i)
