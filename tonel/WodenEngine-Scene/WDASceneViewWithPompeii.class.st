Class {
	#name : #WDASceneViewWithPompeii,
	#superclass : #WDASceneView,
	#instVars : [
		'pompeiiSurface'
	],
	#category : #'WodenEngine-Scene-Application'
}

{ #category : #rendering }
WDASceneViewWithPompeii >> renderViewport: viewport overlayWith: stateTracker [
	| builder mesh |
	pompeiiSurface := viewport resolveRenderTarget validPompeiiSurface.

	builder := PompeiiMesh2DBuilder new.
	builder fill
		gradientStart: 0@0 color: Color cyan end: 0@128 color: Color blue;
		rectangle: (0@0 extent: 128@128) round: 15.
	builder stroke
		color: (Color black alpha: 0.5);
		width: 3;
		rectangle: (0@0 extent: 128@128) round: 15.
	mesh := builder mesh.
	
	pompeiiSurface withStateTracker: stateTracker drawDuring: [ :canvas |
		canvas transform restoreAfter: [
			canvas transform translateX: 30 y: 50.
			canvas draw: mesh
		].
			
		"canvas transform restoreAfter: [
			canvas transform translateX: 200 y: 50.
			canvas draw: mesh
		]"
	]
]
