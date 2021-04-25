Class {
	#name : #WDELevelEditor3DBoxCornerHandle,
	#superclass : #WDELevelEditor3DManipulator,
	#instVars : [
		'currentHalfExtent'
	],
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
	axis := self manipulatedBoxCornerAxis.
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

{ #category : #accessing }
WDELevelEditor3DBoxCornerHandle >> boundingBoxChanged [
	sceneNode ifNotNil: [ 
		sceneNode transform: boundingBox reversibleTransformToConvertUnitBoxToMe
	]
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
		ifTrue: [ self theme highlightedBoxCornerHandleColor  ]
		ifFalse: [ self theme boxCornerHandleColor ]
]

{ #category : #'as yet unclassified' }
WDELevelEditor3DBoxCornerHandle >> currentDragToolClass [
	^ WDELevelEditorViewTranslateManipulatorDragToolMode
]

{ #category : #accessing }
WDELevelEditor3DBoxCornerHandle >> halfExtent: halfExtent [
	currentHalfExtent := halfExtent.
	self position: boundingBox center
]

{ #category : #initialization }
WDELevelEditor3DBoxCornerHandle >> initialize [
	super initialize.
	currentHalfExtent:= Float32x3 ones * 0.1
]

{ #category : #'element manipulation' }
WDELevelEditor3DBoxCornerHandle >> manipulatedBoxCornerAxis [
	^ (self position - self parent boundingBox center) sign.
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
	boundingBox := BoxF32 center: position halfExtent: currentHalfExtent.
	self boundingBoxChanged
]

{ #category : #memento }
WDELevelEditor3DBoxCornerHandle >> restoreMementoForDragging: memento [
	boundingBox := memento first.
	^ parent restoreTransformStateMemento: memento second
]

{ #category : #'as yet unclassified' }
WDELevelEditor3DBoxCornerHandle >> updateForViewCamera: view [
	super updateForViewCamera: view.
	self halfExtent: 0.005 * (self sizeScaleFactorForPosition: self position inView: view).

	view isPerspective ifTrue: [
		self visible: true.
	] ifFalse: [
		view hasFreeEditorViewType ifTrue: [
			self visible: true		
		] ifFalse: [
			| viewCorner |
			viewCorner := self manipulatedBoxCornerAxis * view validCameraOrientation.
			self visible: (viewCorner z closeTo: 0.0)
		].
	]

]
