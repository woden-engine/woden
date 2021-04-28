Class {
	#name : #RWElement,
	#superclass : #RWNode,
	#traits : 'TRWInteractableObject',
	#classTraits : 'TRWInteractableObject classTrait',
	#instVars : [
		'shape',
		'model',
		'renderable',
		'mass',
		'rigidBody',
		'connectedEdges',
		'behaviors',
		'color',
		'id',
		'isTickingElement'
	],
	#category : #'WodenEngine-Roassal-Core'
}

{ #category : #'instance creation' }
RWElement class >> on: anObject [

	^ self new model: anObject; yourself
]

{ #category : #interaction }
RWElement >> @ anInteractionClassOrInstance [
	"Add an interaction to the node"
	
	self addInteraction: anInteractionClassOrInstance
]

{ #category : #visiting }
RWElement >> accept: aVisitor [
	^ aVisitor visitElement: self
]

{ #category : #adding }
RWElement >> addBehavior: aBehavior [
	| behaviorObject |
	behaviorObject := aBehavior asRWElementBehavior.
	behaviors add: behaviorObject.
	behaviorObject addedInElement: self.
	self ensureIsTickingElement.
]

{ #category : #adding }
RWElement >> addConnectedEdge: anEdge [
	self assert: anEdge isEdge.
	self connectedEdges add: anEdge
]

{ #category : #adding }
RWElement >> addedInView: aView [
	super addedInView: aView.
	renderable := shape buildRenderableFor: self view: aView.
	self setRenderableInDefaultNode.
	self buildRigidBodyForView: aView.

	id ifNotNil: [ view element: self idChangedFrom: nil into: id ].
	isTickingElement ifTrue: [ view addTickingElement: self ].
]

{ #category : #interaction }
RWElement >> announce: eventOrClassEvent [
	announcer announce: eventOrClassEvent
]

{ #category : #accessing }
RWElement >> area [
	^ shape areaFor: self
]

{ #category : #anchors }
RWElement >> bottomAnchorPoint [
	^ RWElementBottomAnchorPoint for: self
]

{ #category : #physics }
RWElement >> buildRigidBodyForView: aView [
	| collisionShape |
	mass ifNil: [ ^ self ].
	collisionShape := shape buildCollisionShapeFor: self.
	rigidBody := WDPhyRigidBody new
					sceneNode: sceneNode;
					mass: mass;
					shape: collisionShape.
	aView addRigidBody: rigidBody
]

{ #category : #anchors }
RWElement >> centerAnchorPoint [
	^ RWElementCenterAnchorPoint for: self
]

{ #category : #updating }
RWElement >> changed [
	self colorChanged.
	shape changedElement: self sceneNode: sceneNode renderable: renderable.
	sceneNode stateChanged.
	self invalidateBoundingBoxCache.
	self notifyConnectedEdges.
]

{ #category : #accessing }
RWElement >> color [
	^ color
]

{ #category : #accessing }
RWElement >> color: aColor [
	color := aColor.
	self colorChanged.
]

{ #category : #updating }
RWElement >> colorChanged [
	sceneNode isSpatialObject ifTrue: [
		sceneNode color: self colorUsedForRendering.
		sceneNode stateChanged
	].

]

{ #category : #updating }
RWElement >> colorUsedForRendering [
	^ color asFloat32x4 * (shape colorFor: self) asFloat32x4
]

{ #category : #'accessing - edges' }
RWElement >> connectedEdges [
	"Return the list of connected egdes (i.e., incoming and outgoing edges)"
	connectedEdges ifNil: [ connectedEdges := RWElementList new ].
	^ connectedEdges
]

{ #category : #accessing }
RWElement >> depth [
	^ shape depthFor: self
]

{ #category : #'as yet unclassified' }
RWElement >> ensureIsTickingElement [
	isTickingElement ifTrue: [ ^ self ].
	isTickingElement := true.
	view ifNotNil: [ view addTickingElement: self ]
]

{ #category : #accessing }
RWElement >> extent [
	^ Float32x3 x: self width asFloat y: self height asFloat z: self depth asFloat
]

{ #category : #'ray casting' }
RWElement >> findElementsIntersectingSphereVolume: sphere into: result [
	| worldBoundingBox |
	worldBoundingBox := self boundingBox.
	worldBoundingBox isEmpty ifTrue: [ ^ self ].
	
	(worldBoundingBox hasIntersectionWithSphere: sphere) ifFalse: [ ^ self ].
	result add: self
]

{ #category : #'ray casting' }
RWElement >> findElementsIntersectingSphereVolume: sphere transformedWith: sphereTransform [
	| worldBoundingBox |
	worldBoundingBox := self boundingBox.
	worldBoundingBox isEmpty ifTrue: [ ^ self ].
	
	(self hasIntersectionWithSphere: sphere transformedWith: sphereTransform) ifFalse: [ ^ self ].
	sphereTransform 
]

{ #category : #accessing }
RWElement >> height [
	^ shape heightFor: self
]

{ #category : #accessing }
RWElement >> id [
	^ id
]

{ #category : #accessing }
RWElement >> id: anObject [
	| oldID |
	oldID := id.
	id := anObject.
	view ifNotNil: [
		view element: self idChangedFrom: oldID into: id
	]
	
]

{ #category : #'accessing - edges' }
RWElement >> incomingEdges [
	"Return the list of incoming edges from the node"
	connectedEdges ifNil: [ ^ #() ].
	^ self connectedEdges select: [ :e | e to == self ]
]

{ #category : #initialization }
RWElement >> initialize [
	super initialize.
	behaviors := OrderedCollection new.
	shape := RWNullShape new.
	color := Float32x4 x: 1.0 y: 1.0 z: 1.0 w: 1.0.
	isTickingElement := false.
]

{ #category : #testing }
RWElement >> isConnectedTo: anElement [
	connectedEdges ifNil: [ ^ false ].
	^ connectedEdges anySatisfy: [ :edge | (edge from == anElement) or: [ edge to == anElement ] ]
]

{ #category : #testing }
RWElement >> isDirectlyConnectedTo: anElement [
	connectedEdges ifNil: [ ^ false ].
	^ connectedEdges anySatisfy: [ :edge | edge to == anElement ]
]

{ #category : #testing }
RWElement >> isEdge [
	^ false
]

{ #category : #testing }
RWElement >> isElement [
	^ true
]

{ #category : #testing }
RWElement >> isRWElement [
	^ true
]

{ #category : #accessing }
RWElement >> localBoundingBox [
	^ localBoundingBox ifNil: [ localBoundingBox := shape boundingBoxFor: self ]
]

{ #category : #orientation }
RWElement >> lookDown [
	sceneNode transform orthonormal: (Float32x3x3 xRotation: Float halfPi negated ).
	sceneNode transformChanged.
	self invalidateBoundingBoxCache.
]

{ #category : #physics }
RWElement >> mass [
	^ mass
]

{ #category : #physics }
RWElement >> mass: aNumber [
	mass := aNumber asFloat
]

{ #category : #accessing }
RWElement >> model [
	^ model
]

{ #category : #accessing }
RWElement >> model: anObject [
	model := anObject
]

{ #category : #updating }
RWElement >> notifyConnectedEdges [
	connectedEdges ifNil: [ ^ nil ].
	connectedEdges do: [ :edge | edge connectedElementChanged: self ]
]

{ #category : #'ray casting' }
RWElement >> rayCast: ray [
	| worldBoundingBox distance |
	worldBoundingBox := self boundingBox.
	worldBoundingBox isEmpty ifTrue: [ ^ 0 -> nil ].
	
	distance := worldBoundingBox intersectionWithRay: ray.
	(distance isNil or: [distance <= 0]) ifTrue: [ ^ distance -> nil ].
	^ distance -> self.
]

{ #category : #adding }
RWElement >> remove [
	parentGroup ifNil: [ ^ self ].
	parentGroup removeChild: self.

]

{ #category : #'as yet unclassified' }
RWElement >> removedFromView: aView [
	sceneNode removeFromScene.
	isTickingElement ifTrue: [ aView removeTickingElement: self ].
	super removedFromView: aView.
]

{ #category : #accessing }
RWElement >> renderable [
	^ renderable 
]

{ #category : #adding }
RWElement >> replaceSceneNode: newNode [
	newNode transform: sceneNode transform.
	sceneNode removeFromScene.
	sceneNode := newNode.
]

{ #category : #physics }
RWElement >> rigidBody [
	^ rigidBody
]

{ #category : #accessing }
RWElement >> sceneNode [
	^ sceneNode
]

{ #category : #adding }
RWElement >> setBehavior: aBehavior [
	behaviors removeAll.
	self addBehavior: aBehavior
]

{ #category : #initialization }
RWElement >> setRenderableInDefaultNode [
	sceneNode isLocalSpatialNode ifTrue: [^ self].
	(renderable isNotNil and: [sceneNode isSpatialObject ]) ifTrue: [ 
		sceneNode renderable: renderable. 
	].
	sceneNode isSpatialObject ifTrue: [ 
		sceneNode color: (shape colorFor: self)
	].

	parentGroup asSceneNode addChild: sceneNode.

]

{ #category : #accessing }
RWElement >> shape [
	^ shape
]

{ #category : #accessing }
RWElement >> shape: aShape [
	"
	Set the shape of the element
	
	:: RWShape -> RWElement
	"
	shape := aShape
]

{ #category : #'trachel compatibility' }
RWElement >> signalUpdate [
	"do nothing"
	self changed
]

{ #category : #updating }
RWElement >> simulateTime: delta [
	behaviors do: [ :behavior | behavior simulateTime: delta onElement: self]
]

{ #category : #anchors }
RWElement >> topAnchorPoint [
	^ RWElementTopAnchorPoint for: self
]

{ #category : #'trachel compatibility' }
RWElement >> trachelShape [
	"Compatibility layer"
	^ self
]

{ #category : #accessing }
RWElement >> transformChanged [
	super transformChanged.
	self notifyConnectedEdges.
]

{ #category : #accessing }
RWElement >> validId [
	id ifNil: [
		view generateIdForElement: self
	].
	^ id
]

{ #category : #accessing }
RWElement >> view [
	^ view
]

{ #category : #accessing }
RWElement >> volume [
	^ shape volumeFor: self
]

{ #category : #physics }
RWElement >> wall [
	mass := 0.0
]

{ #category : #accessing }
RWElement >> width [
	^ shape widthFor: self
]
