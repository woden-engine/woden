special matrices
xyzRotation: angles
	<argument: #angles type: #(WMVector3D object)>
	<returnType: #(SelfType object)>
	^ (self xrot: angles x) * (self yrot: angles y) * (self zrot: angles z)