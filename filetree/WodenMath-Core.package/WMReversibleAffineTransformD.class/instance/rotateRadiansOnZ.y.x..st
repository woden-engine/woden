transformation building
rotateRadiansOnZ: z y: y x: x
	<argument: #(x y z) type: #double>
	self applyOrthonormalMatrix: (WMMatrix3D zrot: z) * (WMMatrix3D yrot: y) * (WMMatrix3D xrot: x)