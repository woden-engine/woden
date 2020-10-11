Class {
	#name : #WDELevelEditor3DSelectionManipulator,
	#superclass : #WDELevelEditor3DManipulator,
	#instVars : [
		'selectedElements',
		'displayBoundingBox'
	],
	#category : #'WodenEngine-Editor-UI'
}

{ #category : #accessing }
WDELevelEditor3DSelectionManipulator >> applyHighlightingEffect [
	sceneNode ifNotNil: [ sceneNode color: self currentColor ]
]

{ #category : #'element manipulation' }
WDELevelEditor3DSelectionManipulator >> applyTransformForTranslationDelta: translation [
	selectedElements do: [ :each |
		each translateBy: translation
	].
	self computeBoundingBoxes.
]

{ #category : #accessing }
WDELevelEditor3DSelectionManipulator >> buildCornerManipulators [
	| points |
	(selectedElements size = 1 and: [ selectedElements first isPointEntity ]) ifTrue: [ ^ self ].
	points := boundingBox manipulationPoints.
	children size = points size ifFalse: [
		self children: (points
			collect: [ :corner | WDELevelEditor3DSelectionBoxCornerHandle for: model]
			as: Array)
	].
	
	points doWithIndex: [ :point :index |
		(children at: index) position: point
	]
	
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
	
	sceneNode ifNotNil: [
		sceneNode transform: displayBoundingBox reversibleTransformToConvertUnitBoxToMe
	].
	 
	boundingBox isEmpty ifFalse: [
		self buildCornerManipulators
	]
]

{ #category : #removing }
WDELevelEditor3DSelectionManipulator >> createSceneNode [
	boundingBox isEmpty ifTrue: [ ^ nil ].
	^ WDSGSpatialObject new
		renderable: self engine resourceCache flatShadedTranslucentUnitCubeMesh copy setFlatColorSubRenderMode;
		color: self currentColor;
		transform: displayBoundingBox reversibleTransformToConvertUnitBoxToMe;
		yourself.
]

{ #category : #accessing }
WDELevelEditor3DSelectionManipulator >> currentColor [
	^ highlighted
		ifTrue: [ (Float32x4 x: 0.9 y: 0.9 z: 0.3 w: 0.3)  ]
		ifFalse: [ (Float32x4 x: 0.9 y: 0.7 z: 0.3 w: 0.3) ]
]

{ #category : #'as yet unclassified' }
WDELevelEditor3DSelectionManipulator >> currentDragToolClass [
	^ WDELevelEditorViewTranslateManipulatorDragToolMode
]

{ #category : #memento }
WDELevelEditor3DSelectionManipulator >> mementoForDragging [
	^ selectedElements collect: [ :each | each transformStateMemento ]
]

{ #category : #memento }
WDELevelEditor3DSelectionManipulator >> restoreMementoForDragging: memento [
	self assert: memento size = selectedElements size.
	selectedElements doWithIndex: [ :each :index |
		each restoreTransformStateMemento: (memento at: index)
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
