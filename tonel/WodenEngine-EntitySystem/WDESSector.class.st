Class {
	#name : #WDESSector,
	#superclass : #WDESGenericEntity,
	#instVars : [
		'tickingEntities',
		'usableVolumeRayCastingSet',
		'interactiveScreenVolumeRayCastingSet'
	],
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #building }
WDESSector class >> build: aBlock [
	| result |
	result := self new.
	aBlock value: self.
	^ result
]

{ #category : #adding }
WDESSector >> addEntity: anEntity toSpawnPoint: spawnPointEntity [
	spawnPointEntity ifNil: [ 
		self addChild: anEntity
	] ifNotNil: [
		spawnPointEntity sector addChild: anEntity.
		anEntity transform: spawnPointEntity sectorTransform
	]
]

{ #category : #simulation }
WDESSector >> addTickingEntity: anEntity [
	tickingEntities add: anEntity
]

{ #category : #scene }
WDESSector >> addedToScene: anScene [
	sceneNode ifNotNil: [ sceneNode removeFromScene ].
	anScene add: self validSceneNode.
	super addedToScene: anScene.
	
]

{ #category : #accessing }
WDESSector >> defaultCameraCascadeSplitDistribution [
	^ self universe ifNotNil: [ :universe | universe defaultCameraCascadeSplitDistribution ]
]

{ #category : #accessing }
WDESSector >> defaultCameraExposure [
	^ self universe ifNotNil: [ :universe | universe defaultCameraExposure ]
]

{ #category : #accessing }
WDESSector >> defaultCameraFarDistance [
	^ self universe ifNotNil: [ :universe | universe defaultCameraFarDistance ]
]

{ #category : #accessing }
WDESSector >> defaultCameraNearDistance [
	^ self universe ifNotNil: [ :universe | universe defaultCameraNearDistance ]
]

{ #category : #accessing }
WDESSector >> defaultCameraToneMappingOperator [
	^ self universe ifNotNil: [ :universe | universe defaultCameraToneMappingOperator ]
]

{ #category : #accessing }
WDESSector >> defaultFogSettings [
	^ self universe ifNotNil: [ :universe | universe defaultFogSettings ]
]

{ #category : #accessing }
WDESSector >> defaultSoundGainFactor [
	^ self universe ifNotNil: [ :universe | universe defaultSoundGainFactor ]
]

{ #category : #initialization }
WDESSector >> initialize [
	super initialize.
	tickingEntities := IdentitySet new.
	usableVolumeRayCastingSet := WDESSectorRayCastingSet new.
	interactiveScreenVolumeRayCastingSet := WDESSectorRayCastingSet new.
]

{ #category : #accessing }
WDESSector >> interactiveScreenVolumeRayCastingSet [
	^ interactiveScreenVolumeRayCastingSet
]

{ #category : #simulation }
WDESSector >> removeTickingEntity: anEntity [
	tickingEntities remove: anEntity
]

{ #category : #scene }
WDESSector >> removedFromScene: anScene [
	super removedFromScene: anScene.
	sceneNode ifNotNil: [ anScene remove: sceneNode ].
]

{ #category : #accessing }
WDESSector >> sceneNode: newSceneNode [
	sceneNode := newSceneNode
]

{ #category : #accessing }
WDESSector >> sector [
	^ self
]

{ #category : #'as yet unclassified' }
WDESSector >> sectorTransform [
	^ ReversibleAffineTransform3dF32 identity
]

{ #category : #simulation }
WDESSector >> tick: delta [
	super tick: delta.
	tickingEntities do: [ :entity | entity tick: delta ]
]

{ #category : #accessing }
WDESSector >> usableVolumeRayCastingSet [
	^ usableVolumeRayCastingSet
]
