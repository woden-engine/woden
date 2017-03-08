sources
exampleCone

	| v |
	v := RWView new.
	v add: RWCone element.
	v camera position: (WMVector3F x: 0.0 y: 0.0 z: 3.0). 
	v  @ RWMouseKeyControl.

	^ v