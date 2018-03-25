"
I represent a rendering viewport.
"
Class {
	#name : #WTSViewport,
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
		'cameraTransform'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : 'WodenEngine-Scene-Graph'
}

{ #category : #accessing }
WTSViewport >> bounds [
	^ bounds
]

{ #category : #accessing }
WTSViewport >> bounds: anObject [
	bounds := anObject
]

{ #category : #accessing }
WTSViewport >> camera [
	^ camera
]

{ #category : #accessing }
WTSViewport >> camera: anObject [
	camera := anObject
]

{ #category : #accessing }
WTSViewport >> cameraState [
	^ cameraState
]

{ #category : #accessing }
WTSViewport >> cameraState: anObject [
	cameraState := anObject
]

{ #category : #accessing }
WTSViewport >> cameraTransform [
	^ cameraTransform ifNil: [ cameraTransform := cameraTransformFunction value: camera renderTransform ]
]

{ #category : #accessing }
WTSViewport >> cameraTransformFunction [
	^ cameraTransformFunction
]

{ #category : #accessing }
WTSViewport >> cameraTransformFunction: anObject [
	cameraTransformFunction := anObject
]

{ #category : #accessing }
WTSViewport >> filter [
	^ filter
]

{ #category : #accessing }
WTSViewport >> filter: anObject [
	filter := anObject
]

{ #category : #initialization }
WTSViewport >> initialize [
	super initialize.
	filter := [ :object | true ].
	cameraTransformFunction := [ :x | x ]
]

{ #category : #accessing }
WTSViewport >> renderTarget [
	^ renderTarget
]

{ #category : #accessing }
WTSViewport >> renderTarget: anObject [
	renderTarget := anObject
]

{ #category : #accessing }
WTSViewport >> resolveRenderTarget [
	^ resolveRenderTarget
]

{ #category : #accessing }
WTSViewport >> resolveRenderTarget: anObject [
	resolveRenderTarget := anObject
]

{ #category : #accessing }
WTSViewport >> submode [
	^ submode
]

{ #category : #accessing }
WTSViewport >> submode: anObject [
	submode := anObject
]
