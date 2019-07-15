Class {
	#name : #WDESCameraSceneNodeComponent,
	#superclass : #WDESAbstractSceneNodeComponent,
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #'as yet unclassified' }
WDESCameraSceneNodeComponent >> applyActiveNearFarDistance [
	sceneNode ifNotNil: [ 
		sceneNode
			nearDistance: self currentNearDistance;
			farDistance: self currentFarDistance
	]
]

{ #category : #accessing }
WDESCameraSceneNodeComponent >> createSceneNode [
	^ WDSGCamera new
]

{ #category : #'as yet unclassified' }
WDESCameraSceneNodeComponent >> currentFarDistance [
	^ (ownerEntity ifNotNil: [ownerEntity sector defaultCameraFarDistance]) ifNil: [1000.0]
]

{ #category : #'as yet unclassified' }
WDESCameraSceneNodeComponent >> currentNearDistance [
	^ (ownerEntity ifNotNil: [ownerEntity sector defaultCameraNearDistance]) ifNil: [0.01]
]

{ #category : #testing }
WDESCameraSceneNodeComponent >> isCameraSceneNodeComponent [
	^ true
]
