as yet unclassified
threeCubesAndLightWithShadowsAndPhysics
	" 
	self new threeCubesAndLightWithShadowsAndPhysics
	"
	| v floor light|
	v := RWView new.
	v blackBackground.
	v add: (RWCube element mass: 1.0).
	v add: (RWCube element mass: 1.0).
	v add: (RWCube element mass: 1.0).
	RWXLineLayout on: v elements.

	v add: (RWCube element mass: 1.0; translateByY: 2.0; translateByX: 0.7).
		
	floor := RWCube new width: 10.0; depth: 5.0; height: 0.1; element.
	floor wall;
		translateByY: -1.0.
	v add: floor.
	
	light := RWSpotLight new.
	light lookDown;
		color: Color lightGray;
		translateByX: 2.0 y: 3.0 z: 0.0;
		influenceRadius: 10.0;
		castShadows: true.
	v add: light.
	v addInteraction: RWMouseKeyControl.
	v withShadows;
		withPhysics.
	v open