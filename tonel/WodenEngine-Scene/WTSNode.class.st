"
I represent a node in the Woden scene graph.
"
Class {
	#name : #WTSNode,
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
	#category : 'WodenEngine-Scene-Graph'
}

{ #category : #'class initialization' }
WTSNode class >> initialize [
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
WTSNode class >> renderPriorityDefault [
	^ RenderPriorityDefault
]

{ #category : #accessing }
WTSNode class >> renderPriorityEditorOpaqueAfter [
	^ RenderPriorityEditorOpaqueAfter
]

{ #category : #accessing }
WTSNode class >> renderPriorityEditorOpaqueBefore [
	^ RenderPriorityEditorOpaqueBefore
]

{ #category : #'class initialization' }
WTSNode class >> renderPriorityEditorTranslucentAfter [
	^ RenderPriorityEditorTranslucentAfter
]

{ #category : #accessing }
WTSNode class >> renderPriorityOpaque [
	^ RenderPriorityOpaque
]

{ #category : #accessing }
WTSNode class >> renderPriorityOpaqueStatic [
	^ RenderPriorityOpaqueStatic
]

{ #category : #accessing }
WTSNode class >> renderPriorityTranslucent [
	^ RenderPriorityTranslucent
]

{ #category : #accessing }
WTSNode class >> renderPriorityTranslucentSorted [
	^ RenderPriorityTranslucentSorted
]

{ #category : #adding }
WTSNode >> addChild: aChild [
	children add: aChild.
	aChild addedToNode: self.
	self increaseModificationCount.
]

{ #category : #adding }
WTSNode >> addedToNode: newParentNode [
	newParentNode scene ifNotNil: [ self addedToScene: newParentNode scene ].
	parent := newParentNode.
]

{ #category : #adding }
WTSNode >> addedToScene: aScene [
	self assert: scene isNil.
	scene := aScene.
	self createSceneDependentData.
	children do: [ :child | child addedToScene: scene ].
]

{ #category : #converting }
WTSNode >> asSceneNode [
	^ self
]

{ #category : #testing }
WTSNode >> canBeRendered [
	^ false
]

{ #category : #accessing }
WTSNode >> children [
	^ children
]

{ #category : #rendering }
WTSNode >> createSceneDependentData [
	"Here goes the creation of scene dependent data."
]

{ #category : #accessing }
WTSNode >> engine [
	^ scene engine
]

{ #category : #initialization }
WTSNode >> increaseModificationCount [
	modificationCount := modificationCount + 1
]

{ #category : #initialization }
WTSNode >> initialize [
	super initialize.
	transform := WMReversibleAffineTransformF identity.
	children := OrderedCollection new.
	visible := true.
	modificationCount := 0.
	updatedPerFrame := true.
	useViewportCamera := false.
]

{ #category : #testing }
WTSNode >> isCamera [
	^ false
]

{ #category : #testing }
WTSNode >> isInstance [
	^ false
]

{ #category : #testing }
WTSNode >> isInstanceGroup [
	^ false
]

{ #category : #testing }
WTSNode >> isLightSource [
	^ false
]

{ #category : #testing }
WTSNode >> isMultiEyeCamera [
	^ false
]

{ #category : #testing }
WTSNode >> isSpatialObject [
	^ false
]

{ #category : #accessing }
WTSNode >> model [
	^ model
]

{ #category : #accessing }
WTSNode >> model: anObject [
	model := anObject
]

{ #category : #accessing }
WTSNode >> numberOfChildren [
	^ children size
]

{ #category : #changing }
WTSNode >> onStateChangeDo: aBlock [
	stateChangeListeners := stateChangeListeners
		ifNil: [ { aBlock } ]
		ifNotNil: [ stateChangeListeners , { aBlock } ]
	
]

{ #category : #adding }
WTSNode >> parent [
	^ parent
]

{ #category : #rendering }
WTSNode >> performGpuStateUpdateWithCamera: aCamera [
]

{ #category : #adding }
WTSNode >> removeChild: node [
	children remove: node.
	node removedFromNode: self.
	self increaseModificationCount.
]

{ #category : #adding }
WTSNode >> removeFromScene [
	parent ifNotNil: [ parent removeChild: self ] ifNil: [ scene ifNotNil: [ scene remove: self ] ]
]

{ #category : #adding }
WTSNode >> removedFromNode: oldParentNode [
	scene ifNotNil: [ self removedFromScene: scene ].
	parent := nil.
]

{ #category : #adding }
WTSNode >> removedFromScene: Scene [
	scene := nil.
	children do: [ :child | child removedFromScene: scene ].
]

{ #category : #accessing }
WTSNode >> renderModificationCountFor: mode submode: submode [
	^ 0
]

{ #category : #rendering }
WTSNode >> renderOn: stateTracker [
	"Nothing to do by default"
]

{ #category : #rendering }
WTSNode >> renderOn: commandList mode: renderMode submode: submode [
	"Nothing to do by default"
]

{ #category : #accessing }
WTSNode >> renderPriority [
	^ RenderPriorityDefault
]

{ #category : #accessing }
WTSNode >> renderTransform [
	^ renderTransform
]

{ #category : #accessing }
WTSNode >> scene [
	^ scene
]

{ #category : #changing }
WTSNode >> stateChanged [
	stateChangeListeners ifNotNil: [ stateChangeListeners do: [ :handler | handler value: self ] ].
]

{ #category : #accessing }
WTSNode >> transform [
	^ transform
]

{ #category : #accessing }
WTSNode >> transform: aTransform [
	transform := aTransform asWMReversibleAffineTransformF.
	self stateChanged
]

{ #category : #'as yet unclassified' }
WTSNode >> updateGpuStateForFrame: frameIndex camera: currentCamera [
	frameIndex = lastUpdatedGpuFrame ifTrue: [ ^ self ].
	lastUpdatedGpuFrame := frameIndex.
	parent ifNotNil: [ parent updateGpuStateForFrame: frameIndex camera: currentCamera ].
	self
		updateRenderTransform;
		performGpuStateUpdateWithCamera: currentCamera.

]

{ #category : #accessing }
WTSNode >> updateRenderTransform [
	parent ifNotNil: [
		renderTransform := parent renderTransform transformTransform: transform.
	] ifNil: [
		renderTransform := transform.
	].

]

{ #category : #accessing }
WTSNode >> updatedPerFrame [
	^ updatedPerFrame
]

{ #category : #accessing }
WTSNode >> updatedPerFrame: anObject [
	updatedPerFrame := anObject
]

{ #category : #accessing }
WTSNode >> useViewportCamera [
	^ useViewportCamera
]

{ #category : #accessing }
WTSNode >> useViewportCamera: anObject [
	useViewportCamera := anObject
]

{ #category : #accessing }
WTSNode >> visible [
	^ visible
]

{ #category : #accessing }
WTSNode >> visible: anObject [
	visible := anObject
]
