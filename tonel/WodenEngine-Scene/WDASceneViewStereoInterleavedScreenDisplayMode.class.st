Class {
	#name : #WDASceneViewStereoInterleavedScreenDisplayMode,
	#superclass : #WDASceneViewStereoScreenDisplayMode,
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #'viewport composition' }
WDASceneViewStereoInterleavedScreenDisplayMode >> fragmentShaderName [
	^ #interleaved
]
