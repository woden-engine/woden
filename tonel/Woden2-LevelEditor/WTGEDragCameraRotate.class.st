Class {
	#name : #WTGEDragCameraRotate,
	#superclass : #WTGEDragTool,
	#category : 'Woden2-LevelEditor'
}

{ #category : #events }
WTGEDragCameraRotate >> onDragEvent: event [
	| dragDelta |
	dragDelta := event delta.
	view cameraAngle: view cameraAngle + (WMVector3D x: dragDelta y negated degreesToRadians y: dragDelta x degreesToRadians negated)
]
