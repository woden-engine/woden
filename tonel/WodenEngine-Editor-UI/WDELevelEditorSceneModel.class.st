Class {
	#name : #WDELevelEditorSceneModel,
	#superclass : #WDASceneModel,
	#instVars : [
		'levelEditorSession',
		'levelElementToSceneNodeDictionary',
		'levelElementToSelectionBoxNode',
		'highlightBoxNode'
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

{ #category : #'as yet unclassified' }
WDELevelEditorSceneModel >> highlightElement: anElement [
	anElement ifNil: [
		highlightBoxNode visible: false.
	] ifNotNil: [
		highlightBoxNode
			visible: true;
			transform: (anElement selectableBoundingBox withExpandedHalfExtent: 0.025) reversibleTransformToConvertUnitBoxToMe.
	]
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
		
	highlightBoxNode := WDSGSpatialObject new
		renderable: engine resourceCache flatShadedTranslucentUnitCubeMesh;
		color: (Float32x4 x: 0.3 y: 0.3 z: 0.9 w: 0.5);
		visible: false;
		yourself.
	scene add: highlightBoxNode.
	^ scene
]

{ #category : #accessing }
WDELevelEditorSceneModel >> nodeForLevelElement: levelElement [
	^ levelElementToSceneNodeDictionary at: levelElement
]

{ #category : #'ray casting' }
WDELevelEditorSceneModel >> rayCast: ray [
	^ self level rayCast: ray
]
