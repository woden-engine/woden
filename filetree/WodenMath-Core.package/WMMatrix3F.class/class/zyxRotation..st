special matrices
zyxRotation: angles
	<argument: #angles type: #(WMVector3F object)>
	<returnType: #(SelfType object)>
	^ (self zrot: angles z) * (self yrot: angles y) * (self xrot: angles x)