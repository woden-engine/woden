Class {
	#name : #WDSLightedSceneRendererViewport,
	#superclass : #WDSAbstractSceneRendererViewport,
	#instVars : [
		'sortedLights',
		'selectedLights',
		'lightRenderingStates',
		'gbufferRenderTarget',
		'ldrSceneRenderPass',
		'ldrSceneRenderTarget',
		'hdrToneMappingFullscreenPass',
		'ambientOcclusionTexture',
		'globalLightingStateShaderBindings',
		'ambientOcclusionComputationArguments',
		'gbufferRenderPass',
		'ambientOcclusionHorizontalBlurArguments',
		'ambientOcclusionVerticalBlurArguments',
		'skyLighting',
		'groundLighting',
		'sunDirection',
		'sceneLuminanceComputationPasses',
		'sceneHDRRenderPass',
		'sceneHDRRenderTarget',
		'sceneHDRColorTexture',
		'sceneHDRColorResolveTexture'
	],
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #adding }
WDSLightedSceneRendererViewport >> addBackgroundLight: aLight [
	backgroundLayer addLight: aLight
]

{ #category : #adding }
WDSLightedSceneRendererViewport >> addForegroundLight: aLight [
	foregroundLayer addLight: aLight
]

{ #category : #adding }
WDSLightedSceneRendererViewport >> addLight: aLight [
	normalLayer addLight: aLight
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

{ #category : #accessing }
WDSLightedSceneRendererViewport >> hdrToneMappingFullscreenPass [
	^ hdrToneMappingFullscreenPass
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> hdrToneMappingFullscreenPass: anObject [
	hdrToneMappingFullscreenPass := anObject
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
WDSLightedSceneRendererViewport >> sceneHDRColorResolveTexture [
	^ sceneHDRColorResolveTexture
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> sceneHDRColorResolveTexture: anObject [
	sceneHDRColorResolveTexture := anObject
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> sceneHDRColorTexture [
	^ sceneHDRColorTexture
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> sceneHDRColorTexture: anObject [
	sceneHDRColorTexture := anObject
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> sceneHDRRenderPass [
	^ sceneHDRRenderPass
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> sceneHDRRenderPass: anObject [
	sceneHDRRenderPass := anObject
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> sceneHDRRenderTarget [
	^ sceneHDRRenderTarget
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> sceneHDRRenderTarget: anObject [
	sceneHDRRenderTarget := anObject
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> sceneLDRRenderPass [
	^ ldrSceneRenderPass
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> sceneLDRRenderPass: anObject [
	ldrSceneRenderPass := anObject
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> sceneLDRRenderTarget [
	^ ldrSceneRenderTarget
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> sceneLDRRenderTarget: anObject [
	ldrSceneRenderTarget := anObject
]

{ #category : #'as yet unclassified' }
WDSLightedSceneRendererViewport >> sceneLuminanceComputationPasses [
	^ sceneLuminanceComputationPasses
]

{ #category : #'as yet unclassified' }
WDSLightedSceneRendererViewport >> sceneLuminanceComputationPasses: anArray [
	sceneLuminanceComputationPasses := anArray
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> selectedLights [
	^ selectedLights
]

{ #category : #asserting }
WDSLightedSceneRendererViewport >> shouldRenderBackgroundLayer [
	^ self camera usesSceneBackgroundLayer
]

{ #category : #asserting }
WDSLightedSceneRendererViewport >> shouldRenderForegroundLayer [
	^ self camera usesSceneForegroundLayer
]

{ #category : #sorting }
WDSLightedSceneRendererViewport >> sortAndSelectLights [
	| cameraPosition lightCollectBlock |
	cameraPosition := self camera globalTransform translation.
	
	lightCollectBlock := [ :light |
		{ light . (light transform translation - cameraPosition) length2 }
	].

	sortedLights := (backgroundLayer lights collect: lightCollectBlock) ,
		(normalLayer lights collect: lightCollectBlock) ,
		(foregroundLayer lights collect: lightCollectBlock).
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
WDSLightedSceneRendererViewport >> validSceneHDRRenderPass [
	self flag: 'TODO: Check this MT correctness.'.
	sceneHDRRenderPass setColorClearValue: 0 value: (self camera backgroundColor ifNil: [self scene backgroundColor]) asFloat32x4 asAGPUColor4f.
	^ sceneHDRRenderPass
]

{ #category : #accessing }
WDSLightedSceneRendererViewport >> validSceneLDRRenderPass [
	ldrSceneRenderPass setColorClearValue: 0 value: (self camera backgroundColor ifNil: [self scene backgroundColor]) asFloat32x4 asAGPUColor4f.
	^ ldrSceneRenderPass
]
