Class {
	#name : #WDESPointLightSourceSceneNodeComponent,
	#superclass : #WDESLightSourceSceneNodeComponent,
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #accessing }
WDESPointLightSourceSceneNodeComponent >> createSceneNode [
	^ super createSceneNode
		point;
		yourself
]
