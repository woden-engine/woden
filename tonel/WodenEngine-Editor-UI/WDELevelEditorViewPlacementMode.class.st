Class {
	#name : #WDELevelEditorViewPlacementMode,
	#superclass : #WDELevelEditorViewEditionMode,
	#category : #'WodenEngine-Editor-UI-ViewMode'
}

{ #category : #'event handling' }
WDELevelEditorViewPlacementMode >> cancelAction [
	view activateObjectMode
]

{ #category : #testing }
WDELevelEditorViewPlacementMode >> isPlacementMode [
	^ true
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewPlacementMode >> modeName [
	^ 'Placement Mode'
]

{ #category : #'event handling' }
WDELevelEditorViewPlacementMode >> onLeftClick: event [
	self levelEditorSession activeSectorLayer ifNotNil: [ :sectorLayer |
		self levelEditorSession activeLevelElementTemplate ifNotNil: [ :elementTemplate |
			elementTemplate isPointElementTemplate ifTrue: [
				| entityLocation |
				entityLocation := self snapToSubGrid: (self cameraXYToWorld: event position).
				elementTemplate instantiateInSectorLayer: sectorLayer placingInPoint: entityLocation session: self levelEditorSession.
				view activateObjectMode
			]
		]
	]
]

{ #category : #'event handling' }
WDELevelEditorViewPlacementMode >> startActionDraggingWith: event [
	| manipulator |
	manipulator := view manipulatorInScreenPosition: event position.
	manipulator ifNotNil: [
		^ manipulator startDragToolWithEvent: event on: view
	].

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
