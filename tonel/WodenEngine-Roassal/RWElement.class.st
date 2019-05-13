Class {
	#name : #RWElement,
	#superclass : #RWAnnounceableObject,
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
		'color'
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
	behaviors add: aBehavior.
	aBehavior addedInElement: self.
]

{ #category : #adding }
RWElement >> addConnectedEdge: anEdge [
	self assert: anEdge isEdge.
	self connectedEdges add: anEdge
]

{ #category : #interaction }
RWElement >> addInteraction: anInteraction [
	anInteraction initializeElement: self
]

{ #category : #adding }
RWElement >> addedIn: aView [
	renderable := shape buildRenderableFor: self view: aView.
	sceneNode isLocalSpatialNode ifFalse: [
		self flag: 'TODO: Refactor this part'.
		(renderable isNotNil and: [sceneNode isSpatialObject ]) ifTrue: [ 
			sceneNode renderable: renderable. 
		].
		sceneNode isSpatialObject ifTrue: [ 
			sceneNode color: (shape colorFor: self)
		].
	
		aView validScene add: sceneNode.
	].

	self buildRigidBodyForView: aView.

	view := aView
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
	^ color asWMVector4F * (shape colorFor: self) asWMVector4F
]

{ #category : #accessing }
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
	^ WMVector3F x: self width asFloat y: self height asFloat z: self depth asFloat
]

{ #category : #accessing }
RWElement >> height [
	^ shape heightFor: self
]

{ #category : #initialization }
RWElement >> initialize [
	super initialize.
	behaviors := OrderedCollection new.
	sceneNode := self createSceneNode.
	shape := RWNullShape new.
	color := WMVector4F x: 1.0 y: 1.0 z: 1.0 w: 1.0.
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

{ #category : #accessing }
RWElement >> localBoundingBox [
	^ localBoundingBox ifNil: [ localBoundingBox := shape boundingBoxFor: self ]
]

{ #category : #orientation }
RWElement >> lookDown [
	sceneNode transform orthonormal: (WMMatrix3F xrot: Float halfPi negated ).
	sceneNode stateChanged.
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
	sceneNode transform orthonormal: anOrientation asWMMatrix3F
]

{ #category : #accessing }
RWElement >> orientationMatrix [
	^ sceneNode transform matrix
]

{ #category : #accessing }
RWElement >> position [
	^ sceneNode transform translation
]

{ #category : #accessing }
RWElement >> position: aPosition [
	self invalidateBoundingBoxCache.
	^ sceneNode transform translation: aPosition
]

{ #category : #'ray casting' }
RWElement >> rayCast: ray [
	| worldBoundingBox distance |
	worldBoundingBox := self boundingBox.
	worldBoundingBox isEmpty ifTrue: [ ^ 0 -> nil ].
	
	distance := ray intersectionDistanceWithBox: worldBoundingBox.
	(distance isNil or: [distance < 0]) ifTrue: [ ^ distance -> nil ].
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
	sceneNode transform rotateRadiansOnX: angle.
	sceneNode stateChanged.
	self invalidateBoundingBoxCache.
]

{ #category : #orientation }
RWElement >> rotateByXDegrees: angle [
	sceneNode transform rotateDegreesOnX: angle.
	sceneNode stateChanged.
	self invalidateBoundingBoxCache.
]

{ #category : #orientation }
RWElement >> rotateByY: angle [
	sceneNode transform rotateRadiansOnY: angle.
	sceneNode stateChanged.
	self invalidateBoundingBoxCache.
]

{ #category : #orientation }
RWElement >> rotateByYDegrees: angle [
	sceneNode transform rotateDegreesOnY: angle.
	sceneNode stateChanged.
	self invalidateBoundingBoxCache.
]

{ #category : #orientation }
RWElement >> rotateByZ: angle [
	sceneNode transform rotateRadiansOnZ: angle.
	sceneNode stateChanged.
	self invalidateBoundingBoxCache.
]

{ #category : #orientation }
RWElement >> rotateByZDegrees: angle [
	sceneNode transform rotateDegreesOnZ: angle.
	sceneNode stateChanged.
	self invalidateBoundingBoxCache.
]

{ #category : #accessing }
RWElement >> sceneNode [
	^ sceneNode
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

{ #category : #translation }
RWElement >> translateBy: translation [
	sceneNode transform translateBy: translation.
	sceneNode stateChanged.
	self notifyConnectedEdges.
	self invalidateBoundingBoxCache.
]

{ #category : #translation }
RWElement >> translateByX: translation [
	self translateBy: (WMVector3F new x: translation)
]

{ #category : #translation }
RWElement >> translateByX: x y: y z: z [
	self translateBy: (WMVector3F x: x y: y z: z)
]

{ #category : #translation }
RWElement >> translateByY: translation [
	self translateBy: (WMVector3F new y: translation)
]

{ #category : #translation }
RWElement >> translateByZ: translation [
	self translateBy: (WMVector3F new z: translation)
]

{ #category : #translation }
RWElement >> translateTo: aWMVector3 [
	sceneNode transform translation: aWMVector3.
	sceneNode stateChanged.
	self notifyConnectedEdges.
	self invalidateBoundingBoxCache.
]

{ #category : #translation }
RWElement >> translateToX: newX [
	self translateTo: (self position x: newX)
]

{ #category : #translation }
RWElement >> translateToX: newX y: newY z: newZ [ 
	sceneNode transform translation: (WMVector3F x: newX asFloat y: newY asFloat z: newZ asFloat).
	sceneNode stateChanged.
	self invalidateBoundingBoxCache.
]

{ #category : #translation }
RWElement >> translateToY: newY [
	self translateTo: (self position y: newY)
]

{ #category : #translation }
RWElement >> translateToZ: newZ [
	self translateTo: (self position z: newZ)
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
