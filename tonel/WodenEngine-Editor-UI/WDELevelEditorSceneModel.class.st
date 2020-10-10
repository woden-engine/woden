Class {
	#name : #WDELevelEditorSceneModel,
	#superclass : #WDASceneModel,
	#instVars : [
		'levelEditorSession',
		'levelElementToSceneNodeDictionary',
		'levelElementToSelectionBoxNode'
	],
	#category : #'WodenEngine-Editor-UI'
}

{ #category : #accessing }
WDELevelEditorSceneModel >> createEntitySelectionBox: entity [
	| entityNode selectionBoxNode |
	(levelElementToSelectionBoxNode includesKey: entity) ifTrue: [ ^ self ].
	entityNode := self nodeForLevelElement: entity.

	selectionBoxNode := WDSGSpatialObject new.
	selectionBoxNode renderable: engine resourceCache unitCubeMesh.
	entityNode addChild: selectionBoxNode.
	levelElementToSelectionBoxNode at: entity put: selectionBoxNode.
	Transcript show: entity localSelectableBoundingBox center; space; show: entity localSelectableBoundingBox halfExtent; cr.
	selectionBoxNode transform: entity localSelectableBoundingBox reversibleTransformToConvertUnitBoxToMe.
]

{ #category : #accessing }
WDELevelEditorSceneModel >> createSceneNodeForEntity: entity [
	| node |
	node := WDSGSpatialObject new.
	node position: entity validPosition3D.
	levelElementToSceneNodeDictionary at: entity put: node.
	entity components do: [ :each |
		(self createSceneNodeForEntityComponent: each) ifNotNil: [ :componentNode |
			node addChild: componentNode
		].
	].

	self createEntitySelectionBox: entity.
	^ node
]

{ #category : #accessing }
WDELevelEditorSceneModel >> createSceneNodeForEntityComponent: entityComponent [
	^ nil
]

{ #category : #accessing }
WDELevelEditorSceneModel >> createSceneNodeForSector: sector [
	| node |
	node := WDSGSpatialObject new.
	levelElementToSceneNodeDictionary at: sector put: node.
	sector layers do: [ :each |
		node addChild: (self createSceneNodeForSectorLayer: each)
	].
	^ node
]

{ #category : #accessing }
WDELevelEditorSceneModel >> createSceneNodeForSectorLayer: sectorLayer [
	| node |
	node := WDSGSpatialObject new.
	levelElementToSceneNodeDictionary at: sectorLayer put: node.
	sectorLayer entities do: [ :each |
		node addChild: (self createSceneNodeForEntity: each)
	].
	^ node
]

{ #category : #initialization }
WDELevelEditorSceneModel >> initializeModel [
]

{ #category : #accessing }
WDELevelEditorSceneModel >> level [
	^ levelEditorSession level
]

{ #category : #accessing }
WDELevelEditorSceneModel >> levelChanged [
	self newScene.
	levelElementToSceneNodeDictionary := IdentityDictionary new.
	levelElementToSelectionBoxNode := IdentityDictionary new.
	self level sectors do: [ :each |
		scene add: (self createSceneNodeForSector: each)
	].
]

{ #category : #accessing }
WDELevelEditorSceneModel >> levelEditorSession [
	^ levelEditorSession
]

{ #category : #accessing }
WDELevelEditorSceneModel >> levelEditorSession: anObject [
	levelEditorSession := anObject.
	
	levelEditorSession whenLevelChangedDo: [ self levelChanged ].
	self levelChanged.
]

{ #category : #'instance creation' }
WDELevelEditorSceneModel >> newScene [
	super newScene.
	scene backgroundColor: (Float32x4 xyz: (0.015 implicitCastTo: Float32x3) w: 1.0).
	camera
		hasAutoExposure: false;
		translateByZ: 10.
	^ scene
]

{ #category : #accessing }
WDELevelEditorSceneModel >> nodeForLevelElement: levelElement [
	^ levelElementToSceneNodeDictionary at: levelElement
]
