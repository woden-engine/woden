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
WDELevelEditorSceneModel >> createEntityEditorSelectionBoxNode: entity [
	| entityNode selectionBoxNode |
	(levelElementToSelectionBoxNode includesKey: entity) ifTrue: [ ^ self ].
	entityNode := self nodeForLevelElement: entity.
	entityNode children isNotEmpty ifTrue: [ ^ self ].

	selectionBoxNode := WDSGSpatialObject new.
	selectionBoxNode renderable: engine resourceCache unitCubeMesh.
	entityNode addChild: selectionBoxNode.
	levelElementToSelectionBoxNode at: entity put: selectionBoxNode.
	selectionBoxNode transform: entity localSelectableBoundingBox reversibleTransformToConvertUnitBoxToMe.
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
	| builder |
	self newScene.
	levelElementToSceneNodeDictionary := IdentityDictionary new.
	levelElementToSelectionBoxNode := IdentityDictionary new.
	builder := WDELevelEditorElementSceneNodeBuilder new editorSceneModel: self.
	self level sectors do: [ :each |
		scene add: (builder visitLevelElement: each)
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

{ #category : #accessing }
WDELevelEditorSceneModel >> mapLevelElement: levelElement toSceneNode: sceneNode [
	levelElementToSceneNodeDictionary at: levelElement put: sceneNode
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
