"
I represent a rendering viewport.
"
Class {
	#name : #WDSGViewport,
	#superclass : #Object,
	#instVars : [
		'camera',
		'cameraState',
		'bounds',
		'submode',
		'filter',
		'renderTarget',
		'resolveRenderTarget',
		'cameraTransformFunction',
		'cameraTransform',
		'overlayRenderer',
		'editorViewType',
		'babylonCanvasSafeZoneTransform',
		'sampleCount',
		'globalFrustumConvexHull'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Scene-Graph'
}

{ #category : #accessing }
WDSGViewport >> bounds [
	^ bounds
]

{ #category : #accessing }
WDSGViewport >> bounds: anObject [
	bounds := anObject
]

{ #category : #accessing }
WDSGViewport >> camera [
	^ camera
]

{ #category : #accessing }
WDSGViewport >> camera: anObject [
	camera := anObject
]

{ #category : #accessing }
WDSGViewport >> cameraState [
	^ cameraState
]

{ #category : #accessing }
WDSGViewport >> cameraState: anObject [
	cameraState := anObject
]

{ #category : #accessing }
WDSGViewport >> cameraTransform [
	^ cameraTransform ifNil: [ cameraTransform := cameraTransformFunction value: camera globalTransform ]
]

{ #category : #accessing }
WDSGViewport >> cameraTransformFunction [
	^ cameraTransformFunction
]

{ #category : #accessing }
WDSGViewport >> cameraTransformFunction: anObject [
	cameraTransformFunction := anObject
]

{ #category : #accessing }
WDSGViewport >> editorViewType [
	^ editorViewType
]

{ #category : #accessing }
WDSGViewport >> editorViewType: anObject [
	editorViewType := anObject
]

{ #category : #accessing }
WDSGViewport >> extent [
	^ bounds extent
]

{ #category : #accessing }
WDSGViewport >> filter [
	^ filter
]

{ #category : #accessing }
WDSGViewport >> filter: anObject [
	filter := anObject
]

{ #category : #'as yet unclassified' }
WDSGViewport >> globalFrustumConvexHull [
	^ globalFrustumConvexHull ifNil: [ 
		globalFrustumConvexHull := camera frustumConvexHullTransformedWith: self cameraTransform.
	]
]

{ #category : #initialization }
WDSGViewport >> initialize [
	super initialize.
	filter := [ :object | true ].
	cameraTransformFunction := [ :x | x ]
]

{ #category : #accessing }
WDSGViewport >> overlayRenderer [
	^ overlayRenderer
]

{ #category : #accessing }
WDSGViewport >> overlayRenderer: anObject [
	overlayRenderer := anObject
]

{ #category : #accessing }
WDSGViewport >> renderTarget [
	^ renderTarget
]

{ #category : #accessing }
WDSGViewport >> renderTarget: anObject [
	renderTarget := anObject
]

{ #category : #accessing }
WDSGViewport >> resolveRenderTarget [
	^ resolveRenderTarget
]

{ #category : #accessing }
WDSGViewport >> resolveRenderTarget: anObject [
	resolveRenderTarget := anObject
]

{ #category : #accessing }
WDSGViewport >> sampleCount [
	^ sampleCount ifNil: [sampleCount := renderTarget ifNil: [1] ifNotNil: #sampleCount]
]

{ #category : #accessing }
WDSGViewport >> sampleCount: aSampleCount [
	^ sampleCount := aSampleCount
]

{ #category : #accessing }
WDSGViewport >> submode [
	^ submode
]

{ #category : #accessing }
WDSGViewport >> submode: anObject [
	submode := anObject
]
