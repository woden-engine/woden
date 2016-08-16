shapes
threeCubes
	" 
	self new threeCubes
	"
	| v |
	v := RWView new.
	v add: (RWCube element).
	v add: (RWCube element).
	v add: (RWCube element).
	RWXLineLayout on: v elements.
	v addInteraction: RWMouseKeyControl.
	v open