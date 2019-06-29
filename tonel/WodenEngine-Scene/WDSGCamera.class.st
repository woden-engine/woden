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
		'projectionInvertedY',
		'isNotControlledByTheUser',
		'exposure',
		'toneMappingOperator'
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

{ #category : #'tone mapping' }
WDSGCamera >> exponentialToneMapping [
	self toneMappingOperator: #exponential
]

{ #category : #accessing }
WDSGCamera >> exposure [
	^ exposure
]

{ #category : #accessing }
WDSGCamera >> exposure: anObject [
	exposure := anObject
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
WDSGCamera >> frustumConvexHullTransformedWith: aTransform [
	| transformedFrustum |
	transformedFrustum := self frustum transformedWith: aTransform.
	^ WDCConvexHullWithPlanes new planes: transformedFrustum planes

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

{ #category : #accessing }
WDSGCamera >> globalFrustum [
	^ frustum transformedWith: self globalTransform
]

{ #category : #initialization }
WDSGCamera >> initialize [
	super initialize.
	nearDistance := 0.01.
	farDistance := 1000.0.
	fieldOfView := 60.0.
	focalDistance := 10.
	isPerspective := true.
	isNotControlledByTheUser := false.
	frustum := WMFrustumF new.
	exposure := 1.0.
	toneMappingOperator := #linear.
]

{ #category : #testing }
WDSGCamera >> isCamera [
	^ true
]

{ #category : #testing }
WDSGCamera >> isLdrToneMapping [
	^ exposure == 1.0 and: [ toneMappingOperator == #linear ]
]

{ #category : #accessing }
WDSGCamera >> isNotControlledByTheUser [
	^ isNotControlledByTheUser
]

{ #category : #accessing }
WDSGCamera >> isNotControlledByTheUser: anObject [
	isNotControlledByTheUser := anObject
]

{ #category : #accessing }
WDSGCamera >> isPerspective [
	^ isPerspective
]

{ #category : #accessing }
WDSGCamera >> isPerspective: anObject [
	isPerspective := anObject
]

{ #category : #'tone mapping' }
WDSGCamera >> linearToneMapping [
	self toneMappingOperator: #linear
]

{ #category : #accessing }
WDSGCamera >> nearDistance [
	^ nearDistance
]

{ #category : #accessing }
WDSGCamera >> nearDistance: anObject [
	nearDistance := anObject
]

{ #category : #'tone mapping' }
WDSGCamera >> reinhardToneMapping [
	self toneMappingOperator: #reinhard
]

{ #category : #accessing }
WDSGCamera >> toneMappingOperator [
	^ toneMappingOperator
]

{ #category : #accessing }
WDSGCamera >> toneMappingOperator: anObject [
	toneMappingOperator := anObject
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
