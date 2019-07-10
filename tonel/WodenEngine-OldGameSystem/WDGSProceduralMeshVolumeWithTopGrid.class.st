Class {
	#name : #WDGSProceduralMeshVolumeWithTopGrid,
	#superclass : #WDGSProceduralMesh,
	#category : #'WodenEngine-OldGameSystem-Level'
}

{ #category : #'as yet unclassified' }
WDGSProceduralMeshVolumeWithTopGrid class >> jsonTypeName [
	^ 'proceduralVolumeWithTopMesh'
]

{ #category : #'as yet unclassified' }
WDGSProceduralMeshVolumeWithTopGrid >> createMeshFor: node [
	| material |
	material := self mainMaterial copy.
	node transform translateByY: boundingBox height / 2.0.
	^ material createTerrainMeshForMapComponent: self sceneNode: node
]
