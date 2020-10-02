Class {
	#name : #RWElement,
	#superclass : #RWAnnounceableObject,
	#traits : 'TWDCTransformationManipulationMethods',
	#classTraits : 'TWDCTransformationManipulationMethods classTrait',
	#instVars : [
		'shape',
		'model',
		'sceneNode',
		'renderable',
		'mass',
		'rigidBody',
		'connectedEdges',
		'view',
		'behaviors',
		'localBoundingBox',
		'boundingBox',
		'color',
		'id'
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
]

{ #category : #adding }
RWElement >> addConnectedEdge: anEdge [
	self assert: anEdge isEdge.
	self connectedEdges add: anEdge
]

{ #category : #interaction }
RWElement >> addInteraction: anInteraction [
	anInteraction installOnElement: self
]

{ #category : #adding }
RWElement >> addedIn: aView [
	renderable := shape buildRenderableFor: self view: aView parentSceneNode: sceneNode.
	self buildRigidBodyForView: aView.

	view := aView.
	id ifNotNil: [ view element: self idChangedFrom: nil into: id ]
]

{ #category : #interaction }
RWElement >> announce: eventOrClassEvent [
	announcer announce: eventOrClassEvent
]

{ #category : #converting }
RWElement >> asSceneNode [
	^ sceneNode
]

{ #category : #anchors }
RWElement >> bottomAnchorPoint [
	^ RWElementBottomAnchorPoint for: self
]

{ #category : #accessing }
RWElement >> boundingBox [
	^ boundingBox ifNil: [boundingBox := self localBoundingBox transformedWith: sceneNode transform ]
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
	connectedEdges ifNil: [ connectedEdges := RWGroup new ].
	^ connectedEdges
]

{ #category : #initialization }
RWElement >> createSceneNode [
	^ WDSGSpatialObject new
]

{ #category : #accessing }
RWElement >> depth [
	^ shape depthFor: self
]

{ #category : #accessing }
RWElement >> extent [
	^ Float32x3 x: self width asFloat y: self height asFloat z: self depth asFloat
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
	sceneNode := self createSceneNode.
	shape := RWNullShape new.
	color := Float32x4 x: 1.0 y: 1.0 z: 1.0 w: 1.0.
]

{ #category : #'as yet unclassified' }
RWElement >> interactions [
	^ self attributeAt: #interactions ifAbsentPut: [ OrderedCollection new ]
]

{ #category : #updating }
RWElement >> invalidateBoundingBoxCache [
	localBoundingBox := nil.
	boundingBox := nil
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

{ #category : #accessing }
RWElement >> orientation [
	^ sceneNode transform matrix
]

{ #category : #accessing }
RWElement >> orientation: anOrientation [
	self notifyConnectedEdges.
	self invalidateBoundingBoxCache.
	sceneNode transform orthonormal: anOrientation asFloat32x3x3.
	sceneNode transformChanged.
]

{ #category : #accessing }
RWElement >> orientationMatrix [
	^ sceneNode transform matrix
]

{ #category : #accessing }
RWElement >> position [
	^ sceneNode position
]

{ #category : #accessing }
RWElement >> position: aPosition [
	self invalidateBoundingBoxCache.
	^ sceneNode position: aPosition
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
	"Remove the element from the view it is contained in. Sending #remove to an element has the effect of making it diseapper from the screen. The Virtual Buffer are also correctly updated"
    self view removeElement: self.
    sceneNode removeFromScene.
    view signalUpdate.
]

{ #category : #accessing }
RWElement >> renderable [
	^ renderable 
]

{ #category : #adding }
RWElement >> replaceSceneNode: newNode [
	newNode transform: sceneNode transform.
	sceneNode := newNode.
]

{ #category : #physics }
RWElement >> rigidBody [
	^ rigidBody
]

{ #category : #orientation }
RWElement >> rotateByX: angle [
	sceneNode rotateRadiansOnX: angle.
	self invalidateBoundingBoxCache.
]

{ #category : #orientation }
RWElement >> rotateByXDegrees: angle [
	sceneNode rotateDegreesOnX: angle.
	self invalidateBoundingBoxCache.
]

{ #category : #orientation }
RWElement >> rotateByY: angle [
	sceneNode rotateRadiansOnY: angle.
	self invalidateBoundingBoxCache.
]

{ #category : #orientation }
RWElement >> rotateByYDegrees: angle [
	sceneNode rotateDegreesOnY: angle.
	self invalidateBoundingBoxCache.
]

{ #category : #orientation }
RWElement >> rotateByZ: angle [
	sceneNode rotateRadiansOnZ: angle.
	self invalidateBoundingBoxCache.
]

{ #category : #orientation }
RWElement >> rotateByZDegrees: angle [
	sceneNode rotateDegreesOnZ: angle.
	self invalidateBoundingBoxCache.
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
RWElement >> transform [
	^ sceneNode transform
]

{ #category : #accessing }
RWElement >> transform: aTransform [
	self notifyConnectedEdges.
	self invalidateBoundingBoxCache.
	sceneNode transform: aTransform
]

{ #category : #translation }
RWElement >> translateBy: translation [
	sceneNode translateBy: translation.
	self notifyConnectedEdges.
	self invalidateBoundingBoxCache.
]

{ #category : #translation }
RWElement >> translateTo: aWMVector3 [
	sceneNode translateTo: aWMVector3.
	self notifyConnectedEdges.
	self invalidateBoundingBoxCache.
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

{ #category : #physics }
RWElement >> wall [
	mass := 0.0
]

{ #category : #accessing }
RWElement >> width [
	^ shape widthFor: self
]
