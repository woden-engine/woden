as yet unclassified
mediumCubeLayout
	" 
	self new mediumCubeLayout
	"
	| v  |
	v := RWView new.
	1 to: 9261 do: [ :i |
		v add: RWCube element.
	].

	v camera position: (WDVector3 newX: 0.0 y: 0.0 z: 3.0). 
	RWCubeLayout on: v elements.

	v addInteraction: RWMouseKeyControl.
	v open