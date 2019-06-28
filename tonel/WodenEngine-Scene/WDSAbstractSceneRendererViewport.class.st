Class {
	#name : #WDSAbstractSceneRendererViewport,
	#superclass : #Object,
	#instVars : [
		'viewport',
		'visibleObjects',
		'cameraStateShaderBindings'
	],
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #adding }
WDSAbstractSceneRendererViewport >> addLight: aLight [
]

{ #category : #adding }
WDSAbstractSceneRendererViewport >> addVisibleObject: aNode [
	visibleObjects add: aNode
]

{ #category : #accessing }
WDSAbstractSceneRendererViewport >> camera [
	^ viewport camera
]

{ #category : #accessing }
WDSAbstractSceneRendererViewport >> cameraStateShaderBindings [
	^ cameraStateShaderBindings
]

{ #category : #accessing }
WDSAbstractSceneRendererViewport >> cameraStateShaderBindings: anObject [
	cameraStateShaderBindings := anObject
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

{ #category : #initialization }
WDSAbstractSceneRendererViewport >> initialize [
	super initialize.
	visibleObjects := OrderedCollection new.
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

{ #category : #asserting }
WDSAbstractSceneRendererViewport >> shouldRenderObject: aNode [
	^ viewport filter value: aNode
]

{ #category : #sorting }
WDSAbstractSceneRendererViewport >> sortVisibleObjects [
	| translucentSortedPriority forwardDirection |
	translucentSortedPriority := WDCAbstractRenderable renderPriorityTranslucentSorted.
	
	forwardDirection := self camera globalTransform matrix thirdColumn negated.
	visibleObjects sort: [ :a :b |
		a renderPriority = b renderPriority ifFalse: [
			a renderPriority < b renderPriority
		] ifTrue: [
			a renderPriority >= translucentSortedPriority ifTrue: [ 
				(forwardDirection dot: a transform translation) > (forwardDirection dot: b transform translation)
			] ifFalse: [ false ]
		]
	]
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

{ #category : #accessing }
WDSAbstractSceneRendererViewport >> visibleObjects [
	^ visibleObjects
]
