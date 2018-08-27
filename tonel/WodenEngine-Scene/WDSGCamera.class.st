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
		'frustum',
		'aspectRatio',
		'projectionInvertedY'
	],
	#category : #'WodenEngine-Scene-Graph'
}

{ #category : #accessing }
WDSGCamera >> aspectRatio [
	^ aspectRatio
]

{ #category : #accessing }
WDSGCamera >> aspectRatio: anObject [
	aspectRatio := anObject
]

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

{ #category : #'as yet unclassified' }
WDSGCamera >> frustumForNearDistance: newNearDistance farDistance: newFarDistance [
	| result hh hw |
	result := WMFrustumF new.
	self isPerspective ifTrue: [
		result reverseDepthPerspectiveFovY: fieldOfView aspect: aspectRatio near: newNearDistance far: newFarDistance invertedY: projectionInvertedY.
	] ifFalse: [
		hh := (fieldOfView * 0.5) degreesToRadians tan * focalDistance.
		hw := hh * aspectRatio.
		result reverseDepthOrthoLeft: hw negated right: hw
			bottom: hh negated top: hh
			near: newNearDistance far: newFarDistance invertedY: projectionInvertedY
	].
	^ result
]

{ #category : #initialization }
WDSGCamera >> initialize [
	super initialize.
	nearDistance := 0.01.
	farDistance := 1000.0.
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

{ #category : #'as yet unclassified' }
WDSGCamera >> updateFrustumWithAspectRatio: newAspectRatio projectionInvertedY: newProjectionInvertedY [
	aspectRatio := newAspectRatio.
	projectionInvertedY := newProjectionInvertedY.
	^ self updateSymmetricalFrustum
]

{ #category : #'as yet unclassified' }
WDSGCamera >> updateSymmetricalFrustum [
	| hh hw |
	self isPerspective ifTrue: [
		frustum reverseDepthPerspectiveFovY: fieldOfView aspect: aspectRatio near: nearDistance far: farDistance invertedY: projectionInvertedY.
	] ifFalse: [
		hh := (fieldOfView * 0.5 ) degreesToRadians tan * focalDistance.
		hw := hh * aspectRatio.
		frustum reverseDepthOrthoLeft: hw negated right: hw
			bottom: hh negated top: hh
			near: nearDistance far: farDistance invertedY: projectionInvertedY
	]
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
