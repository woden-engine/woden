Class {
	#name : #WDSDeferredSceneRenderer,
	#superclass : #WDSLightedSceneRenderer,
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #'rendering preparations' }
WDSDeferredSceneRenderer >> intermediateRenderTargetsClass [
	^ WDSForwardSceneRendererIntermediateTextures
]
