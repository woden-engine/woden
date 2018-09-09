"
I am a mesh that is used during play mode
"
Class {
	#name : #WDGSMesh,
	#superclass : #WDGSComponent,
	#instVars : [
		'mesh'
	],
	#category : #'WodenEngine-GameSystem-Level'
}

{ #category : #adding }
WDGSMesh >> addedToEntity: anEntity [
	entity ifNotNil: [ entity invalidateModels ].
	super addedToEntity: anEntity.
	entity
		ensureSpatialObject
]

{ #category : #adding }
WDGSMesh >> addedToScene: scene [
	| nodeComponent |
	scene ifNil: [ ^ self ].
	nodeComponent := entity sceneNodeComponent.
	nodeComponent node renderable: mesh
]

{ #category : #accessing }
WDGSMesh >> bucket [
	^ #modeling
]

{ #category : #accessing }
WDGSMesh >> mesh [
	^ mesh
]

{ #category : #accessing }
WDGSMesh >> mesh: anObject [
	mesh := anObject
]
