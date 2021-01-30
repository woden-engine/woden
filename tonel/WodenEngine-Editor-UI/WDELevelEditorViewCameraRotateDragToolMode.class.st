Class {
	#name : #WDELevelEditorViewCameraRotateDragToolMode,
	#superclass : #WDELevelEditorViewDragToolMode,
	#category : #'WodenEngine-Editor-UI-ViewMode'
}

{ #category : #'event handling' }
WDELevelEditorViewCameraRotateDragToolMode >> onMouseDrag: event [
	^ view rotateCameraWithAngles: ((Float32x3 x: event delta y negated asFloat y: event delta x negated asFloat z: 0.0) * 0.01).

]
