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
			sectorLayer isInSector2D ifTrue: [ 
				sectorLayer createSolidEntity: 'Wall' rectangle: boundingBox asRectangleXY color: (Color r: 0.8 g: 0.8 b: 0.8)
			] ifFalse: [ 
				sectorLayer createSolidEntity: 'Wall' box: boundingBox color: (Color r: 0.8 g: 0.8 b: 0.8)
			]
		].
	].

	model activeToolManipulator: nil.
]

{ #category : #accessing }
WDELevelEditor3DBoxPlacementManipulator >> currentColor [
	^ highlighted
		ifTrue: [ (Float32x4 x: 0.9 y: 0.9 z: 0.9 w: 0.3)  ]
		ifFalse: [ (Float32x4 x: 0.7 y: 0.7 z: 0.7 w: 0.3) ]
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
