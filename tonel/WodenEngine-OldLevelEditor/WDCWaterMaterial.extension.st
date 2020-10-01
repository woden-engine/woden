Extension { #name : #WDCWaterMaterial }

{ #category : #'*WodenEngine-OldLevelEditor' }
WDCWaterMaterial >> createTerrainMeshForMapComponent: component sceneNode: node [
	"component
		boundingBox: (self localBoundingBox translatedBy: node transform translation) asBoxF64."
	^ self createTerrainMeshForSceneNode: node boundingBox: component boundingBox
]

{ #category : #'*WodenEngine-OldLevelEditor' }
WDCWaterMaterial >> inEditor: editor addObjectAtSelectionCube: selectionBox [
	^ editor addVolumeWithGridAtSelectionCube
]
