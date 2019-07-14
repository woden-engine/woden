Class {
	#name : #WDESAbstractSceneNodeComponent,
	#superclass : #WDESComponentWithShape,
	#instVars : [
		'sceneNode',
		'localTransform'
	],
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #accessing }
WDESAbstractSceneNodeComponent >> addedToScene: scene [
	ownerEntity validSceneNode addChild: self validSceneNode.
	sceneNode transform: localTransform.
]

{ #category : #accessing }
WDESAbstractSceneNodeComponent >> createSceneNode [
	| node |
	node := WDSGSpatialObject new.
	node renderable: self renderable.
	^ node
]

{ #category : #initialization }
WDESAbstractSceneNodeComponent >> initialize [
	super initialize.
	localTransform := WMReversibleAffineTransformF identity.
]

{ #category : #accessing }
WDESAbstractSceneNodeComponent >> localTransform [
	^ localTransform
]

{ #category : #accessing }
WDESAbstractSceneNodeComponent >> localTransform: anObject [
	localTransform := anObject asWMReversibleAffineTransformF copy.
	self localTransformChanged.
]

{ #category : #initialization }
WDESAbstractSceneNodeComponent >> localTransformChanged [
	sceneNode ifNotNil: [ sceneNode localTransform: localTransform ]
]

{ #category : #initialization }
WDESAbstractSceneNodeComponent >> position: aPosition [
	localTransform translation: aPosition.
	self localTransformChanged.
]

{ #category : #accessing }
WDESAbstractSceneNodeComponent >> removedFromScene: scene [
	sceneNode ifNotNil: [ sceneNode removeFromScene ]
]

{ #category : #accessing }
WDESAbstractSceneNodeComponent >> renderable [
	self subclassResponsibility
]

{ #category : #accessing }
WDESAbstractSceneNodeComponent >> validSceneNode [
	^ sceneNode ifNil: [ sceneNode := self createSceneNode ]
]
