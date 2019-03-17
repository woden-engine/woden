Class {
	#name : #WDASceneViewStereoAnaglyphScreenDisplayMode,
	#superclass : #WDASceneViewStereoScreenDisplayMode,
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #'viewport composition' }
WDASceneViewStereoAnaglyphScreenDisplayMode >> fragmentShaderName [
	^ #anaglyph
]
