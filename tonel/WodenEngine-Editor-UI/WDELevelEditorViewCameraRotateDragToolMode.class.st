Class {
	#name : #WDELevelEditorViewCameraRotateDragToolMode,
	#superclass : #WDELevelEditorViewDragToolMode,
	#category : #'WodenEngine-Editor-UI'
}

{ #category : #'event handling' }
WDELevelEditorViewCameraRotateDragToolMode >> onMouseMove: event [
	^ view rotateCameraWithAngles: ((Float32x3 x: event delta y negated asFloat y: event delta x negated asFloat z: 0.0) * 0.01).

]
