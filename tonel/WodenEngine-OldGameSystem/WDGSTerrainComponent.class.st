Class {
	#name : #WDGSTerrainComponent,
	#superclass : #WDGSProceduralMesh,
	#category : #'WodenEngine-OldGameSystem-Level'
}

{ #category : #'as yet unclassified' }
WDGSTerrainComponent >> createMeshFor: node [
	^ self mainMaterial createTerrainMeshForMapComponent: self sceneNode: node
]
