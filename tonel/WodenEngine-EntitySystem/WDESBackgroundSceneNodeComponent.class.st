Class {
	#name : #WDESBackgroundSceneNodeComponent,
	#superclass : #WDESAbstractSceneNodeComponent,
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #accessing }
WDESBackgroundSceneNodeComponent >> addedToScene: scene [
	ownerEntity validSceneNode scene addBackground: self validSceneNode.
	sceneNode transform: localTransform.
]
