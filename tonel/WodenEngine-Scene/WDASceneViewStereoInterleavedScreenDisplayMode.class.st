Class {
	#name : #WDASceneViewStereoInterleavedScreenDisplayMode,
	#superclass : #WDASceneViewStereoScreenDisplayMode,
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #'viewport composition' }
WDASceneViewStereoInterleavedScreenDisplayMode >> fragmentShaderFileName [
	^ 'shaders/composition/interleaved.dastrel'
]
