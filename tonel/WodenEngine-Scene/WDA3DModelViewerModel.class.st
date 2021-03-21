Class {
	#name : #WDA3DModelViewerModel,
	#superclass : #WDASampleSceneModel,
	#instVars : [
		'modelAsset',
		'isCameraPositioned',
		'hasBackgroundSetup',
		'castShadows',
		'mainLightSource',
		'modelNodes',
		'currentAnimatedNodes',
		'currentAnimation',
		'currentAnimationTime'
	],
	#category : #'WodenEngine-Scene-Examples'
}

{ #category : #adding }
WDA3DModelViewerModel >> addCube: box [
	| node |
	node := WDSGSpatialObject new.
	node
		renderable: engine resourceCache unitCubeMesh;
		transform: box reversibleTransformToConvertUnitBoxToMe.
	scene add: node
]

{ #category : #adding }
WDA3DModelViewerModel >> addMeshModel: meshModel [
	| node |
	node := WDSGSpatialObject new.
	node renderable: meshModel.
	scene add: node.
	modelNodes add: node.
]

{ #category : #adding }
WDA3DModelViewerModel >> addSceneModel: sceneModel [
	sceneModel normalLayer childrenDo: [ :each |
		| instancedNode |
		instancedNode := each copyExcludingNullNodes.
		modelNodes add: instancedNode.
		scene add: instancedNode.
	]
]

{ #category : #'rendering process stages' }
WDA3DModelViewerModel >> advanceCurrentAnimation: delta [
	currentAnimation ifNil: [ ^ self ].
	currentAnimationTime := currentAnimationTime + delta.
	
	currentAnimatedNodes do: [ :each |
		each renderable deformationState
			setRestPose;
			applyAnimation: currentAnimation repeated: true inTime: currentAnimationTime;
			computePoseMatrices
	]
]

{ #category : #'as yet unclassified' }
WDA3DModelViewerModel >> animateableNodes [
	| result |
	result := OrderedCollection new.
	modelNodes do: [ :each |
		each withAllChildrenDo: [ :child |
			(child renderable isNotNil and: [ child renderable isSkinnedRenderable ]) ifTrue: [
				result add: child
			]
		]
	].
	^ result
]

{ #category : #accessing }
WDA3DModelViewerModel >> castShadows [
	^ castShadows
]

{ #category : #accessing }
WDA3DModelViewerModel >> castShadows: aBoolean [
	castShadows := aBoolean.
	mainLightSource ifNotNil: [ mainLightSource castShadows: castShadows ]
]

{ #category : #opening }
WDA3DModelViewerModel >> ensureBackgroundSetup [
	hasBackgroundSetup ifTrue: [ ^ self ].
	self setDefaultBackground
]

{ #category : #'as yet unclassified' }
WDA3DModelViewerModel >> ensureCameraSetup [
	| sceneBoundingBox |
	isCameraPositioned ifTrue: [ ^ self ].
	
	sceneBoundingBox := scene normalLayer globalBoundingBox.
	camera := WDSGCamera new.
	camera position: (sceneBoundingBox center + (Float32x3 z: sceneBoundingBox depth * 2)).
	scene add: camera.

	isCameraPositioned := true.
]

{ #category : #initialization }
WDA3DModelViewerModel >> initialize [
	super initialize.
	hasBackgroundSetup := false.
	isCameraPositioned := false.
	castShadows := false.
	modelNodes := OrderedCollection new.
	currentAnimatedNodes := #().
	currentAnimation := nil.
]

{ #category : #accessing }
WDA3DModelViewerModel >> modelAsset [
	^ modelAsset
]

{ #category : #accessing }
WDA3DModelViewerModel >> modelAsset: anObject [
	modelAsset := anObject
]

{ #category : #'instance creation' }
WDA3DModelViewerModel >> newScene [
	self scene: (WDSGScene for: engine)
]

{ #category : #'as yet unclassified' }
WDA3DModelViewerModel >> playAnimation: anAnimation [
	self stopCurrentAnimation.

	currentAnimatedNodes := self animateableNodes.
	currentAnimatedNodes ifEmpty: [ ^ self ].
	currentAnimation := anAnimation.
	currentAnimationTime := 0.0.
]

{ #category : #'as yet unclassified' }
WDA3DModelViewerModel >> playAnimationNamed: animationName [
	self playAnimation: (modelAsset getAnimationNamed: animationName)
]

{ #category : #'as yet unclassified' }
WDA3DModelViewerModel >> playIndexedAnimation: animationIndex [
	self playAnimation: (modelAsset animations at: animationIndex + 1 ifAbsent: [ ^ self ])
]

{ #category : #opening }
WDA3DModelViewerModel >> prepareToOpenView [
	self
		ensureBackgroundSetup;
		ensureCameraSetup.
]

{ #category : #transforming }
WDA3DModelViewerModel >> scaleBy: scaleFactor [
	scene normalLayer childrenDo: [ :each |
		each scaleBy: scaleFactor
	]
	
]

{ #category : #'instance creation' }
WDA3DModelViewerModel >> setBlackBackground [
	scene backgroundColor: Float32x4.
	hasBackgroundSetup := true.
]

{ #category : #initialization }
WDA3DModelViewerModel >> setCameraFarDistance: farDistance [
	self ensureCameraSetup.
	camera farDistance: farDistance.

]

{ #category : #initialization }
WDA3DModelViewerModel >> setCameraPosition: newPosition [
	self ensureCameraSetup.
	camera position: newPosition.

]

{ #category : #'instance creation' }
WDA3DModelViewerModel >> setDarkColoredBackground [
	scene backgroundColor: Color veryDarkGray.
	hasBackgroundSetup := true.
]

{ #category : #'instance creation' }
WDA3DModelViewerModel >> setDaylightBackground [
	| skyTexture |
	scene backgroundColor: Float32x4 zeros.

	"Add a light"
	mainLightSource := WDSGLightSource new.
	mainLightSource
		directional; castShadows: castShadows;
		intensity: (Float32x4 x: 1.0 y: 1.0 z: 0.8) normalized * 0.6;
		rotateDegreesOnX: -35.
	
	scene add: mainLightSource.

	scene ambientLighting: Float32x4 zeros.
	
	skyTexture := WDASceneExamples
		proceduralSkySunDirection: (mainLightSource transform transformVector:(Float32x3 z: 1.0)).
	skyTexture := skyTexture asSRGBTextureFor: engine.
	scene createSkyWithCubeTexture: skyTexture.
	hasBackgroundSetup := true.
]

{ #category : #'instance creation' }
WDA3DModelViewerModel >> setDefaultBackground [
	self setDaylightBackground
]

{ #category : #'as yet unclassified' }
WDA3DModelViewerModel >> stopCurrentAnimation [
	currentAnimatedNodes do: [ :each | each deformationState setRestPoseAndMatrices ].
	currentAnimatedNodes := #().
	currentAnimation := nil.
]

{ #category : #'rendering process stages' }
WDA3DModelViewerModel >> updateForFrameDelta: delta [.
	super updateForFrameDelta: delta.
	self advanceCurrentAnimation: delta.
]
