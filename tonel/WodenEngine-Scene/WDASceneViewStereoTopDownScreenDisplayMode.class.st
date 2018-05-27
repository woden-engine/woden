Class {
	#name : #WDASceneViewStereoTopDownScreenDisplayMode,
	#superclass : #WDASceneViewStereoScreenDisplayMode,
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #'viewport composition' }
WDASceneViewStereoTopDownScreenDisplayMode >> fragmentShaderFileName [
	^ 'shaders/composition/topDown.dastrel'
]
