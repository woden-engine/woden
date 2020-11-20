Class {
	#name : #WDELevelEditorViewPlacementMode,
	#superclass : #WDELevelEditorViewEditionMode,
	#category : #'WodenEngine-Editor-UI-ViewMode'
}

{ #category : #'event handling' }
WDELevelEditorViewPlacementMode >> onMouseButtonRelease: event [
	self levelEditorSession activeSectorLayer ifNotNil: [ :sectorLayer |
		self levelEditorSession activeLevelElementTemplate ifNotNil: [ :elementTemplate |
			elementTemplate isPointElementTemplate ifTrue: [
				| entityLocation |
				entityLocation := self snapToSubGrid: (self cameraXYToWorld: event position distance: 5.0).
				elementTemplate instantiateInSectorLayer: sectorLayer placingInPoint: entityLocation session: self levelEditorSession.
			]
		]
	]
]

{ #category : #'event handling' }
WDELevelEditorViewPlacementMode >> startActionDraggingWith: event [
	self levelEditorSession activeSectorLayer ifNotNil: [
		self levelEditorSession activeLevelElementTemplate ifNotNil: [ :elementTemplate |
			elementTemplate isPointElementTemplate ifFalse: [
				view activeToolMode: ((WDELevelEditorBrushDrawDragToolMode for: view)
					dragStartedWith: event;
					yourself)
			]
		]
	].

]

{ #category : #'as yet unclassified' }
WDELevelEditorViewPlacementMode >> supportsManipulators [
	^ true
]
