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
WDASceneViewWithPompeii >> drawOnPompeiiCanvas: canvas [

]

{ #category : #rendering }
WDASceneViewWithPompeii >> pompeiiDefaultFont [
	^ pompeiiDefaultFont ifNil: [ pompeiiDefaultFont := engine pompeiiDriver font: (LogicalFont familyName: 'Arial' pointSize: 20) ]
]

{ #category : #rendering }
WDASceneViewWithPompeii >> renderViewport: viewport overlayWith: stateTracker [
	pompeiiSurface := viewport resolveRenderTarget validPompeiiSurface.
	pompeiiSurface withStateTracker: stateTracker drawDuring: [ :canvas |
		self drawOnPompeiiCanvas: canvas
	]
]
