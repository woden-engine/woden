Class {
	#name : #WTGEDragCameraTranslate,
	#superclass : #WTGEDragTool,
	#category : #'WodenEngine-LevelEditor-Old'
}

{ #category : #events }
WTGEDragCameraTranslate >> onDragEvent: event [
	| dragDelta depth |
	depth := view depthAtCameraDistance: 3.0.
	dragDelta := (view windowGlobalToLocal: event delta depth: depth) - (view windowGlobalToLocal: 0@0 depth: depth).
	(event modifiers ctrl or: [event modifiers cmd]) ifTrue: [ 
		dragDelta := dragDelta asWMVector3D.
		dragDelta := WMVector3D x: dragDelta x y: 0.0 z: dragDelta y negated
	].

	view cameraTransform translateBy: (view cameraTransform transformVector3: dragDelta asWMVector3D)
]
