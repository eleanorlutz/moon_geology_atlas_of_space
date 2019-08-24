#!/bin/bash
# This script takes an input of Plate Carree DEM TIFF files and
# reprojects each one into a series of different maps. 
# Each TIFF will be reprojected into an Eckert IV projection with default parameters.
# A hillshade and slope map will be constructed for each map.

inh=("A:/ATLAS_OF_SPACE/DEMs/Mars_HRSC_MOLA_BlendDEM_Global_200mp_v2.tif"
	 "A:/ATLAS_OF_SPACE/DEMs/Venus_Magellan_Topography_Global_4641m_v02.tif"
	 "A:/ATLAS_OF_SPACE/DEMs/Lunar_LRO_LOLA_Global_LDEM_118m_Mar2014.tif"
	 )
outh=("A:/ATLAS_OF_SPACE/image_outputs/eckert_iv_dems/mars_"
	  "A:/ATLAS_OF_SPACE/image_outputs/eckert_iv_dems/venus_"
	  "A:/ATLAS_OF_SPACE/image_outputs/eckert_iv_dems/moon_"
	  )

# Downsample rate for each file, depends on quality of original:
down=(2134 3803 1092)

for i in ${!inh[@]}; do
	gdalwarp -t_srs "+proj=eck4" ${inh[i]} ${outh[i]}eck4.tif
	gdalwarp -tr ${down[i]} ${down[i]} -r average ${outh[i]}eck4.tif ${outh[i]}eck4_downsampled.tif
	gdaldem hillshade -z 20 ${outh[i]}eck4_downsampled.tif ${outh[i]}eck4_downsampled_hillshade.tif
	gdaldem slope ${outh[i]}eck4_downsampled.tif ${outh[i]}eck4_downsampled_slope.tif 
done 