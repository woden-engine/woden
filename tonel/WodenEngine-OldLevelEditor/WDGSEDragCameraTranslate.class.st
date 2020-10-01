Class {
	#name : #WDGSEDragCameraTranslate,
	#superclass : #WDGSEDragTool,
	#category : #'WodenEngine-OldLevelEditor-Tools'
}

{ #category : #events }
WDGSEDragCameraTranslate >> onDragEvent: event [
	| dragDelta depth |
	depth := view depthAtCameraDistance: 3.0.
	dragDelta := (view windowGlobalToLocal: event delta depth: depth) - (view windowGlobalToLocal: 0@0 depth: depth).
	(event modifiers ctrl or: [event modifiers cmd]) ifTrue: [ 
		dragDelta := dragDelta asFloat64x3.
		dragDelta := Float64x3 x: dragDelta x y: 0.0 z: dragDelta y negated
	].

	view cameraTransform translateBy: (view cameraTransform transformVector3: dragDelta asFloat64x3)
]
