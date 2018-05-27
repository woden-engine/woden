Class {
	#name : #WDASceneViewStereoSideBySideScreenDisplayMode,
	#superclass : #WDASceneViewStereoScreenDisplayMode,
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #'viewport composition' }
WDASceneViewStereoSideBySideScreenDisplayMode >> fragmentShaderFileName [
	^ 'shaders/composition/sideBySide.dastrel'
]
