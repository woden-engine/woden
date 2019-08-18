"
I represent a node in the Woden scene graph.
"
Class {
	#name : #WDSGNode,
	#superclass : #WDCAbstractSceneNode,
	#traits : 'TWDCTransformationManipulationMethods',
	#classTraits : 'TWDCTransformationManipulationMethods classTrait',
	#instVars : [
		'name',
		'scene',
		'transform',
		'children',
		'visible',
		'parent',
		'globalTransform',
		'model',
		'stateChangeListeners',
		'globalBoundingBox',
		'globalOrientedBoundingBox'
	],
	#category : #'WodenEngine-Scene-Graph'
}

{ #category : #adding }
WDSGNode >> addChild: aChild [
	children add: aChild.
	aChild addedToNode: self.
]

{ #category : #adding }
WDSGNode >> addedToNode: newParentNode [
	parent := newParentNode.
	newParentNode scene ifNotNil: [ self addedToScene: newParentNode scene ].

]

{ #category : #adding }
WDSGNode >> addedToScene: aScene [
	| oldEngine newEngine |
	oldEngine := self engine.
	self assert: scene isNil.
	scene := aScene.
	newEngine := self engine.
	oldEngine ~~ newEngine ifTrue: [ self engineChanged ].
	self sceneLayer addRenderingRenderables: self renderingRenderables.
	children do: [ :child | child addedToScene: scene ].
]

{ #category : #converting }
WDSGNode >> asSceneNode [
	^ self
]

{ #category : #'rendering phases' }
WDSGNode >> bakeLazyObjectStates [
]

{ #category : #testing }
WDSGNode >> canBeRendered [
	^ false
]

{ #category : #caching }
WDSGNode >> childTransformChanged: aChild [
	aChild countedForBoundingBox ifFalse: [ ^ self ].
	
	globalBoundingBox := nil.
	globalOrientedBoundingBox := nil.
	parent ifNotNil: [ parent childTransformChanged: self ].
]

{ #category : #accessing }
WDSGNode >> children [
	^ children
]

{ #category : #enumerating }
WDSGNode >> childrenDo: aBlock [
	children do: aBlock
]

{ #category : #accessing }
WDSGNode >> computeGlobalOrientedBoundingBox [
	| result |
	result := self localBoundingBox copy.
	self childrenDo: [ :child |
		child countedForBoundingBox ifTrue: [ 
			result insertBox: child globalBoundingBox
		].
	].

	^ result
]

{ #category : #accessing }
WDSGNode >> computeGlobalTransform [
	^ parent
			ifNil: [ transform ]
			ifNotNil: [ parent globalTransform transformTransform: transform ]
]

{ #category : #copying }
WDSGNode >> copyForResourceCacheInstancing [
	^ self copy
]

{ #category : #'as yet unclassified' }
WDSGNode >> countedForBoundingBox [
	^ true
]

{ #category : #accessing }
WDSGNode >> depthSorted: aBoolean [
]

{ #category : #accessing }
WDSGNode >> engine [
	^ scene ifNotNil: [scene engine]
]

{ #category : #adding }
WDSGNode >> engineChanged [
	children do: [:child |
		child scene == scene ifTrue: [
			child engineChanged
		]
	]
]

{ #category : #'as yet unclassified' }
WDSGNode >> findChildNodeNamed: childName ifAbsent: aBlock [
	self allChildrenDo: [ :child |
		child name = childName ifTrue: [ ^ child ]
	].

	^ aBlock value
]

{ #category : #accessing }
WDSGNode >> globalBoundingBox [
	globalBoundingBox ifNil: [ globalBoundingBox := (self globalOrientedBoundingBox transformedWith: self globalTransform) ].
	^ globalBoundingBox
]

{ #category : #accessing }
WDSGNode >> globalOrientedBoundingBox [
	globalOrientedBoundingBox ifNil: [ globalOrientedBoundingBox := self computeGlobalOrientedBoundingBox ].
	^ globalOrientedBoundingBox
]

{ #category : #accessing }
WDSGNode >> globalTransform [
	globalTransform ifNil: [
		globalTransform := self computeGlobalTransform.
		self globalTransformValidated.
	].

	^ globalTransform
]

{ #category : #caching }
WDSGNode >> globalTransformValidated [
]

{ #category : #initialization }
WDSGNode >> initialize [
	super initialize.
	transform := WMReversibleAffineTransformF identity.
	globalTransform := nil.
	children := OrderedCollection new.
	visible := true.
]

{ #category : #testing }
WDSGNode >> isCamera [
	^ false
]

{ #category : #testing }
WDSGNode >> isCompositeGroup [
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
WDSGNode >> isLocalSpatialNode [
	^ false
]

{ #category : #testing }
WDSGNode >> isMultiEyeCamera [
	^ false
]

{ #category : #testing }
WDSGNode >> isOpaqueShadowCaster [
	^ false
]

{ #category : #testing }
WDSGNode >> isSpatialObject [
	^ false
]

{ #category : #'as yet unclassified' }
WDSGNode >> localBoundingBox [
	^ WMBox3DF new
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
WDSGNode >> name [
	^ name
]

{ #category : #accessing }
WDSGNode >> name: anObject [
	name := anObject
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

{ #category : #caching }
WDSGNode >> parentTransformChanged [
	self stateChanged.
	globalTransform := nil.
	globalBoundingBox := nil.
	self renderingRenderables do: #transformChanged.
	children do: [ :child | child parentTransformChanged ].

]

{ #category : #rendering }
WDSGNode >> performCommonGpuStateUpdate [
]

{ #category : #rendering }
WDSGNode >> performGpuStateUpdateWithCamera: aCamera [
]

{ #category : #accessing }
WDSGNode >> position [
	^ transform translation
]

{ #category : #accessing }
WDSGNode >> position: aPosition [
	transform translation: aPosition.
	self transformChanged
]

{ #category : #copying }
WDSGNode >> postCopy [
	| oldChildren |
	super postCopy.
	scene := nil.
	parent := nil.
	stateChangeListeners := nil.
	oldChildren := children.
	globalTransform := nil.
	children := OrderedCollection new.
	oldChildren do: [ :child |
		self addChild: child copy
	]
]

{ #category : #enumerating }
WDSGNode >> precacheResources [
]

{ #category : #adding }
WDSGNode >> removeChild: node [
	children remove: node.
	node removedFromNode: self.
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
WDSGNode >> removedFromScene: oldScene [
	oldScene removeNodeWithPendingState: self.
	scene := nil.
	children do: [ :child | child removedFromScene: oldScene ].
]

{ #category : #accessing }
WDSGNode >> renderingRenderables [
	^ #()
]

{ #category : #transforming }
WDSGNode >> rotateDegreesOnX: degrees [
	transform rotateDegreesOnX: degrees.
	self transformChanged
]

{ #category : #transforming }
WDSGNode >> rotateDegreesOnY: degrees [
	transform rotateDegreesOnY: degrees.
	self transformChanged
]

{ #category : #transforming }
WDSGNode >> rotateDegreesOnZ: degrees [
	transform rotateDegreesOnZ: degrees.
	self transformChanged
]

{ #category : #transforming }
WDSGNode >> rotateRadiansOnX: radians [
	transform rotateRadiansOnX: radians.
	self transformChanged
]

{ #category : #transforming }
WDSGNode >> rotateRadiansOnY: radians [
	transform rotateRadiansOnY: radians.
	self transformChanged
]

{ #category : #transforming }
WDSGNode >> rotateRadiansOnZ: radians [
	transform rotateRadiansOnZ: radians.
	self transformChanged
]

{ #category : #accessing }
WDSGNode >> scene [
	^ scene
]

{ #category : #accessing }
WDSGNode >> sceneLayer [
	^ parent ifNotNil: [ parent sceneLayer ]
]

{ #category : #changing }
WDSGNode >> stateChanged [
	stateChangeListeners ifNotNil: [ stateChangeListeners do: [ :handler | handler value: self ] ].
]

{ #category : #accessing }
WDSGNode >> toggleVisible [
	self visible: self visible not
]

{ #category : #accessing }
WDSGNode >> transform [
	^ transform
]

{ #category : #accessing }
WDSGNode >> transform: aTransform [
	transform := aTransform asWMReversibleAffineTransformF.
	self transformChanged
]

{ #category : #caching }
WDSGNode >> transformChanged [
	self renderingRenderables do: #transformChanged.
	parent ifNotNil: [ parent childTransformChanged: self ].
	self parentTransformChanged.
]

{ #category : #transforming }
WDSGNode >> translateBy: translation [
	transform translateBy: translation.
	self transformChanged
]

{ #category : #transforming }
WDSGNode >> translateTo: translation [
	transform translation: translation.
	self transformChanged
]

{ #category : #accessing }
WDSGNode >> visible [
	^ visible
]

{ #category : #accessing }
WDSGNode >> visible: anObject [
	visible := anObject
]
