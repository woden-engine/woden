"
I represent a camera in the woden scene graph.
"
Class {
	#name : #WTSCamera,
	#superclass : #WTSNode,
	#instVars : [
		'nearDistance',
		'farDistance',
		'fieldOfView',
		'focalDistance',
		'isPerspective',
		'frustum'
	],
	#category : 'WodenEngine-Scene-Graph'
}

{ #category : #accessing }
WTSCamera >> farDistance [
	^ farDistance
]

{ #category : #accessing }
WTSCamera >> farDistance: anObject [
	farDistance := anObject
]

{ #category : #accessing }
WTSCamera >> fieldOfView [
	^ fieldOfView
]

{ #category : #accessing }
WTSCamera >> fieldOfView: anObject [
	fieldOfView := anObject
]

{ #category : #accessing }
WTSCamera >> focalDistance [
	^ focalDistance
]

{ #category : #accessing }
WTSCamera >> focalDistance: anObject [
	focalDistance := anObject
]

{ #category : #accessing }
WTSCamera >> frustum [
	^ frustum
]

{ #category : #accessing }
WTSCamera >> frustum: anObject [
	frustum := anObject
]

{ #category : #initialization }
WTSCamera >> initialize [
	super initialize.
	nearDistance := 0.01.
	farDistance := 1000.0.
	fieldOfView := 60.0.
	focalDistance := 10.
	isPerspective := true.
	frustum := WMFrustumF new.
	
]

{ #category : #testing }
WTSCamera >> isCamera [
	^ true
]

{ #category : #accessing }
WTSCamera >> isPerspective [
	^ isPerspective
]

{ #category : #accessing }
WTSCamera >> isPerspective: anObject [
	isPerspective := anObject
]

{ #category : #accessing }
WTSCamera >> nearDistance [
	^ nearDistance
]

{ #category : #accessing }
WTSCamera >> nearDistance: anObject [
	nearDistance := anObject
]

{ #category : #'viewport construction' }
WTSCamera >> viewportForRenderTarget: aRenderTarget resolveRenderTarget: aResolveRenderTarget bounds: bounds submode: submode [
	^ WTSViewport new
		camera: self;
		renderTarget: aRenderTarget;
		resolveRenderTarget: aResolveRenderTarget;
		bounds: (0@0 extent: aRenderTarget extent);
		submode: submode
]

{ #category : #'viewport construction' }
WTSCamera >> viewportForRenderTarget: aRenderTarget resolveRenderTarget: aResolveRenderTarget submode: submode [
	^ self viewportForRenderTarget: aRenderTarget resolveRenderTarget: aResolveRenderTarget bounds: aRenderTarget bounds submode: submode
]

{ #category : #'viewport construction' }
WTSCamera >> viewportsForRenderTarget: aRenderTarget resolveRenderTarget: aResolveRenderTarget submode: submode [
	^ { self viewportForRenderTarget: aRenderTarget resolveRenderTarget: aResolveRenderTarget submode: submode }
]
