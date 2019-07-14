Class {
	#name : #WDESCameraSceneNodeComponent,
	#superclass : #WDESAbstractSceneNodeComponent,
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #accessing }
WDESCameraSceneNodeComponent >> createSceneNode [
	^ WDSGCamera new
]

{ #category : #testing }
WDESCameraSceneNodeComponent >> isCameraSceneNodeComponent [
	^ true
]
