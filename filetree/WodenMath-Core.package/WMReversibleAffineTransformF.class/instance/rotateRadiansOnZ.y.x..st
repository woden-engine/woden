transformation building
rotateRadiansOnZ: z y: y x: x
	<argument: #(x y z) type: #float>
	self applyOrthonormalMatrix: (WMMatrix3F zrot: z) * (WMMatrix3F yrot: y) * (WMMatrix3F xrot: x)