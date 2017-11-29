transformations
rotateByRadians: angle
	matrix := matrix * (WMMatrix3F zrot: angle)