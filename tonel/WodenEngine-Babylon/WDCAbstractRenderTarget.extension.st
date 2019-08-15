Extension { #name : #WDCAbstractRenderTarget }

{ #category : #'*WodenEngine-Babylon' }
WDCAbstractRenderTarget >> validBabylonSurface [
	^ self currentFramebuffer validBabylonSurface
]
