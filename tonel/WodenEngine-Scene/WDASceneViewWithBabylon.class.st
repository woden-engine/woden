Class {
	#name : #WDASceneViewWithBabylon,
	#superclass : #WDASceneView,
	#instVars : [
		'pompeiiSurface',
		'pompeiiDefaultFont'
	],
	#category : #'WodenEngine-Scene-Application'
}

{ #category : #rendering }
WDASceneViewWithBabylon >> babylonDefaultFont [
	^ pompeiiDefaultFont ifNil: [ pompeiiDefaultFont := engine babylonDriver font: (LogicalFont familyName: 'Arial' pointSize: 20) ]
]

{ #category : #'drawing 2d' }
WDASceneViewWithBabylon >> drawFrameRateOn: canvas [
	| deltaTime builder mesh |
	deltaTime := engine frameBufferingDriver currentFrameCPUDeltaTime.
	
	builder := canvas driver mesh2DBuilder.
	builder text
		color: Color green;
		font: self babylonDefaultFont;
			position: (0 @ self babylonDefaultFont getPreciseAscent);
			draw: ('CPU Frame Rate {1} ms / {2} FPS' format: {
				(deltaTime*1000.0) printShowingDecimalPlaces: 3 .
				1.0 / (deltaTime max: 0.01) printShowingDecimalPlaces: 3.
				engine frameBufferingDriver lastFrameCPUConsumption * 1000.0 printShowingDecimalPlaces: 3});
			newline;
			draw: ('CPU Consumption {1} ms' format: {
				engine frameBufferingDriver lastFrameCPUConsumption * 1000.0 printShowingDecimalPlaces: 3});
			newline;
			draw: ('Rendered object count {1}' format: {engine frameRenderingMetrics renderedObjectCount asString}).
				
	mesh := builder mesh.
	
	canvas draw: mesh.
]

{ #category : #rendering }
WDASceneViewWithBabylon >> drawOnBabylonCanvas: canvas [
	self drawFrameRateOn: canvas
]

{ #category : #rendering }
WDASceneViewWithBabylon >> renderViewport: viewport overlayWith: stateTracker [
	pompeiiSurface := viewport resolveRenderTarget validPompeiiSurface.
	pompeiiSurface withStateTracker: stateTracker drawDuring: [ :canvas |
		viewport applyBabylonCanvasSafeZoneTransform: canvas transform.
		self drawOnBabylonCanvas: canvas.
		sceneRenderer ifNotNil: [ sceneRenderer debugDrawOnBabylonCanvas: canvas ]
	]
]
