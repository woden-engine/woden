shapes
oneUVSphere
	" 
	self new oneUVSphere
	"
	| v |
	v := RWView new.
	v add: RWUVSphere element.
	v  @ RWMouseKeyControl.
	v open