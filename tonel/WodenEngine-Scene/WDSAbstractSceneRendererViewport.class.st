Class {
	#name : #WDSAbstractSceneRendererViewport,
	#superclass : #Object,
	#instVars : [
		'viewport',
		'cameraLayersStates',
		'backgroundLayer',
		'normalLayer',
		'foregroundLayer'
	],
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #adding }
WDSAbstractSceneRendererViewport >> addBackgroundLight: aLight [
]

{ #category : #adding }
WDSAbstractSceneRendererViewport >> addBackgroundVisibleObject: aNode [
	backgroundLayer addVisibleObject: aNode.
]

{ #category : #adding }
WDSAbstractSceneRendererViewport >> addForegroundLight: aLight [
]

{ #category : #adding }
WDSAbstractSceneRendererViewport >> addForegroundVisibleObject: aNode [
	self addVisibleObject: aNode
]

{ #category : #adding }
WDSAbstractSceneRendererViewport >> addLight: aLight [
]

{ #category : #adding }
WDSAbstractSceneRendererViewport >> addVisibleObject: aNode [
	normalLayer addVisibleObject: aNode.
	aNode updateGpuStateForFrame: self engine frameBufferingDriver frameIndex camera: viewport camera.
]

{ #category : #accessing }
WDSAbstractSceneRendererViewport >> backgroundLayer [
	^ backgroundLayer
]

{ #category : #accessing }
WDSAbstractSceneRendererViewport >> camera [
	^ viewport camera
]

{ #category : #accessing }
WDSAbstractSceneRendererViewport >> cameraLayersStates [
	^ cameraLayersStates
]

{ #category : #accessing }
WDSAbstractSceneRendererViewport >> cameraLayersStates: anObject [
	cameraLayersStates := anObject
]

{ #category : #accessing }
WDSAbstractSceneRendererViewport >> editorViewType [
	^ viewport editorViewType
]

{ #category : #accessing }
WDSAbstractSceneRendererViewport >> engine [
	^ self scene engine
]

{ #category : #accessing }
WDSAbstractSceneRendererViewport >> extent [
	^ viewport extent
]

{ #category : #accessing }
WDSAbstractSceneRendererViewport >> foregroundLayer [
	^ foregroundLayer
]

{ #category : #'as yet unclassified' }
WDSAbstractSceneRendererViewport >> globalFrustumConvexHull [
	^ viewport globalFrustumConvexHull
]

{ #category : #initialization }
WDSAbstractSceneRendererViewport >> initialize [
	super initialize.
	backgroundLayer := WDSSceneRendererViewportLayer new.
	normalLayer := WDSSceneRendererViewportLayer new.
	foregroundLayer := WDSSceneRendererViewportLayer new.
]

{ #category : #accessing }
WDSAbstractSceneRendererViewport >> normalLayer [
	^ normalLayer
]

{ #category : #accessing }
WDSAbstractSceneRendererViewport >> renderTarget [
	^ viewport renderTarget
]

{ #category : #accessing }
WDSAbstractSceneRendererViewport >> sampleCount [
	^ viewport sampleCount
]

{ #category : #accessing }
WDSAbstractSceneRendererViewport >> scene [
	^ viewport camera scene
]

{ #category : #'as yet unclassified' }
WDSAbstractSceneRendererViewport >> sceneLuminanceComputationPasses [
	^ #()
]

{ #category : #asserting }
WDSAbstractSceneRendererViewport >> shouldRenderBackgroundLayer [
	^ false
]

{ #category : #asserting }
WDSAbstractSceneRendererViewport >> shouldRenderForegroundLayer [
	^ false
]

{ #category : #asserting }
WDSAbstractSceneRendererViewport >> shouldRenderObject: aNode [
	^ viewport filter value: aNode
]

{ #category : #sorting }
WDSAbstractSceneRendererViewport >> sortVisibleObjects [
	| sortBlock |
	sortBlock := self visibleObjectSortBlock.
	backgroundLayer sortVisibleObjectsWithBlock: sortBlock.	
	normalLayer sortVisibleObjectsWithBlock: sortBlock.	
	foregroundLayer sortVisibleObjectsWithBlock: sortBlock.	

]

{ #category : #accessing }
WDSAbstractSceneRendererViewport >> submode [
	^ viewport submode
]

{ #category : #accessing }
WDSAbstractSceneRendererViewport >> viewport [
	^ viewport
]

{ #category : #accessing }
WDSAbstractSceneRendererViewport >> viewport: anObject [
	viewport := anObject
]

{ #category : #sorting }
WDSAbstractSceneRendererViewport >> visibleObjectSortBlock [
	| translucentSortedPriority forwardDirection |
	translucentSortedPriority := WDCAbstractRenderable renderPriorityTranslucentSorted.
	forwardDirection := self camera globalTransform matrix thirdColumn negated.
	^ [ :a :b |
		a renderPriority = b renderPriority ifFalse: [
			a renderPriority < b renderPriority
		] ifTrue: [
			a renderPriority >= translucentSortedPriority ifTrue: [ 
				(forwardDirection dot: a transform translation) > (forwardDirection dot: b transform translation)
			] ifFalse: [ false ]
		]
	]
]
