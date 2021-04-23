Class {
	#name : #WDELevelEditor3DBoxManipulator,
	#superclass : #WDELevelEditor3DManipulator,
	#category : #'WodenEngine-Editor-UI-Manipulators'
}

{ #category : #accessing }
WDELevelEditor3DBoxManipulator >> applyHighlightingEffect [
	sceneNode ifNotNil: [ sceneNode color: self currentColor ]
]

{ #category : #'element manipulation' }
WDELevelEditor3DBoxManipulator >> applyTransform: transform [
	self boundingBox: (boundingBox transformedWith: transform)
]

{ #category : #'element manipulation' }
WDELevelEditor3DBoxManipulator >> applyTransformForTranslationDelta: translation [
	self boundingBox: (boundingBox translatedBy: translation)
]

{ #category : #accessing }
WDELevelEditor3DBoxManipulator >> boundingBox: newBoundingBox [
	boundingBox := newBoundingBox.
	self boundingBoxChanged
]

{ #category : #'as yet unclassified' }
WDELevelEditor3DBoxManipulator >> boundingBoxChanged [ 
	sceneNode ifNotNil: [
		sceneNode transform: self displayBoundingBox reversibleTransformToConvertUnitBoxToMe
	].
	 
	boundingBox isEmpty ifFalse: [
		self buildCornerManipulators
	]
]

{ #category : #accessing }
WDELevelEditor3DBoxManipulator >> buildCornerManipulators [
	| points |
	points := self computeManipulationPoints.
	children size = points size ifFalse: [
		self children: (points
			collect: [ :corner | WDELevelEditor3DBoxCornerHandle for: model]
			as: Array)
	].
	
	points doWithIndex: [ :point :index |
		(children at: index) position: point
	]
	
]

{ #category : #accessing }
WDELevelEditor3DBoxManipulator >> computeManipulationPoints [
	self isManipulating2DGeometry ifTrue: [
		^ {
			boundingBox leftBottomPoint .
			boundingBox rightBottomPoint .
			boundingBox leftTopPoint .
			boundingBox rightTopPoint .
		
			boundingBox leftPoint .
			boundingBox rightPoint .
			boundingBox bottomPoint .
			boundingBox topPoint .
		}
	].

	^ boundingBox manipulationPoints
]

{ #category : #removing }
WDELevelEditor3DBoxManipulator >> createSceneNode [
	self displayBoundingBox isEmpty ifTrue: [ ^ nil ].
	^ WDSGSpatialObject new
		renderable: (self engine resourceCache flatShadedTranslucentUnitCubeMesh copy 			setFlatColorSubRenderMode; 
			isOpaqueShadowCaster: false;
			yourself);
		color: self currentColor;
		transform: self displayBoundingBox reversibleTransformToConvertUnitBoxToMe;
		yourself.
]

{ #category : #accessing }
WDELevelEditor3DBoxManipulator >> currentColor [
	^ highlighted
		ifTrue: [ self theme highlightedBoxManipulatorColor  ]
		ifFalse: [ self theme boxManipulatorColor ]
]

{ #category : #'as yet unclassified' }
WDELevelEditor3DBoxManipulator >> currentDragToolClass [
	^ WDELevelEditorViewTranslateManipulatorDragToolMode
]

{ #category : #accessing }
WDELevelEditor3DBoxManipulator >> displayBoundingBox [
	^ boundingBox
]

{ #category : #testing }
WDELevelEditor3DBoxManipulator >> isManipulating2DGeometry [
	^ false
]

{ #category : #memento }
WDELevelEditor3DBoxManipulator >> mementoForDragging [
	^ self positionStateMemento
]

{ #category : #memento }
WDELevelEditor3DBoxManipulator >> positionStateMemento [
	^ boundingBox
]

{ #category : #memento }
WDELevelEditor3DBoxManipulator >> restoreMementoForDragging: memento [
	^ self restorePositionStateMemento: memento
]

{ #category : #memento }
WDELevelEditor3DBoxManipulator >> restorePositionStateMemento: memento [
	boundingBox := memento
]

{ #category : #memento }
WDELevelEditor3DBoxManipulator >> restoreTransformStateMemento: memento [
	boundingBox := memento
]

{ #category : #memento }
WDELevelEditor3DBoxManipulator >> transformStateMemento [
	^ boundingBox
]
