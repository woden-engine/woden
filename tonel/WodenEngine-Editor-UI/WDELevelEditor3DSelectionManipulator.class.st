Class {
	#name : #WDELevelEditor3DSelectionManipulator,
	#superclass : #WDELevelEditor3DBoxManipulator,
	#instVars : [
		'displayBoundingBox',
		'selectedElements'
	],
	#category : #'WodenEngine-Editor-UI-Manipulators'
}

{ #category : #'element manipulation' }
WDELevelEditor3DSelectionManipulator >> applyTransform: transform [
	selectedElements do: [ :each |
		each transformWith: transform
	].
	self computeBoundingBoxes.
]

{ #category : #'element manipulation' }
WDELevelEditor3DSelectionManipulator >> applyTransformForTranslationDelta: translation [
	selectedElements do: [ :each |
		each translateBy: translation
	].
	self computeBoundingBoxes.
]

{ #category : #accessing }
WDELevelEditor3DSelectionManipulator >> computeBoundingBoxes [
	boundingBox := BoxF32 empty.
	displayBoundingBox := BoxF32 empty.
	selectedElements do: [ :each |
		boundingBox insertBox: each boundingBox.
		displayBoundingBox insertBox: each selectableBoundingBox.
	].
	displayBoundingBox isEmpty ifFalse: [ displayBoundingBox := displayBoundingBox withExpandedHalfExtent: 0.025 ].
	
	(selectedElements size = 1 and: [ selectedElements first isPointEntity ]) ifTrue: [ 
		boundingBox := displayBoundingBox copy
	].
	
	self boundingBoxChanged.
]

{ #category : #accessing }
WDELevelEditor3DSelectionManipulator >> computeManipulationPoints [
	selectedElements ifEmpty: [ ^ #() ].
	(selectedElements size = 1 and: [ selectedElements first isPointEntity ]) ifTrue: [ ^ #() ].
	^ super computeManipulationPoints
]

{ #category : #accessing }
WDELevelEditor3DSelectionManipulator >> currentColor [
	^ highlighted
		ifTrue: [ (Float32x4 x: 0.9 y: 0.9 z: 0.3 w: 0.3)  ]
		ifFalse: [ (Float32x4 x: 0.9 y: 0.7 z: 0.3 w: 0.3) ]
]

{ #category : #accessing }
WDELevelEditor3DSelectionManipulator >> displayBoundingBox [
	^ displayBoundingBox
]

{ #category : #testing }
WDELevelEditor3DSelectionManipulator >> isManipulating2DGeometry [
	^ selectedElements allSatisfy: [ :each | each is2DLevelElement ]
]

{ #category : #memento }
WDELevelEditor3DSelectionManipulator >> positionStateMemento [
	^ { super positionStateMemento . selectedElements collect: [ :each | each position ]}
]

{ #category : #memento }
WDELevelEditor3DSelectionManipulator >> restoreMementoForDragging: memento [
	^ self restorePositionStateMemento: memento
]

{ #category : #memento }
WDELevelEditor3DSelectionManipulator >> restorePositionStateMemento: memento [
	| elementsMemento |
	super restorePositionStateMemento: memento first.
	elementsMemento := memento second.
	self assert: elementsMemento size = selectedElements size.
	selectedElements doWithIndex: [ :each :index |
		each position: (elementsMemento at: index)
	].
]

{ #category : #memento }
WDELevelEditor3DSelectionManipulator >> restoreTransformStateMemento: memento [
	| superMemento myMemento elementsMemento |
	superMemento := super restoreTransformStateMemento: memento first.
	myMemento := memento second.
	elementsMemento := memento second.
	self assert: elementsMemento size = selectedElements size.
	selectedElements doWithIndex: [ :each :index |
		each restoreTransformStateMemento: (elementsMemento at: index)
	].
]

{ #category : #accessing }
WDELevelEditor3DSelectionManipulator >> selectedElements [
	^ selectedElements
]

{ #category : #accessing }
WDELevelEditor3DSelectionManipulator >> selectedElements: anObject [
	selectedElements := anObject.
	self computeBoundingBoxes
]

{ #category : #memento }
WDELevelEditor3DSelectionManipulator >> transformStateMemento [
	^ {
		super transformStateMemento.
		selectedElements collect: [ :each | each transformStateMemento ]
	}
]
