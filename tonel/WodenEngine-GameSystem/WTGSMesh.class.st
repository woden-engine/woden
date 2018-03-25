Class {
	#name : #WTGSMesh,
	#superclass : #WTGSComponent,
	#instVars : [
		'mesh'
	],
	#category : 'WodenEngine-GameSystem-Level'
}

{ #category : #adding }
WTGSMesh >> addedToEntity: anEntity [
	entity ifNotNil: [ entity invalidateModels ].
	super addedToEntity: anEntity.
	entity
		ensureSpatialObject
]

{ #category : #adding }
WTGSMesh >> addedToScene: scene [
	| nodeComponent |
	scene ifNil: [ ^ self ].
	nodeComponent := entity sceneNodeComponent.
	nodeComponent node renderable: mesh
]

{ #category : #accessing }
WTGSMesh >> bucket [
	^ #modeling
]

{ #category : #accessing }
WTGSMesh >> mesh [
	^ mesh
]

{ #category : #accessing }
WTGSMesh >> mesh: anObject [
	mesh := anObject
]
