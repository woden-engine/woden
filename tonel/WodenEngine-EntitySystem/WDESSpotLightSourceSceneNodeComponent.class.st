Class {
	#name : #WDESSpotLightSourceSceneNodeComponent,
	#superclass : #WDESPointLightSourceSceneNodeComponent,
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #accessing }
WDESSpotLightSourceSceneNodeComponent >> createSceneNode [
	^ super createSceneNode
		spot;
		yourself
]
