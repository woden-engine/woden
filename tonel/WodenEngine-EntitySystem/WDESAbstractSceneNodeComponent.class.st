Class {
	#name : #WDESAbstractSceneNodeComponent,
	#superclass : #WDESComponentWithShape,
	#instVars : [
		'sceneNode'
	],
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #accessing }
WDESAbstractSceneNodeComponent >> addedToScene: scene [
	ownerEntity validSceneNode addChild: self validSceneNode
]

{ #category : #accessing }
WDESAbstractSceneNodeComponent >> createSceneNode [
	| node |
	node := WDSGSpatialObject new.
	node renderable: self renderable.
	^ node
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
