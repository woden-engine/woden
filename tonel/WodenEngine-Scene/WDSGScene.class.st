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
		'roots',
		'shaderSignature',
		'genericObjectStatePool',
		'neutralObjectInstanceStatePool',
		'neutralObjectInstanceState',
		'commonGPUStateRenderingComponent',
		'skyLighting',
		'groundLighting',
		'sunDirection',
		'lightingEnvironmentMap'
	],
	#category : #'WodenEngine-Scene-Graph'
}

{ #category : #'instance creation' }
WDSGScene class >> for: anEngine [
	^ self new initializeWithEngine: anEngine
]

{ #category : #adding }
WDSGScene >> add: aNode [
	roots add: aNode.
	aNode addedToScene: self
]

{ #category : #'rendering graph' }
WDSGScene >> addRenderingElementsToGraph: renderingDependencyGraph [
	self renderingGraphDependencies.
]

{ #category : #enumerating }
WDSGScene >> allChildrenDo: aBlock [
	roots do: [ :root | root withAllChildrenDo: aBlock ]
]

{ #category : #enumerating }
WDSGScene >> allVisibleRenderingChildrenDo: aBlock [
	roots do: [ :root | root withAllVisibleRenderingChildrenDo: aBlock ]
]

{ #category : #accessing }
WDSGScene >> ambientLighting: lighting [
	self 
		skyLighting: lighting;
		skyLighting: lighting
]

{ #category : #accessing }
WDSGScene >> backgroundColor [
	^ backgroundColor
]

{ #category : #accessing }
WDSGScene >> backgroundColor: anObject [
	backgroundColor := anObject
]

{ #category : #enumerating }
WDSGScene >> collectVisibleObjectsAndLightIntoViewport: renderingViewport [
	self allVisibleRenderingChildrenDo: [ :child |
		(renderingViewport shouldRenderObject: child) ifTrue: [ 
			renderingViewport addVisibleObject: child.
		
			child isLightSource ifTrue: [ 
				renderingViewport addLight: child
			]
		]
	]
]

{ #category : #'rendering graph' }
WDSGScene >> commonGPUStateRenderingComponent [
	^ commonGPUStateRenderingComponent ifNil: [commonGPUStateRenderingComponent := WDSGSceneCommonGPUStateRenderingComponent for: self]
]

{ #category : #'as yet unclassified' }
WDSGScene >> detachFromEngine [
	engine := nil.
	shaderSignature := nil.
	genericObjectStatePool := nil.
	neutralObjectInstanceStatePool := nil.
	neutralObjectInstanceState := nil.
	commonGPUStateRenderingComponent := nil.
	roots engineChanged.
]

{ #category : #accessing }
WDSGScene >> engine [
	^ engine
]

{ #category : #accessing }
WDSGScene >> genericObjectStatePool [
	genericObjectStatePool ifNil: [
		genericObjectStatePool := WDCStreamingUniformBufferPool new
			elementType: WTGenericObjectState;
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
	skyLighting := WMVector4F x: 0.1 y: 0.1 z: 0.1 w: 0.1.
	groundLighting := skyLighting*0.5.
	sunDirection := (WMVector3F y: 1.0).

	roots := OrderedCollection new.

]

{ #category : #accessing }
WDSGScene >> initializeWithEngine: anEngine [
	self initializeWithEngine: anEngine shaderSignatureClass: WDCSceneRenderingShaderSignature
]

{ #category : #accessing }
WDSGScene >> initializeWithEngine: anEngine shaderSignatureClass: shaderSignatureClass [
	engine := anEngine.
	shaderSignature := shaderSignatureClass for: anEngine.
	roots do: #engineChanged.
]

{ #category : #accessing }
WDSGScene >> lightingEnvironmentMap [
	^ lightingEnvironmentMap
]

{ #category : #accessing }
WDSGScene >> lightingEnvironmentMap: anObject [
	lightingEnvironmentMap := anObject
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
WDSGScene >> neutralGenericObjectInstanceState [
	neutralObjectInstanceStatePool ifNil: [
		neutralObjectInstanceStatePool := WDCStreamingStorageBufferPool new
			heapSize: 1;
			elementType: WTGenericObjectState;
			engine: engine;
			yourself.
			
		neutralObjectInstanceState := neutralObjectInstanceStatePool allocate.
		neutralObjectInstanceState value: WTGenericObjectState neutralState
	].
	^ neutralObjectInstanceState
]

{ #category : #accessing }
WDSGScene >> numberOfRoots [
	^ roots size
]

{ #category : #adding }
WDSGScene >> remove: aNode [
	roots remove: aNode.
	aNode removedFromScene: self
]

{ #category : #'rendering graph' }
WDSGScene >> renderingGraphDependencies [
	^ self modelRenderingGraphDependencies
]

{ #category : #accessing }
WDSGScene >> roots [
	^ roots
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

	self allChildrenDo: [ :object |
		object
			updateRenderTransform;
			updateCommonGpuStateForFrame: fullFrameIndex
	]
]
