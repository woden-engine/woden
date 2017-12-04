class initialization
initialize
	"
	self initialize.
	"
	super initialize.
	
	VectorDirections := { 
		WMVector3D x: 1.0 y: 0.0 z: 0.0 .
		WMVector3D x: -1.0 y: 0.0 z: 0.0 .
		WMVector3D x: 0.0 y: 1.0 z: 0.0 .
		WMVector3D x: 0.0 y: -1.0 z: 0.0 .
		WMVector3D x: 0.0 y: 0.0 z: 1.0 .
		WMVector3D x: 0.0 y: 0.0 z: -1.0 .
	 }.
	
	UDirections := { 
		WMVector3D x: 0.0 y: 0.0 z: 1.0 .
		WMVector3D x: 0.0 y: 0.0 z: 1.0 .
		WMVector3D x: 1.0 y: 0.0 z: 0.0 .
		WMVector3D x: 1.0 y: 0.0 z: 0.0 .
		WMVector3D x: 1.0 y: 0.0 z: 0.0 .
		WMVector3D x: 1.0 y: 0.0 z: 0.0 .
	}.
	
	VDirections := (1 to: 6) collect: [ :i | (VectorDirections at: i) cross: (UDirections at: i)] 