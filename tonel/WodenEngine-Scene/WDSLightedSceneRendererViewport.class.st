Class {
	#name : #WDSLightedSceneRendererViewport,
	#superclass : #WDSAbstractSceneRendererViewport,
	#instVars : [
		'lights',
		'sortedLights',
		'selectedLights',
		'lightRenderingStates',
		'gbufferRenderTarget',
		'sceneRenderTarget',
		'ambientOcclusionTexture',
		'globalLightingStateShaderBindings',
		'ambientOcclusionComputationArguments',
		'gbufferRenderPass',
		'sceneRenderPass',
		'ambientOcclusionHorizontalBlurArguments',
		'ambientOcclusionVerticalBlurArguments'
	],
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #adding }
WDSLightedSceneRendererViewport >> addLight: aLight [
	lights add: aLight
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> ambientOcclusionComputationArguments [
	^ ambientOcclusionComputationArguments
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> ambientOcclusionComputationArguments: anObject [
	ambientOcclusionComputationArguments := anObject
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> ambientOcclusionHorizontalBlurArguments [
	^ ambientOcclusionHorizontalBlurArguments
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> ambientOcclusionHorizontalBlurArguments: anObject [
	ambientOcclusionHorizontalBlurArguments := anObject
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> ambientOcclusionTexture [
	^ ambientOcclusionTexture
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> ambientOcclusionTexture: anObject [
	ambientOcclusionTexture := anObject
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> ambientOcclusionVerticalBlurArguments [
	^ ambientOcclusionVerticalBlurArguments
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> ambientOcclusionVerticalBlurArguments: anObject [
	ambientOcclusionVerticalBlurArguments := anObject
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> gbufferRenderPass [
	^ gbufferRenderPass
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> gbufferRenderPass: anObject [
	gbufferRenderPass := anObject
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> gbufferRenderTarget [
	^ gbufferRenderTarget
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> gbufferRenderTarget: anObject [
	gbufferRenderTarget := anObject
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> globalLightingStateShaderBindings [
	^ globalLightingStateShaderBindings
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> globalLightingStateShaderBindings: anObject [
	globalLightingStateShaderBindings := anObject
]

{ #category : #initialization }
WDSLightedSceneRendererViewport >> initialize [
	super initialize.
	lights := OrderedCollection new.
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> lightRenderingStates [
	^ lightRenderingStates
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> lightRenderingStates: anObject [
	lightRenderingStates := anObject
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> lights [
	^ lights
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> lights: anObject [
	lights := anObject
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> sceneRenderPass [
	^ sceneRenderPass
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> sceneRenderPass: anObject [
	sceneRenderPass := anObject
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> sceneRenderTarget [
	^ sceneRenderTarget
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> sceneRenderTarget: anObject [
	sceneRenderTarget := anObject
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> selectedLights [
	^ selectedLights
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> selectedLights: anObject [
	selectedLights := anObject
]

{ #category : #sorting }
WDSLightedSceneRendererViewport >> sortAndSelectLights [
	| cameraPosition |
	cameraPosition := self camera renderTransform translation.
	
	sortedLights := lights collect: [ :light |
		{ light . (light renderTransform translation - cameraPosition) length2 }
	].
	sortedLights sort: [ :a :b |
		a second < b second
	].

	selectedLights := sortedLights first: (sortedLights size min: 16).

]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> sortedLights [
	^ sortedLights
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> sortedLights: anObject [
	sortedLights := anObject
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> validGBufferRenderPass [
	^ gbufferRenderPass
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> validSceneRenderPass [
	self flag: 'TODO: Check this MT correctness.'.
	sceneRenderPass setColorClearValue: 0 value: self scene backgroundColor asAGPUColor4f.
	^ sceneRenderPass
]
