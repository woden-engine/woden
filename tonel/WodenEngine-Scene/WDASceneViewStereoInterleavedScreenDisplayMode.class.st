Class {
	#name : #WDASceneViewStereoInterleavedScreenDisplayMode,
	#superclass : #WDASceneViewStereoScreenDisplayMode,
	#category : 'WodenEngine-Scene-Application'
}

{ #category : #'viewport composition' }
WDASceneViewStereoInterleavedScreenDisplayMode >> fragmentShaderFileName [
	^ 'shaders/composition/interleaved.dastrel'
]
