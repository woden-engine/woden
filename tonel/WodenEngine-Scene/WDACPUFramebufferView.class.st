Class {
	#name : #WDACPUFramebufferView,
	#superclass : #WDAViewWithStateTracker,
	#category : #'WodenEngine-Scene-CPUFramebuffer'
}

{ #category : #'rendering process stages' }
WDACPUFramebufferView >> doRenderingWith: stateTracker [
	| effectPass |
	effectPass := model formEffectFullscreenPass destinationRenderTarget: window validRenderTarget.
	stateTracker
		applyFullScreenPass: model currentFormDecodeFullscreenPass;
		applyFullScreenPass: effectPass
]
