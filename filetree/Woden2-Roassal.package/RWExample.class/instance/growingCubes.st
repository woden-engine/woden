as yet unclassified
growingCubes
	" 
	self new growingCubes
	"
	| v shape es |
	v := RWView new.
	shape := RWCube new size: #yourself.
	es := shape elementsOn: (1 to: 3 by: 0.5).
	v addAll: es.
	v addInteraction: RWMouseKeyControl.
	v camera position: (WDVector3 newX: 5.0 y: 0.0 z: 10.0). 
	RWXLineLayout on: es.
	v open