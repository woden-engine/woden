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
		'toneMappingOperator',
		'hasAutoExposure',
		'fogMode',
		'fogStartDistance',
		'fogEndDistance',
		'fogColor',
		'fogDensity',
		'usesSceneBackgroundLayer',
		'usesSceneForegroundLayer',
		'backgroundColor',
		'cascadeSplitDistribution'
	],
	#classVars : [
		'FogModeExponential',
		'FogModeExponentialSquared',
		'FogModeLinear',
		'FogModeNone'
	],
	#category : #'WodenEngine-Scene-Graph'
}

{ #category : #'class initialization' }
WDSGCamera class >> fogModeExponential [
	^ FogModeExponential
]

{ #category : #'class initialization' }
WDSGCamera class >> fogModeExponentialSquared [
	^ FogModeExponentialSquared
]

{ #category : #'class initialization' }
WDSGCamera class >> fogModeLinear [
	^ FogModeLinear
]

{ #category : #'class initialization' }
WDSGCamera class >> fogModeNone [
	^ FogModeNone
]

{ #category : #'class initialization' }
WDSGCamera class >> initialize [
	super initialize.
	FogModeNone := 0.
	FogModeLinear := 1.
	FogModeExponential := 2.
	FogModeExponentialSquared := 3.
]

{ #category : #accessing }
WDSGCamera >> aspectRatio [
	^ aspectRatio
]

{ #category : #accessing }
WDSGCamera >> aspectRatio: anObject [
	aspectRatio := anObject
]

{ #category : #accessing }
WDSGCamera >> backgroundColor [
	^ backgroundColor
]

{ #category : #accessing }
WDSGCamera >> backgroundColor: anObject [
	backgroundColor := anObject
]

{ #category : #accessing }
WDSGCamera >> cascadeSplitDistribution [
	^ cascadeSplitDistribution
]

{ #category : #accessing }
WDSGCamera >> cascadeSplitDistribution: anObject [
	cascadeSplitDistribution := anObject
]

{ #category : #'as yet unclassified' }
WDSGCamera >> countedForBoundingBox [
	^ false
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
WDSGCamera >> fogColor [
	^ fogColor
]

{ #category : #accessing }
WDSGCamera >> fogColor: anObject [
	fogColor := anObject
]

{ #category : #accessing }
WDSGCamera >> fogDensity [
	^ fogDensity
]

{ #category : #accessing }
WDSGCamera >> fogDensity: anObject [
	fogDensity := anObject
]

{ #category : #accessing }
WDSGCamera >> fogEndDistance [
	^ fogEndDistance
]

{ #category : #accessing }
WDSGCamera >> fogEndDistance: anObject [
	fogEndDistance := anObject
]

{ #category : #accessing }
WDSGCamera >> fogMode [
	^ fogMode
]

{ #category : #accessing }
WDSGCamera >> fogMode: anObject [
	fogMode := anObject
]

{ #category : #accessing }
WDSGCamera >> fogStartDistance [
	^ fogStartDistance
]

{ #category : #accessing }
WDSGCamera >> fogStartDistance: anObject [
	fogStartDistance := anObject
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
	| result hh hw leftBottomNear rightTopNear left right bottom top nearFactor |
	result := WMFrustumF new.
	self isPerspective ifTrue: [
		leftBottomNear := frustum leftBottomNear.
		rightTopNear := frustum rightTopNear.
		
		left := leftBottomNear x.
		right := rightTopNear x.
		bottom := leftBottomNear y.
		top := rightTopNear y.
		nearFactor := newNearDistance / nearDistance.
		
		result reverseDepthFrustumLeft: left * nearFactor right: right * nearFactor
			bottom: bottom * nearFactor top: top * nearFactor near: newNearDistance far: newFarDistance 			invertedY: projectionInvertedY
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

{ #category : #accessing }
WDSGCamera >> hasAutoExposure [
	^ hasAutoExposure
]

{ #category : #accessing }
WDSGCamera >> hasAutoExposure: anObject [
	hasAutoExposure := anObject
]

{ #category : #testing }
WDSGCamera >> hasLinearFog [
	^ fogMode = FogModeLinear
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
	hasAutoExposure := true.
	toneMappingOperator := #linear.
	cascadeSplitDistribution := 0.5.
	fogMode := FogModeNone.
	fogStartDistance := 0.0.
	fogEndDistance := 1.0.
	fogDensity := 0.0.
	fogColor := WMVector4F zero.
	usesSceneBackgroundLayer := true.
	usesSceneForegroundLayer := true.
]

{ #category : #testing }
WDSGCamera >> isCamera [
	^ true
]

{ #category : #testing }
WDSGCamera >> isLdrToneMapping [
	hasAutoExposure ifTrue: [ ^ false ].
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

{ #category : #'as yet unclassified' }
WDSGCamera >> setExplicitFrustum: newFrustum invertedY: anInvertedY [
	aspectRatio ifNil: [ aspectRatio := 1.0 ].
	frustum := newFrustum.
	projectionInvertedY := anInvertedY.
	
]

{ #category : #'as yet unclassified' }
WDSGCamera >> storeGlobalStatesForGPUIn: cameraState [
	cameraState
		clipMapCameraPosition: self globalTransform translation;
		exposure: exposure;
		fogMode: fogMode;
		fogColor: fogColor asWMVector4F.		

	self hasLinearFog ifTrue: [ 
		cameraState
			fogFactor1: fogStartDistance;
			fogFactor2: fogEndDistance
	] ifFalse: [ 
		cameraState
			fogFactor1: fogDensity.
	]


]

{ #category : #accessing }
WDSGCamera >> toneMappingOperator [
	^ toneMappingOperator
]

{ #category : #accessing }
WDSGCamera >> toneMappingOperator: anObject [
	toneMappingOperator := anObject
]

{ #category : #accessing }
WDSGCamera >> toneMappingOperatorShaderName [
	hasAutoExposure ifTrue: [ ^ 'auto_' , toneMappingOperator ].
	^ toneMappingOperator
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

{ #category : #fog }
WDSGCamera >> useExponentialFog [
	self fogMode: FogModeExponential
]

{ #category : #fog }
WDSGCamera >> useExponentialSquaredFog [
	self fogMode: FogModeExponentialSquared
]

{ #category : #fog }
WDSGCamera >> useLinearFog [
	self fogMode: FogModeLinear
]

{ #category : #accessing }
WDSGCamera >> usesSceneBackgroundLayer [
	^ usesSceneBackgroundLayer
]

{ #category : #accessing }
WDSGCamera >> usesSceneBackgroundLayer: anObject [
	usesSceneBackgroundLayer := anObject
]

{ #category : #accessing }
WDSGCamera >> usesSceneForegroundLayer [
	^ usesSceneForegroundLayer
]

{ #category : #accessing }
WDSGCamera >> usesSceneForegroundLayer: anObject [
	usesSceneForegroundLayer := anObject
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

{ #category : #fog }
WDSGCamera >> withoutFog [
	fogMode := FogModeNone.
]
