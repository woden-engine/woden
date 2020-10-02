Class {
	#name : #WDAViewWithBabylon,
	#superclass : #WDAViewWithStateTracker,
	#instVars : [
		'surface',
		'babylonDefaultFont'
	],
	#category : #'WodenEngine-Babylon-Cyrus'
}

{ #category : #accessing }
WDAViewWithBabylon >> babylonDefaultFont [
	^ babylonDefaultFont ifNil: [ babylonDefaultFont := engine babylonDriver font: (LogicalFont familyName: 'DejaVu Sans' pointSize: 12) ]
]

{ #category : #'rendering process stages' }
WDAViewWithBabylon >> doRenderingWith: stateTracker [
	surface := window validResolveRenderTarget validBabylonSurface.
	surface withStateTracker: stateTracker drawToRenderTarget: window validRenderTarget during: [ :aCanvas |
		self drawOnBabylonCanvas: aCanvas
	]
]

{ #category : #rendering }
WDAViewWithBabylon >> drawOnBabylonCanvas: canvas [
]
