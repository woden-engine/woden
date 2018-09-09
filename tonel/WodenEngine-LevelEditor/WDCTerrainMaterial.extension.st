Extension { #name : #WDCTerrainMaterial }

{ #category : #'*WodenEngine-LevelEditor' }
WDCTerrainMaterial >> createTerrainMeshForMapComponent: component sceneNode: node [
	component
		boundingBox: (self localBoundingBox translatedBy: node transform translation) asWMBox3DD.
	^ self createTerrainMeshForSceneNode: node
]

{ #category : #'*WodenEngine-LevelEditor' }
WDCTerrainMaterial >> inEditor: editor addObjectAtSelectionCube: selectionBox [
	^ editor addTerrainPlaneAtSelectionCubeWithMaterial: self
]
