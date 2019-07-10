Extension { #name : #WDCWaterMaterial }

{ #category : #'*WodenEngine-OldLevelEditor' }
WDCWaterMaterial >> createTerrainMeshForMapComponent: component sceneNode: node [
	"component
		boundingBox: (self localBoundingBox translatedBy: node transform translation) asWMBox3DD."
	^ self createTerrainMeshForSceneNode: node boundingBox: component boundingBox
]

{ #category : #'*WodenEngine-OldLevelEditor' }
WDCWaterMaterial >> inEditor: editor addObjectAtSelectionCube: selectionBox [
	^ editor addVolumeWithGridAtSelectionCube
]
