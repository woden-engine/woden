special matrices
zyxRotation: angles
	<argument: #angles type: #(WMVector3D object)>
	<returnType: #(SelfType object)>
	^ (self zrot: angles z) * (self yrot: angles y) * (self xrot: angles x)