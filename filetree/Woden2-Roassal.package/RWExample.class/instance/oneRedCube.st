shapes
oneRedCube
	" 
	self new oneRedCube
	"
	| v |
	v := RWView new.
	v add: RWCube red element.
	v addInteraction: RWMouseKeyControl.
	v open