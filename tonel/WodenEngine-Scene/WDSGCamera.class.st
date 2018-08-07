"
I represent a camera in the woden scene graph.
"
Class {
	#name : #WDSGCamera,
	#superclass : #WDSGNode,
	#instVars : [
		'nearDistance',
		'farDistance',
		'fieldOfView',
		'focalDistance',
		'isPerspective',
		'frustum'
	],
	#category : #'WodenEngine-Scene-Graph'
}

{ #category : #accessing }
WDSGCamera >> farDistance [
	^ farDistance
]

{ #category : #accessing }
WDSGCamera >> farDistance: anObject [
	farDistance := anObject
]

{ #category : #accessing }
WDSGCamera >> fieldOfView [
	^ fieldOfView
]

{ #category : #accessing }
WDSGCamera >> fieldOfView: anObject [
	fieldOfView := anObject
]

{ #category : #accessing }
WDSGCamera >> focalDistance [
	^ focalDistance
]

{ #category : #accessing }
WDSGCamera >> focalDistance: anObject [
	focalDistance := anObject
]

{ #category : #accessing }
WDSGCamera >> frustum [
	^ frustum
]

{ #category : #initialization }
WDSGCamera >> initialize [
	super initialize.
	nearDistance := 0.01.
	farDistance := 100.0.
	fieldOfView := 60.0.
	focalDistance := 10.
	isPerspective := true.
	frustum := WMFrustumF new.
	
]

{ #category : #testing }
WDSGCamera >> isCamera [
	^ true
]

{ #category : #accessing }
WDSGCamera >> isPerspective [
	^ isPerspective
]

{ #category : #accessing }
WDSGCamera >> isPerspective: anObject [
	isPerspective := anObject
]

{ #category : #accessing }
WDSGCamera >> nearDistance [
	^ nearDistance
]

{ #category : #accessing }
WDSGCamera >> nearDistance: anObject [
	nearDistance := anObject
]

{ #category : #'viewport construction' }
WDSGCamera >> viewportForRenderTarget: aRenderTarget resolveRenderTarget: aResolveRenderTarget bounds: bounds submode: submode [
	^ WDSGViewport new
		camera: self;
		renderTarget: aRenderTarget;
		resolveRenderTarget: aResolveRenderTarget;
		bounds: (0@0 extent: aRenderTarget extent);
		submode: submode
]

{ #category : #'viewport construction' }
WDSGCamera >> viewportForRenderTarget: aRenderTarget resolveRenderTarget: aResolveRenderTarget submode: submode [
	^ self viewportForRenderTarget: aRenderTarget resolveRenderTarget: aResolveRenderTarget bounds: aRenderTarget bounds submode: submode
]

{ #category : #'viewport construction' }
WDSGCamera >> viewportsForRenderTarget: aRenderTarget resolveRenderTarget: aResolveRenderTarget submode: submode [
	^ { self viewportForRenderTarget: aRenderTarget resolveRenderTarget: aResolveRenderTarget submode: submode }
]
