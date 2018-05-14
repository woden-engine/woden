Extension { #name : #WDCRenderTargetFramebuffer }

{ #category : #'*WodenEngine-Pompeii' }
WDCRenderTargetFramebuffer >> validPompeiiSurface [
	^ self propertyAt: #pompeiiSurface ifAbsentPut: [
		(engine pompeiiDriver surfaceWithExtent: width @height sampleCount: 1)
			gpuOnly: true;
			yourself
	]
]
