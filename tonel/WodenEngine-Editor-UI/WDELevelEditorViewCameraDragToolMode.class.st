Class {
	#name : #WDELevelEditorViewCameraDragToolMode,
	#superclass : #WDELevelEditorViewDragToolMode,
	#category : #'WodenEngine-Editor-UI'
}

{ #category : #'event handling' }
WDELevelEditorViewCameraDragToolMode >> onMouseMove: event [
	event modifiers ctrl ifTrue: [
		^ view rotateCameraWithAngles: ((Float32x3 x: event delta y negated asFloat y: event delta x negated asFloat z: 0.0) * 0.01).
	].
	event modifiers shift ifTrue: [
		^ view translateCameraBy: ((Float32x3 x: event delta x asFloat y: 0.0 z: event delta y asFloat) * 0.01)
	].

	view translateCameraBy: ((Float32x3 x: event delta x asFloat y: event delta y negated asFloat z: 0.0) * 0.01)
]
