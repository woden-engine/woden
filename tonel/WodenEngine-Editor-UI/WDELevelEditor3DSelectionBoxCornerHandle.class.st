Class {
	#name : #WDELevelEditor3DSelectionBoxCornerHandle,
	#superclass : #WDELevelEditor3DManipulator,
	#category : #'WodenEngine-Editor-UI'
}

{ #category : #removing }
WDELevelEditor3DSelectionBoxCornerHandle >> applyHighlightingEffect [
	sceneNode ifNotNil: [ sceneNode color: self currentColor ]
]

{ #category : #removing }
WDELevelEditor3DSelectionBoxCornerHandle >> createSceneNode [
	boundingBox isEmpty ifTrue: [ ^ nil ].
	^ WDSGSpatialObject new
		renderable: (self engine resourceCache flatShadedUnitCubeMesh copy
			depthTestingEnabled: false;
			depthWriteMask: false;
			renderPriority: WDCAbstractRenderable renderPriorityEditorTranslucentAfter + 1;
			setFlatColorSubRenderMode);
		color: self currentColor;
		transform: boundingBox reversibleTransformToConvertUnitBoxToMe;
		yourself.
]

{ #category : #removing }
WDELevelEditor3DSelectionBoxCornerHandle >> currentColor [
	^ highlighted
		ifTrue: [ Float32x4 ones  ]
		ifFalse: [ Float32x4 x: 0.6 y: 0.6 z: 0.6 w: 1.0 ]
]

{ #category : #'as yet unclassified' }
WDELevelEditor3DSelectionBoxCornerHandle >> currentDragToolClass [
	^ WDELevelEditorViewTranslateManipulatorDragToolMode
]

{ #category : #accessing }
WDELevelEditor3DSelectionBoxCornerHandle >> position [
	^ boundingBox center
]

{ #category : #accessing }
WDELevelEditor3DSelectionBoxCornerHandle >> position: position [
	boundingBox := BoxF32 center: position halfExtent: 0.1.
	sceneNode ifNotNil: [ 
		sceneNode transform: boundingBox reversibleTransformToConvertUnitBoxToMe
	]
]
