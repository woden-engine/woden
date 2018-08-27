Class {
	#name : #WTGEDragCameraRotate,
	#superclass : #WTGEDragTool,
	#category : #'WodenEngine-LevelEditor-Old'
}

{ #category : #events }
WTGEDragCameraRotate >> onDragEvent: event [
	| dragDelta angleDeltaVector |
	dragDelta := event delta.
	angleDeltaVector := WMVector3D x: dragDelta y negated degreesToRadians y: dragDelta x degreesToRadians negated.
	
	view cameraAngle: view cameraAngle + angleDeltaVector
]
