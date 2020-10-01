Class {
	#name : #WDGSEDragCameraRotate,
	#superclass : #WDGSEDragTool,
	#category : #'WodenEngine-OldLevelEditor-Tools'
}

{ #category : #events }
WDGSEDragCameraRotate >> onDragEvent: event [
	| dragDelta angleDeltaVector |
	dragDelta := event delta.
	angleDeltaVector := Float64x3 x: dragDelta y negated degreesToRadians y: dragDelta x degreesToRadians negated.
	
	view cameraAngle: view cameraAngle + angleDeltaVector
]
