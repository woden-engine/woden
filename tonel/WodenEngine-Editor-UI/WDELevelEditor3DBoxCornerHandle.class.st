Class {
	#name : #WDELevelEditor3DBoxCornerHandle,
	#superclass : #WDELevelEditor3DManipulator,
	#category : #'WodenEngine-Editor-UI-Manipulators'
}

{ #category : #removing }
WDELevelEditor3DBoxCornerHandle >> applyHighlightingEffect [
	sceneNode ifNotNil: [ sceneNode color: self currentColor ]
]

{ #category : #'element manipulation' }
WDELevelEditor3DBoxCornerHandle >> applyTransformForTranslationDelta: translation [
	| axis constrainedTranslation originalBox min max newBox transform sanitizedNewBox |
	originalBox := parent boundingBox.
	axis := (self position - originalBox center) sign.
	constrainedTranslation := translation * axis abs.

	min := originalBox min copy.
	max := originalBox max copy.
	axis x < 0 ifTrue: [ min x: min x + constrainedTranslation x ].
	axis x > 0 ifTrue: [ max x: max x + constrainedTranslation x ].
	axis y < 0 ifTrue: [ min y: min y + constrainedTranslation y ].
	axis y > 0 ifTrue: [ max y: max y + constrainedTranslation y ].
	axis z < 0 ifTrue: [ min z: min z + constrainedTranslation z ].
	axis z > 0 ifTrue: [ max z: max z + constrainedTranslation z ].

	newBox := BoxF32 min: (min min: max) max: (min max: max).
	sanitizedNewBox := BoxF32 center: newBox center halfExtent: (newBox halfExtent max: 0.001).
	transform := sanitizedNewBox reversibleTransformToConvertToMe: originalBox.
	parent applyTransform: transform
]

{ #category : #removing }
WDELevelEditor3DBoxCornerHandle >> createSceneNode [
	boundingBox isEmpty ifTrue: [ ^ nil ].
	^ WDSGSpatialObject new
		renderable: (self engine resourceCache flatShadedUnitCubeMesh copy
			depthTestingEnabled: false;
			depthWriteMask: false;
			isOpaqueShadowCaster: false;
			renderPriority: WDCAbstractRenderable renderPriorityEditorTranslucentAfter + 1;
			setFlatColorSubRenderMode);
		color: self currentColor;
		transform: boundingBox reversibleTransformToConvertUnitBoxToMe;
		yourself.
]

{ #category : #removing }
WDELevelEditor3DBoxCornerHandle >> currentColor [
	^ highlighted
		ifTrue: [ Float32x4 ones  ]
		ifFalse: [ Float32x4 x: 0.6 y: 0.6 z: 0.6 w: 1.0 ]
]

{ #category : #'as yet unclassified' }
WDELevelEditor3DBoxCornerHandle >> currentDragToolClass [
	^ WDELevelEditorViewTranslateManipulatorDragToolMode
]

{ #category : #memento }
WDELevelEditor3DBoxCornerHandle >> mementoForDragging [
	^ {boundingBox . parent transformStateMemento}
]

{ #category : #accessing }
WDELevelEditor3DBoxCornerHandle >> position [
	^ boundingBox center
]

{ #category : #accessing }
WDELevelEditor3DBoxCornerHandle >> position: position [
	boundingBox := BoxF32 center: position halfExtent: 0.1.
	sceneNode ifNotNil: [ 
		sceneNode transform: boundingBox reversibleTransformToConvertUnitBoxToMe
	]
]

{ #category : #memento }
WDELevelEditor3DBoxCornerHandle >> restoreMementoForDragging: memento [
	boundingBox := memento first.
	^ parent restoreTransformStateMemento: memento second
]
