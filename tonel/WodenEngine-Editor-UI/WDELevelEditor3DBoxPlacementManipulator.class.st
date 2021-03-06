Class {
	#name : #WDELevelEditor3DBoxPlacementManipulator,
	#superclass : #WDELevelEditor3DBoxManipulator,
	#instVars : [
		'isManipulating2DGeometry'
	],
	#category : #'WodenEngine-Editor-UI-Manipulators'
}

{ #category : #'as yet unclassified' }
WDELevelEditor3DBoxPlacementManipulator >> activateAction [
	(boundingBox isEmpty not and: [ boundingBox width > 0 and: [ boundingBox height > 0 and: [ boundingBox depth > 0 ] ] ]) ifTrue: [
		self levelEditorSession activeSectorLayer ifNotNil: [ :sectorLayer |
			self levelEditorSession activeLevelElementTemplate ifNotNil: [ :elementTemplate |
				elementTemplate instantiateInSectorLayer: sectorLayer placingInBox: boundingBox session: self levelEditorSession
			].
		].
	].

	model activeToolManipulator: nil.
	model activateObjectMode.
]

{ #category : #accessing }
WDELevelEditor3DBoxPlacementManipulator >> currentColor [
	^ highlighted
		ifTrue: [ self theme highlightedBoxPlacementManipulatorColor ]
		ifFalse: [ self theme boxPlacementManipulatorColor ]
]

{ #category : #initialization }
WDELevelEditor3DBoxPlacementManipulator >> initialize [
	super initialize.
	isManipulating2DGeometry := false.
]

{ #category : #accessing }
WDELevelEditor3DBoxPlacementManipulator >> isManipulating2DGeometry [
	^ isManipulating2DGeometry
]

{ #category : #accessing }
WDELevelEditor3DBoxPlacementManipulator >> isManipulating2DGeometry: anObject [
	isManipulating2DGeometry := anObject
]
