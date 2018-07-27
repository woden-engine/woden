"
I represent a node in the Woden scene graph.
"
Class {
	#name : #WDSGNode,
	#superclass : #Object,
	#instVars : [
		'scene',
		'transform',
		'children',
		'visible',
		'lastUpdatedGpuFrame',
		'parent',
		'renderTransform',
		'model',
		'modificationCount',
		'updatedPerFrame',
		'stateChangeListeners',
		'useViewportCamera'
	],
	#classVars : [
		'RenderPriorityDefault',
		'RenderPriorityEditorOpaqueAfter',
		'RenderPriorityEditorOpaqueBefore',
		'RenderPriorityEditorTranslucentAfter',
		'RenderPriorityEditorTranslucentSortedAfter',
		'RenderPriorityOpaque',
		'RenderPriorityOpaqueStatic',
		'RenderPriorityTranslucent',
		'RenderPriorityTranslucentSorted'
	],
	#category : #'WodenEngine-Scene-Graph'
}

{ #category : #'class initialization' }
WDSGNode class >> initialize [
	super initialize.
	
	RenderPriorityEditorOpaqueBefore := 0.

	RenderPriorityOpaque := 200.
	RenderPriorityOpaqueStatic := RenderPriorityOpaque.
	RenderPriorityDefault := RenderPriorityOpaque.

	RenderPriorityEditorOpaqueAfter := 800.
	
	RenderPriorityTranslucent := 1000.
	
	RenderPriorityEditorTranslucentAfter := 1500.

	RenderPriorityTranslucentSorted := 2000.
	
	RenderPriorityEditorTranslucentSortedAfter := 2500.
	
]

{ #category : #accessing }
WDSGNode class >> renderPriorityDefault [
	^ RenderPriorityDefault
]

{ #category : #accessing }
WDSGNode class >> renderPriorityEditorOpaqueAfter [
	^ RenderPriorityEditorOpaqueAfter
]

{ #category : #accessing }
WDSGNode class >> renderPriorityEditorOpaqueBefore [
	^ RenderPriorityEditorOpaqueBefore
]

{ #category : #'class initialization' }
WDSGNode class >> renderPriorityEditorTranslucentAfter [
	^ RenderPriorityEditorTranslucentAfter
]

{ #category : #accessing }
WDSGNode class >> renderPriorityOpaque [
	^ RenderPriorityOpaque
]

{ #category : #accessing }
WDSGNode class >> renderPriorityOpaqueStatic [
	^ RenderPriorityOpaqueStatic
]

{ #category : #accessing }
WDSGNode class >> renderPriorityTranslucent [
	^ RenderPriorityTranslucent
]

{ #category : #accessing }
WDSGNode class >> renderPriorityTranslucentSorted [
	^ RenderPriorityTranslucentSorted
]

{ #category : #adding }
WDSGNode >> addChild: aChild [
	children add: aChild.
	aChild addedToNode: self.
	self increaseModificationCount.
]

{ #category : #adding }
WDSGNode >> addedToNode: newParentNode [
	newParentNode scene ifNotNil: [ self addedToScene: newParentNode scene ].
	parent := newParentNode.
]

{ #category : #adding }
WDSGNode >> addedToScene: aScene [
	self assert: scene isNil.
	scene := aScene.
	self createSceneDependentData.
	children do: [ :child | child addedToScene: scene ].
]

{ #category : #converting }
WDSGNode >> asSceneNode [
	^ self
]

{ #category : #testing }
WDSGNode >> canBeRendered [
	^ false
]

{ #category : #accessing }
WDSGNode >> children [
	^ children
]

{ #category : #rendering }
WDSGNode >> createSceneDependentData [
	"Here goes the creation of scene dependent data."
]

{ #category : #accessing }
WDSGNode >> engine [
	^ scene engine
]

{ #category : #initialization }
WDSGNode >> increaseModificationCount [
	modificationCount := modificationCount + 1
]

{ #category : #initialization }
WDSGNode >> initialize [
	super initialize.
	transform := WMReversibleAffineTransformF identity.
	children := OrderedCollection new.
	visible := true.
	modificationCount := 0.
	updatedPerFrame := true.
	useViewportCamera := false.
]

{ #category : #testing }
WDSGNode >> isCamera [
	^ false
]

{ #category : #testing }
WDSGNode >> isInstance [
	^ false
]

{ #category : #testing }
WDSGNode >> isInstanceGroup [
	^ false
]

{ #category : #testing }
WDSGNode >> isLightSource [
	^ false
]

{ #category : #testing }
WDSGNode >> isMultiEyeCamera [
	^ false
]

{ #category : #testing }
WDSGNode >> isSpatialObject [
	^ false
]

{ #category : #accessing }
WDSGNode >> model [
	^ model
]

{ #category : #accessing }
WDSGNode >> model: anObject [
	model := anObject
]

{ #category : #accessing }
WDSGNode >> numberOfChildren [
	^ children size
]

{ #category : #changing }
WDSGNode >> onStateChangeDo: aBlock [
	stateChangeListeners := stateChangeListeners
		ifNil: [ { aBlock } ]
		ifNotNil: [ stateChangeListeners , { aBlock } ]
	
]

{ #category : #adding }
WDSGNode >> parent [
	^ parent
]

{ #category : #rendering }
WDSGNode >> performGpuStateUpdateWithCamera: aCamera [
]

{ #category : #adding }
WDSGNode >> removeChild: node [
	children remove: node.
	node removedFromNode: self.
	self increaseModificationCount.
]

{ #category : #adding }
WDSGNode >> removeFromScene [
	parent ifNotNil: [ parent removeChild: self ] ifNil: [ scene ifNotNil: [ scene remove: self ] ]
]

{ #category : #adding }
WDSGNode >> removedFromNode: oldParentNode [
	scene ifNotNil: [ self removedFromScene: scene ].
	parent := nil.
]

{ #category : #adding }
WDSGNode >> removedFromScene: Scene [
	scene := nil.
	children do: [ :child | child removedFromScene: scene ].
]

{ #category : #accessing }
WDSGNode >> renderModificationCountFor: mode submode: submode [
	^ 0
]

{ #category : #rendering }
WDSGNode >> renderOn: stateTracker [
	"Nothing to do by default"
]

{ #category : #rendering }
WDSGNode >> renderOn: commandList mode: renderMode submode: submode [
	"Nothing to do by default"
]

{ #category : #accessing }
WDSGNode >> renderPriority [
	^ RenderPriorityDefault
]

{ #category : #accessing }
WDSGNode >> renderTransform [
	^ renderTransform
]

{ #category : #accessing }
WDSGNode >> scene [
	^ scene
]

{ #category : #changing }
WDSGNode >> stateChanged [
	stateChangeListeners ifNotNil: [ stateChangeListeners do: [ :handler | handler value: self ] ].
]

{ #category : #accessing }
WDSGNode >> transform [
	^ transform
]

{ #category : #accessing }
WDSGNode >> transform: aTransform [
	transform := aTransform asWMReversibleAffineTransformF.
	self stateChanged
]

{ #category : #'as yet unclassified' }
WDSGNode >> updateGpuStateForFrame: frameIndex camera: currentCamera [
	frameIndex = lastUpdatedGpuFrame ifTrue: [ ^ self ].
	lastUpdatedGpuFrame := frameIndex.
	parent ifNotNil: [ parent updateGpuStateForFrame: frameIndex camera: currentCamera ].
	self
		updateRenderTransform;
		performGpuStateUpdateWithCamera: currentCamera.

]

{ #category : #accessing }
WDSGNode >> updateRenderTransform [
	parent ifNotNil: [
		renderTransform := parent renderTransform transformTransform: transform.
	] ifNil: [
		renderTransform := transform.
	].

]

{ #category : #accessing }
WDSGNode >> updatedPerFrame [
	^ updatedPerFrame
]

{ #category : #accessing }
WDSGNode >> updatedPerFrame: anObject [
	updatedPerFrame := anObject
]

{ #category : #accessing }
WDSGNode >> useViewportCamera [
	^ useViewportCamera
]

{ #category : #accessing }
WDSGNode >> useViewportCamera: anObject [
	useViewportCamera := anObject
]

{ #category : #accessing }
WDSGNode >> visible [
	^ visible
]

{ #category : #accessing }
WDSGNode >> visible: anObject [
	visible := anObject
]
