Extension { #name : #WDCRenderTargetFramebuffer }

{ #category : #'*WodenEngine-Babylon' }
WDCRenderTargetFramebuffer >> validPompeiiSurface [
	^ self propertyAt: #pompeiiSurface ifAbsentPut: [
		(engine babylonDriver surfaceWithExtent: width @height sampleCount: 1)
			gpuOnly: true;
			yourself
	]
]
