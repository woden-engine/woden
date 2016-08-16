sources
exampleCone

	| v |
	v := RWView new.
	v add: RWCone element.
	v camera position: (WDVector3 newX: 0.0 y: 0.0 z: 3.0). 
	v  @ RWMouseKeyControl.

	^ v