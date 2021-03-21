Class {
	#name : #WDSGSceneLayer,
	#superclass : #WDSGNode,
	#instVars : [
		'renderingRenderables'
	],
	#category : #'WodenEngine-Scene-Graph'
}

{ #category : #adding }
WDSGSceneLayer >> addRenderingRenderables: aCollection [
	renderingRenderables addAll: aCollection
]

{ #category : #initialization }
WDSGSceneLayer >> initialize [
	super initialize.
	renderingRenderables := OrderedCollection new.
	
]

{ #category : #initialization }
WDSGSceneLayer >> postCopyCommon [
	renderingRenderables := OrderedCollection new.
	super postCopyCommon.

]

{ #category : #adding }
WDSGSceneLayer >> removeRenderingRenderables: aCollection [
	renderingRenderables removeAll: aCollection
]

{ #category : #accessing }
WDSGSceneLayer >> renderingRenderables [
	^ renderingRenderables
]

{ #category : #accessing }
WDSGSceneLayer >> sceneLayer [
	^ self
]

{ #category : #'renderable state' }
WDSGSceneLayer >> updateCommonGpuStateForFrame: fullFrameIndex [
	renderingRenderables do: [ :renderingRenderable |
		renderingRenderable updateCommonGpuStateForFrame: fullFrameIndex
	]

]
