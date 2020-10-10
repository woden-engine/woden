Class {
	#name : #WDELevelEditorElementSceneNodeBuilder,
	#superclass : #WDELevelVisitor,
	#instVars : [
		'editorSceneModel'
	],
	#category : #'WodenEngine-Editor-UI'
}

{ #category : #accessing }
WDELevelEditorElementSceneNodeBuilder >> editorSceneModel [
	^ editorSceneModel
]

{ #category : #accessing }
WDELevelEditorElementSceneNodeBuilder >> editorSceneModel: anObject [
	editorSceneModel := anObject
]

{ #category : #accessing }
WDELevelEditorElementSceneNodeBuilder >> engine [
	^ editorSceneModel engine
]

{ #category : #'collision components' }
WDELevelEditorElementSceneNodeBuilder >> visitBoxCollisionComponent: component [
	^ nil
]

{ #category : #'visual components' }
WDELevelEditorElementSceneNodeBuilder >> visitBoxVisualComponent: component [
	| node |
	node := WDSGSpatialObject new.
	node renderable: self engine resourceCache unitCubeMesh.
	node
		color: component color;
		transform: component boundingBox reversibleTransformToConvertUnitBoxToMe.
	component whenChangedDo: [
		node
			color: component color;
			transform: component reversibleTransformToConvertUnitBoxToMe
	].
	^ node
]

{ #category : #visiting }
WDELevelEditorElementSceneNodeBuilder >> visitEntity: entity [
	| node |
	node := WDSGSpatialObject new.
	node position: entity validPosition3D.
	entity whenPositionChangedDo: [ :newPosition | node position: entity validPosition3D ].

	editorSceneModel mapLevelElement: entity toSceneNode: node.
	entity components do: [ :each |
		(self visitLevelElement: each) ifNotNil: [:childNode |
			node addChild: childNode
		].
	].

	editorSceneModel createEntityEditorSelectionBoxNode: entity.
	^ node
]

{ #category : #'collision components' }
WDELevelEditorElementSceneNodeBuilder >> visitRectangleCollisionComponent: component [
	^ self visitBoxCollisionComponent: component
]

{ #category : #'visual components' }
WDELevelEditorElementSceneNodeBuilder >> visitRectangleVisualComponent: component [
	^ self visitBoxVisualComponent: component
]

{ #category : #visiting }
WDELevelEditorElementSceneNodeBuilder >> visitSector: sector [
	| node |
	node := WDSGSpatialObject new.
	editorSceneModel mapLevelElement: sector toSceneNode: node.
	sector layers do: [ :each |
		(self visitLevelElement: each) ifNotNil: [:childNode |
			node addChild: childNode
		].
	].
	^ node
]

{ #category : #visiting }
WDELevelEditorElementSceneNodeBuilder >> visitSectorLayer: sectorLayer [
	| node |
	node := WDSGSpatialObject new.
	editorSceneModel mapLevelElement: sectorLayer toSceneNode: node.
	sectorLayer entities do: [ :each |
		(self visitLevelElement: each) ifNotNil: [:childNode |
			node addChild: childNode
		].
	].
	^ node
]
