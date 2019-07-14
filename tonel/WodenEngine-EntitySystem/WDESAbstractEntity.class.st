Class {
	#name : #WDESAbstractEntity,
	#superclass : #WDESNode,
	#instVars : [
		'parent',
		'children',
		'components',
		'tickingComponents'
	],
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #adding }
WDESAbstractEntity >> addChild: aChild [
	self assert: aChild parent isNil.
	children add: aChild.
	aChild parent: self.
	
	aChild addedToEntity: self.
]

{ #category : #adding }
WDESAbstractEntity >> addComponent: aComponent [
	self assert: aComponent ownerEntity isNil.
	components add: aComponent.
	aComponent ownerEntity: self.

	self scene ifNotNil: [ :scene | aComponent addedToScene: scene ].
	self physicsWorld ifNotNil: [ :physicsWorld | aComponent addedToPhysicsWorld: physicsWorld ]	.
	aComponent isTickingComponent ifTrue: [ 
		tickingComponents := tickingComponents copyWith: aComponent.
		self sector ifNotNil: [ :sector | sector addTickingEntity: self ]
	].

]

{ #category : #adding }
WDESAbstractEntity >> addedToEntity: parentEntity [
	self scene ifNotNil: [ :scene | self addedToScene: scene ].
	self physicsWorld ifNotNil: [ :physicsWorld | self addedToPhysicsWorld: physicsWorld ].
	self sector ifNotNil: [ :sector |
		self isTicking ifTrue: [ sector addTickingEntity: self ]
	]
]

{ #category : #scene }
WDESAbstractEntity >> addedToPhysicsWorld: aPhysicsWorld [
	components do: [ :comp | comp addedToPhysicsWorld: aPhysicsWorld ].
	children do: [ :child | child addedToPhysicsWorld: aPhysicsWorld ].
]

{ #category : #scene }
WDESAbstractEntity >> addedToScene: anScene [
	components do: [ :comp | comp addedToScene: anScene ].
	children do: [ :child | child addedToScene: anScene ].
]

{ #category : #accessing }
WDESAbstractEntity >> children [
	^ children
]

{ #category : #accessing }
WDESAbstractEntity >> engine [
	^ parent ifNotNil: [parent engine]
]

{ #category : #accessing }
WDESAbstractEntity >> engineChanged [
	children do: #engineChanged.
]

{ #category : #queries }
WDESAbstractEntity >> findAnyEntityByTypeName: aTypeName [
	self typeName == aTypeName ifTrue: [ ^ self ].
	children do: [ :child |
		(child findAnyEntityByTypeName: aTypeName) ifNotNil: [ :found | ^ found ]
	].

	^ nil
]

{ #category : #queries }
WDESAbstractEntity >> findCameraSceneNodeComponentOrNil [
	^ self findComponentOrNilWith: #isCameraSceneNodeComponent
]

{ #category : #queries }
WDESAbstractEntity >> findCharacterBehaviorComponentOrNil [
	^ self findComponentOrNilWith: #isCharacterBehaviorComponent
]

{ #category : #queries }
WDESAbstractEntity >> findComponentOrNilWith: aBlock [
	components do: [ :comp |
		(aBlock value: comp) ifTrue: [ ^ comp ]
	].

	^ nil
]

{ #category : #'as yet unclassified' }
WDESAbstractEntity >> globalTransform [
	^ parent ifNotNil: [ parent globalTransform transformTransform: self transform ]
		ifNil: [ self transform ]
		
]

{ #category : #initialization }
WDESAbstractEntity >> initialize [
	super initialize.
	children := OrderedCollection new.
	components := OrderedCollection new.
	tickingComponents := #().
]

{ #category : #testing }
WDESAbstractEntity >> isPointEntity [
	^ false
]

{ #category : #testing }
WDESAbstractEntity >> isTicking [
	^ tickingComponents isNotEmpty
]

{ #category : #accessing }
WDESAbstractEntity >> parent [
	^ parent
]

{ #category : #accessing }
WDESAbstractEntity >> parent: anObject [
	parent := anObject
]

{ #category : #accessing }
WDESAbstractEntity >> physicsWorld [
	^ parent ifNotNil: [ parent physicsWorld ]
]

{ #category : #accessing }
WDESAbstractEntity >> physicsWorldObject [
	^ nil
]

{ #category : #adding }
WDESAbstractEntity >> removeChild: aChild [
	self assert: aChild parent == self.
	children remove: aChild.
	aChild removedFromEntity: self.
	aChild parent: nil.

]

{ #category : #adding }
WDESAbstractEntity >> removeComponent: aComponent [
	self assert: aComponent ownerEntity == self.
	components remove: aComponent.
	aComponent ownerEntity: nil.
	aComponent isTickingComponent ifTrue: [ 
		tickingComponents := tickingComponents copyWithout: aComponent.
		tickingComponents ifEmpty: [ 
			self sector ifNotNil: [ :sector | sector removeTickingEntity: self ]
		].
	].

	self scene ifNotNil: [ :scene | aComponent removedFromScene: scene ].
	self physicsWorld ifNotNil: [ :physicsWorld | aComponent removedFromPhysicsWorld: physicsWorld ].

]

{ #category : #adding }
WDESAbstractEntity >> removedFromEntity: parentEntity [
	self scene ifNotNil: [ :scene | self removedFromScene: scene ].
	self physicsWorld ifNotNil: [ :physicsWorld | self removedFromPhysicsWorld: physicsWorld ].
	self sector ifNotNil: [ :sector |
		self isTicking ifTrue: [ sector removeTickingEntity: self ]
	]
]

{ #category : #scene }
WDESAbstractEntity >> removedFromPhysicsWorld: aPhysicsWorld [
	components do: [ :comp | comp removedFromPhysicsWorld: aPhysicsWorld ].
	children do: [ :child | child removedFromPhysicsWorld: aPhysicsWorld ].
]

{ #category : #scene }
WDESAbstractEntity >> removedFromScene: anScene [
	components do: [ :comp | comp removedFromScene: anScene ].
	children do: [ :child | child removedFromScene: anScene ].
]

{ #category : #accessing }
WDESAbstractEntity >> scene [
	^ parent ifNotNil: [ parent scene ]
]

{ #category : #accessing }
WDESAbstractEntity >> sceneNode [
	^ nil
]

{ #category : #accessing }
WDESAbstractEntity >> sector [
	^ parent ifNotNil: [ parent sector ]
]

{ #category : #'as yet unclassified' }
WDESAbstractEntity >> sectorTransform [
	^ parent ifNotNil: [ parent sectorTransform transformTransform: self transform ]
		ifNil: [ self transform ]
		
]

{ #category : #messages }
WDESAbstractEntity >> sendInputEvent: inputEventSelector with: anEvent [
	components do: [ :comp |
		comp isBehaviorComponent ifTrue: [
			comp sendInputEvent: inputEventSelector with: anEvent
		].
	]
]

{ #category : #simulation }
WDESAbstractEntity >> tick: delta [
	tickingComponents do: [ :comp | comp tick: delta ]
]

{ #category : #transforming }
WDESAbstractEntity >> transform [
	^ WMReversibleAffineTransformF identity
]

{ #category : #accessing }
WDESAbstractEntity >> typeName [
	^ nil
]

{ #category : #accessing }
WDESAbstractEntity >> universe [
	^ parent ifNotNil: [ parent universe ]
]
