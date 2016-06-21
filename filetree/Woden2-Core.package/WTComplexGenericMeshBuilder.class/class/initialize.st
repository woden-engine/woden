as yet unclassified
initialize
	"
	self initialize
	"
	super initialize.
	
	"Potential normal axis"
	NormalAxis := { 
		WMVector3F x: 1.0 y: 0.0 z: 0.0 .
		WMVector3F x: -1.0 y: 0.0 z: 0.0 .
		WMVector3F x: 0.0 y: 1.0 z: 0.0 .
		WMVector3F x: 0.0 y: -1.0 z: 0.0 .
		WMVector3F x: 0.0 y: 0.0 z: 1.0 .
		WMVector3F x: 0.0 y: 0.0 z: -1.0 .
	}.