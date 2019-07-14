Class {
	#name : #WDESDirectionalLightSourceSceneNodeComponent,
	#superclass : #WDESLightSourceSceneNodeComponent,
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #accessing }
WDESDirectionalLightSourceSceneNodeComponent >> createSceneNode [
	^ super createSceneNode
		directional;
		yourself
]
