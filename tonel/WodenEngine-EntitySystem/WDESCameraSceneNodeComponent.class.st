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
			farDistance: self currentFarDistance;
			cascadeSplitDistribution: self currentCascadeSplitDistribution;
			toneMappingOperator: self currentToneMappingOperator;
			exposure: self currentCameraExposure.
		self currentFogSettings ifNotNil: [ :settings | settings applyToNode: sceneNode  ]
	]
]

{ #category : #'as yet unclassified' }
WDESCameraSceneNodeComponent >> applySoundListenerParameters: soundListener withGainFactor: soundGainFactor [
	| globalTransform |
	globalTransform := self validSceneNode globalTransform.
	soundListener
		gain: self currentSoundGainFactor * soundGainFactor;
		position: globalTransform translation asWMVector3F;
		"velocity: linearVelocity asWMVector3F;"
		orientation: globalTransform matrix asWMMatrix3F.

]

{ #category : #accessing }
WDESCameraSceneNodeComponent >> createSceneNode [
	^ WDSGCamera new
]

{ #category : #'as yet unclassified' }
WDESCameraSceneNodeComponent >> currentCameraExposure [
	^ (ownerEntity ifNotNil: [ownerEntity sector defaultCameraExposure]) ifNil: [ 1.0 ]
]

{ #category : #'as yet unclassified' }
WDESCameraSceneNodeComponent >> currentCascadeSplitDistribution [
	^ (ownerEntity ifNotNil: [ownerEntity sector defaultCameraCascadeSplitDistribution]) ifNil: [0.5]
]

{ #category : #'as yet unclassified' }
WDESCameraSceneNodeComponent >> currentFarDistance [
	^ (ownerEntity ifNotNil: [ownerEntity sector defaultCameraFarDistance]) ifNil: [1000.0]
]

{ #category : #'as yet unclassified' }
WDESCameraSceneNodeComponent >> currentFogSettings [
	^ (ownerEntity ifNotNil: [ownerEntity currentFogSettings])
]

{ #category : #'as yet unclassified' }
WDESCameraSceneNodeComponent >> currentNearDistance [
	^ (ownerEntity ifNotNil: [ownerEntity sector defaultCameraNearDistance]) ifNil: [0.01]
]

{ #category : #'as yet unclassified' }
WDESCameraSceneNodeComponent >> currentSoundGainFactor [
	^ (ownerEntity ifNotNil: [ownerEntity currentSoundGainFactor])
]

{ #category : #'as yet unclassified' }
WDESCameraSceneNodeComponent >> currentToneMappingOperator [
	^ (ownerEntity ifNotNil: [ownerEntity sector defaultCameraToneMappingOperator]) ifNil: [#linear]
]

{ #category : #testing }
WDESCameraSceneNodeComponent >> isCameraSceneNodeComponent [
	^ true
]
