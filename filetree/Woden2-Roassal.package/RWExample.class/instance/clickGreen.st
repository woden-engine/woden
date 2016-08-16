as yet unclassified
clickGreen
	" 
	self new clickGreen
	"
	| v e |
	v := RWView new.

	1 to: 100 do: [ :i |
		e := RWCube element.
		e when: RWMouseButtonDown do: [ :ev |
			ev element shape color: WDColor green.
			ev element changed.
		].
		v add: e.
	].
	RWXZGridLayout on: v elements.
	v addInteraction: RWMouseKeyControl.
	v camera position: (WDVector3 x: 0.0 y: 0.0 z: 3.0).
	v open.
