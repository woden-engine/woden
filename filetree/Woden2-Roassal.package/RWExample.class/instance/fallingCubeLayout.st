as yet unclassified
fallingCubeLayout
	" 
	self new fallingCubeLayout
	"
	| v floor |
	v := RWView new.
	1 to: 300 do: [ :i |
		v add: (RWCube element mass: 1.0).
	].

	v camera translateByZ: 6.0.
	RWCubeLayout on: v elements.

	floor := RWCube new width: 10.0; depth: 5.0; height: 0.1; element.
	floor wall;
		translateByY: -10.0.
	v add: floor.

	v addInteraction: RWMouseKeyControl.
	v withPhysics.
	^ v