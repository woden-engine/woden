transformation building
rotateRadiansOnZ: z
	<argument: #z type: #double>
	self applyOrthonormalMatrix: (WMMatrix3D zrot: z)