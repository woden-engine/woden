Extension { #name : #WDCTerrainMaterial }

{ #category : #'*WodenEngine-OldLevelEditor' }
WDCTerrainMaterial >> createTerrainMeshForMapComponent: component sceneNode: node [
	component
		boundingBox: (self localBoundingBox translatedBy: node transform translation) asWMBox3DD.
	^ self createTerrainMeshForSceneNode: node
]

{ #category : #'*WodenEngine-OldLevelEditor' }
WDCTerrainMaterial >> inEditor: editor addObjectAtSelectionCube: selectionBox [
	^ editor addTerrainPlaneAtSelectionCubeWithMaterial: self
]
