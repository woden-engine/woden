as yet unclassified
manyCubeLayout
	" 
	self new manyCubeLayout
	"
	| v  |
	v := RWView new.
	1 to: 100000 do: [ :i |
		v add: RWCube element.
	].

	v camera position: (WMVector3F x: 0.0 y: 0.0 z: 3.0). 
	RWCubeLayout on: v elements.

	v addInteraction: RWMouseKeyControl.
	v open