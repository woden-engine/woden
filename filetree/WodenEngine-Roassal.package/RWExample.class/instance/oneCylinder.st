shapes
oneCylinder
	" 
	self new oneCylinder
	"
	| v |
	v := RWView new.
	v add: RWCylinder element.
	v  @ RWMouseKeyControl.
	v open