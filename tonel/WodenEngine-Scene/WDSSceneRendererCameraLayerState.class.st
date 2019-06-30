Class {
	#name : #WDSSceneRendererCameraLayerState,
	#superclass : #Object,
	#instVars : [
		'shaderBindings',
		'shaderBindingsBufferElement'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #'instance creation' }
WDSSceneRendererCameraLayerState class >> for: anEngine [
	^ self basicNew initializeWithEngine: anEngine
]

{ #category : #initialization }
WDSSceneRendererCameraLayerState >> initializeWithEngine: anEngine [
	| pool |
	pool := anEngine resourceCache streamingUniformBufferPoolFor: WTCameraState.
	shaderBindingsBufferElement := pool allocate.
	shaderBindings := (WDCSceneRenderingShaderSignature for: anEngine) newCameraState.
	shaderBindings bind: 0 uniformBufferElement: shaderBindingsBufferElement
]

{ #category : #accessing }
WDSSceneRendererCameraLayerState >> shaderBindings [
	^ shaderBindings
]

{ #category : #accessing }
WDSSceneRendererCameraLayerState >> shaderBindings: anObject [
	shaderBindings := anObject
]

{ #category : #accessing }
WDSSceneRendererCameraLayerState >> shaderBindingsBufferElement [
	^ shaderBindingsBufferElement
]

{ #category : #accessing }
WDSSceneRendererCameraLayerState >> shaderBindingsBufferElement: anObject [
	shaderBindingsBufferElement := anObject
]

{ #category : #'as yet unclassified' }
WDSSceneRendererCameraLayerState >> submitState: cameraState withTransform: transform [
	cameraState transform: transform.
	shaderBindingsBufferElement atomicSetValue: cameraState.

]
