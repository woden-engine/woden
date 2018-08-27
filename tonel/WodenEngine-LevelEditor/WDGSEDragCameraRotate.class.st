Class {
	#name : #WDGSEDragCameraRotate,
	#superclass : #WDGSEDragTool,
	#category : #'WodenEngine-LevelEditor-Tools'
}

{ #category : #events }
WDGSEDragCameraRotate >> onDragEvent: event [
	| dragDelta angleDeltaVector |
	dragDelta := event delta.
	angleDeltaVector := WMVector3D x: dragDelta y negated degreesToRadians y: dragDelta x degreesToRadians negated.
	
	view cameraAngle: view cameraAngle + angleDeltaVector
]
