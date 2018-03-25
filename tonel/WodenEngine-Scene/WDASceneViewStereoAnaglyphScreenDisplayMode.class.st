Class {
	#name : #WDASceneViewStereoAnaglyphScreenDisplayMode,
	#superclass : #WDASceneViewStereoScreenDisplayMode,
	#category : 'WodenEngine-Scene-Application'
}

{ #category : #'viewport composition' }
WDASceneViewStereoAnaglyphScreenDisplayMode >> fragmentShaderFileName [
	^ 'shaders/composition/anaglyph.dastrel'
]
