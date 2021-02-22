Class {
	#name : #WDELevelEditorViewCameraDragToolMode,
	#superclass : #WDELevelEditorViewDragToolMode,
	#category : #'WodenEngine-Editor-UI-ViewMode'
}

{ #category : #'as yet unclassified' }
WDELevelEditorViewCameraDragToolMode >> modeName [
	^ 'Camera dragging'
]

{ #category : #'event handling' }
WDELevelEditorViewCameraDragToolMode >> onMouseDrag: event [
	event modifiers ctrl ifTrue: [
		view freePerspectiveView.
		^ view rotateCameraInPlaceWithAngles: ((Float32x3 x: event delta y negated asFloat y: event delta x negated asFloat z: 0.0) * 0.01).
	].
	event modifiers shift ifTrue: [
		^ view translateCameraBy: (self cameraXZDeltaToWorld: event delta)
	].

	view translateCameraBy: (self cameraXYDeltaToWorld: event delta)
]
