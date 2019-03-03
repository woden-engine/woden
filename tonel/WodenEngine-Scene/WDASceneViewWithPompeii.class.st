Class {
	#name : #WDASceneViewWithPompeii,
	#superclass : #WDASceneView,
	#instVars : [
		'pompeiiSurface',
		'pompeiiDefaultFont'
	],
	#category : #'WodenEngine-Scene-Application'
}

{ #category : #rendering }
WDASceneViewWithPompeii >> babylonDefaultFont [
	^ pompeiiDefaultFont ifNil: [ pompeiiDefaultFont := engine babylonDriver font: (LogicalFont familyName: 'Arial' pointSize: 20) ]
]

{ #category : #rendering }
WDASceneViewWithPompeii >> drawOnBabylonCanvas: canvas [

]

{ #category : #rendering }
WDASceneViewWithPompeii >> renderViewport: viewport overlayWith: stateTracker [
	pompeiiSurface := viewport resolveRenderTarget validPompeiiSurface.
	pompeiiSurface withStateTracker: stateTracker drawDuring: [ :canvas |
		viewport applyBabylonCanvasSafeZoneTransform: canvas transform.
		self drawOnBabylonCanvas: canvas.
		sceneRenderer ifNotNil: [ sceneRenderer debugDrawOnBabylonCanvas: canvas ]
	]
]
