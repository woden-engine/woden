as yet unclassified
fallingLineLayout
	" 
	self new fallingLineLayout
	"
	| v floor |
	v := RWView new.
	1 to: 1000 do: [ :i |
		v add: (RWCube element mass: 1.0).
	].

	v camera translateByZ: 3.0. 
	RWYLineLayout on: v elements.

	floor := RWCube new width: 10.0; depth: 5.0; height: 0.1; element.
	floor wall;
		translateByY: -10.0.
	v add: floor.

	v addInteraction: RWMouseKeyControl.
	v withPhysics.
	v open