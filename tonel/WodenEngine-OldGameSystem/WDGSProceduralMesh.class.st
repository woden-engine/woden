Class {
	#name : #WDGSProceduralMesh,
	#superclass : #WDGSSceneNodeModelingComponent,
	#instVars : [
		'materialNames'
	],
	#category : #'WodenEngine-OldGameSystem-Level'
}

{ #category : #'as yet unclassified' }
WDGSProceduralMesh class >> asJsonData [
	^ OrderedDictionary newFromPairs: {
		'type' . self class jsonTypeName.
	 }
]

{ #category : #accessing }
WDGSProceduralMesh >> boundingBox: anObject [
	boundingBox := anObject
]

{ #category : #rendering }
WDGSProceduralMesh >> buildSolidModelInto: aMeshBuilder [
]

{ #category : #rendering }
WDGSProceduralMesh >> buildTexturedModelInto: aMeshBuilder [
]

{ #category : #'as yet unclassified' }
WDGSProceduralMesh >> createMeshFor: node [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDGSProceduralMesh >> createMeshInto: node [
	^ self subclassResponsibility
]

{ #category : #adding }
WDGSProceduralMesh >> createSceneNode [
	| node mesh |
	node := WDSGSpatialObject new.
	node transform 	translation: boundingBox center asFloat32x3.
	mesh := self createMeshFor: node.
	node renderable: mesh.
	^ node
]

{ #category : #'as yet unclassified' }
WDGSProceduralMesh >> mainMaterial [
	^ self engine resourceCache loadMaterial: materialNames first
]

{ #category : #'as yet unclassified' }
WDGSProceduralMesh >> materialName: materialName [
	materialNames := { materialName }
]

{ #category : #accessing }
WDGSProceduralMesh >> materialNames [
	^ materialNames
]

{ #category : #accessing }
WDGSProceduralMesh >> materialNames: anObject [
	materialNames := anObject
]
