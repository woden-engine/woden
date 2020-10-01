"
I represent a scene in the Woden 2 scene graph.
"
Class {
	#name : #WDSGScene,
	#superclass : #Object,
	#instVars : [
		'name',
		'engine',
		'backgroundColor',
		'backgroundLayer',
		'normalLayer',
		'foregroundLayer',
		'shaderSignature',
		'genericObjectStatePool',
		'commonGPUStateRenderingComponent',
		'skyLighting',
		'groundLighting',
		'sunDirection',
		'lightingProbe',
		'nodesWithPendingStates'
	],
	#category : #'WodenEngine-Scene-Graph'
}

{ #category : #'instance creation' }
WDSGScene class >> for: anEngine [
	^ self new initializeWithEngine: anEngine
]

{ #category : #adding }
WDSGScene >> add: aNode [
	normalLayer addChild: aNode.
]

{ #category : #adding }
WDSGScene >> addBackground: aNode [
	backgroundLayer addChild: aNode.
]

{ #category : #adding }
WDSGScene >> addForeground: aNode [
	foregroundLayer addChild: aNode.
]

{ #category : #adding }
WDSGScene >> addNodeWithPendingState: aNode [
	nodesWithPendingStates add: aNode
]

{ #category : #'rendering graph' }
WDSGScene >> addRenderingElementsToGraph: renderingDependencyGraph [
	self renderingGraphDependencies.
]

{ #category : #enumerating }
WDSGScene >> allChildrenDo: aBlock [
	self rootsDo: [ :root | root withAllChildrenDo: aBlock ]
]

{ #category : #enumerating }
WDSGScene >> allVisibleRenderingChildrenDo: aBlock [
	self rootsDo: [ :root | root withAllVisibleRenderingChildrenDo: aBlock ]
]

{ #category : #accessing }
WDSGScene >> ambientLighting: lighting [
	self 
		skyLighting: lighting;
		groundLighting: lighting
]

{ #category : #accessing }
WDSGScene >> backgroundColor [
	^ backgroundColor
]

{ #category : #accessing }
WDSGScene >> backgroundColor: anObject [
	backgroundColor := anObject
]

{ #category : #accessing }
WDSGScene >> backgroundLayer [
	^ backgroundLayer
]

{ #category : #'rendering phases' }
WDSGScene >> bakeLazyObjectStates [
	nodesWithPendingStates do: [ :node | node bakeLazyObjectStates ].
	nodesWithPendingStates removeAll.
]

{ #category : #'rendering phases' }
WDSGScene >> collectVisibleObjectsAndLightIntoViewport: renderingViewport [
	| frustumConvexHull boundingBox |
	backgroundLayer renderingRenderables select: #visible thenDo: [ :rr |
		rr isLightSource ifTrue: [
			renderingViewport addBackgroundLight: rr
		] ifFalse: [ 
			renderingViewport addBackgroundVisibleObject: rr.
		]
	].

	frustumConvexHull := renderingViewport globalFrustumConvexHull.
	normalLayer renderingRenderables select: #visible thenDo: [ :rr |
		boundingBox := rr boundingBox.
		(renderingViewport shouldRenderObject: rr) ifTrue: [
			rr isLightSource ifTrue: [
				rr isDirectionalLight ifTrue: [ 
					renderingViewport addLight: rr
				] ifFalse: [ 
					(frustumConvexHull isBoxOutside: boundingBox) ifFalse: [ 
						renderingViewport addLight: rr
					]
				]
			] ifFalse: [ 
				(frustumConvexHull isBoxOutside: boundingBox) ifFalse: [ 
					renderingViewport addVisibleObject: rr.
				]
			]
		].
	].

	foregroundLayer renderingRenderables select: #visible thenDo: [ :rr |
		rr isLightSource ifTrue: [
			renderingViewport addForegroundLight: rr
		] ifFalse: [ 
			renderingViewport addForegroundVisibleObject: rr.
		]
	].

]

{ #category : #'rendering graph' }
WDSGScene >> commonGPUStateRenderingComponent [
	^ commonGPUStateRenderingComponent ifNil: [commonGPUStateRenderingComponent := WDSGSceneCommonGPUStateRenderingComponent for: self]
]

{ #category : #building }
WDSGScene >> createSkyBoxWithMaterial: skyMaterial [
	| meshBuilder skyBox |
	meshBuilder := WDCGenericMeshBuilder for: engine.
	meshBuilder
		currentMaterial: skyMaterial;
		addInteriorCubeWithWidth: 2.0 height: 2.0 depth: 2.0.
	skyBox := WDSGSpatialObject new.
	skyBox 
		renderable: (meshBuilder mesh
			makeBackgroundRenderable;
			yourself
		).
	self addBackground: skyBox.

	^ skyBox
]

{ #category : #building }
WDSGScene >> createSkyBoxWithTexture: skyTexture [
	^ self createSkyBoxWithMaterial: ((WDCSkyMaterial for: engine)
		skyTexture: skyTexture;
		yourself)
]

{ #category : #building }
WDSGScene >> createSkyWithCubeTexture: skyTexture [
	| skyBox |
	skyBox := self createSkyBoxWithTexture: skyTexture.
	self lightingProbe: (engine resourceCache computeEnvironmentLightProbeFromCubeTexture: skyTexture).
	^ skyBox
]

{ #category : #'as yet unclassified' }
WDSGScene >> detachFromEngine [
	engine := nil.
	shaderSignature := nil.
	genericObjectStatePool := nil.
	commonGPUStateRenderingComponent := nil.
	self rootsDo: #engineChanged.
]

{ #category : #accessing }
WDSGScene >> engine [
	^ engine
]

{ #category : #accessing }
WDSGScene >> foregroundLayer [
	^ foregroundLayer
]

{ #category : #accessing }
WDSGScene >> genericObjectStatePool [
	genericObjectStatePool ifNil: [
		genericObjectStatePool := WDCStreamingUniformBufferPool new
			elementType: WDCGenericObjectState;
			engine: engine;
			yourself ].
	^ genericObjectStatePool
]

{ #category : #accessing }
WDSGScene >> groundLighting [
	^ groundLighting
]

{ #category : #accessing }
WDSGScene >> groundLighting: anObject [
	groundLighting := anObject
]

{ #category : #initialization }
WDSGScene >> initialize [
	super initialize.
	backgroundColor := Color black.
	skyLighting := Float32x4 x: 0.1 y: 0.1 z: 0.1 w: 0.1.
	groundLighting := skyLighting*0.5.
	sunDirection := (Float32x3 y: 1.0).

	nodesWithPendingStates := IdentitySet new.
	
	backgroundLayer := WDSGSceneLayer new addedToScene: self.
	normalLayer := WDSGSceneLayer new addedToScene: self.
	foregroundLayer := WDSGSceneLayer new addedToScene: self.

]

{ #category : #accessing }
WDSGScene >> initializeWithEngine: anEngine [
	self initializeWithEngine: anEngine shaderSignatureClass: WDCSceneRenderingShaderSignature
]

{ #category : #accessing }
WDSGScene >> initializeWithEngine: anEngine shaderSignatureClass: shaderSignatureClass [
	engine := anEngine.
	shaderSignature := shaderSignatureClass for: anEngine.
	self rootsDo: #engineChanged.
]

{ #category : #accessing }
WDSGScene >> lightingProbe [
	^ lightingProbe
]

{ #category : #accessing }
WDSGScene >> lightingProbe: anObject [
	lightingProbe := anObject
]

{ #category : #'rendering graph' }
WDSGScene >> modelRenderingGraphDependencies [
	^ { self commonGPUStateRenderingComponent }
]

{ #category : #accessing }
WDSGScene >> name [
	^ name
]

{ #category : #accessing }
WDSGScene >> name: anObject [
	name := anObject
]

{ #category : #accessing }
WDSGScene >> nodesWithPendingStates [
	^ nodesWithPendingStates
]

{ #category : #accessing }
WDSGScene >> normalLayer [
	^ normalLayer
]

{ #category : #copying }
WDSGScene >> postCopy [
	super postCopy.
	nodesWithPendingStates := IdentitySet new.

	backgroundLayer := backgroundLayer copy addedToScene: self.
	normalLayer := 	normalLayer copy addedToScene: self.
	foregroundLayer := foregroundLayer copy addedToScene: self.
	commonGPUStateRenderingComponent := nil.
]

{ #category : #enumerating }
WDSGScene >> precacheResources [
	engine ifNil: [ ^ self ].
	self allChildrenDo: #precacheResources
]

{ #category : #adding }
WDSGScene >> remove: aNode [
	normalLayer removeChild: aNode
]

{ #category : #adding }
WDSGScene >> removeNodeWithPendingState: aNode [
	nodesWithPendingStates remove: aNode ifAbsent: []
]

{ #category : #'rendering graph' }
WDSGScene >> renderingGraphDependencies [
	^ self modelRenderingGraphDependencies
]

{ #category : #adding }
WDSGScene >> roots [
	^ { backgroundLayer . normalLayer . foregroundLayer }
]

{ #category : #adding }
WDSGScene >> rootsDo: aBlock [
	aBlock value: backgroundLayer.
	aBlock value: normalLayer.
	aBlock value: foregroundLayer
]

{ #category : #accessing }
WDSGScene >> shaderSignature [
	^ shaderSignature
]

{ #category : #accessing }
WDSGScene >> skyLighting [
	^ skyLighting
]

{ #category : #accessing }
WDSGScene >> skyLighting: anObject [
	skyLighting := anObject
]

{ #category : #accessing }
WDSGScene >> sunDirection [
	^ sunDirection
]

{ #category : #accessing }
WDSGScene >> sunDirection: anObject [
	sunDirection := anObject
]

{ #category : #'rendering phases' }
WDSGScene >> updateCommonGPUState [
	| fullFrameIndex |
	fullFrameIndex := engine frameBufferingDriver frameIndex.
	self bakeLazyObjectStates.
	self rootsDo: [ :root |
		root updateCommonGpuStateForFrame: fullFrameIndex
	]
]
