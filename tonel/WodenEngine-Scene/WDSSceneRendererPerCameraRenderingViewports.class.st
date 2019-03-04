Class {
	#name : #WDSSceneRendererPerCameraRenderingViewports,
	#superclass : #Object,
	#instVars : [
		'camera',
		'renderingViewports'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #accessing }
WDSSceneRendererPerCameraRenderingViewports >> camera [
	^ camera
]

{ #category : #accessing }
WDSSceneRendererPerCameraRenderingViewports >> camera: anObject [
	camera := anObject
]

{ #category : #accessing }
WDSSceneRendererPerCameraRenderingViewports >> renderingViewports [
	^ renderingViewports
]

{ #category : #accessing }
WDSSceneRendererPerCameraRenderingViewports >> renderingViewports: anObject [
	renderingViewports := anObject
]
