Class {
	#name : #WDASceneViewStereoAnaglyphScreenDisplayMode,
	#superclass : #WDASceneViewStereoScreenDisplayMode,
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #'viewport composition' }
WDASceneViewStereoAnaglyphScreenDisplayMode >> fragmentShaderFileName [
	^ 'shaders/composition/anaglyph.dastrel'
]
