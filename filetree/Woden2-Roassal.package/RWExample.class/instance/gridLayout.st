layout
gridLayout
	" 
	self new gridLayout
	"
	| v  |
	v := RWView new.
	1 to: 1000 do: [ :i |
		v add: RWCube element.
	].

	v camera position: (WMVector3F x: 0.0 y: 0.0 z: 3.0). 
	RWXZGridLayout on: v elements.

	v addInteraction: RWMouseKeyControl.
	v open