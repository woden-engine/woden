Extension { #name : #WDCRenderTargetFramebuffer }

{ #category : #'*WodenEngine-Babylon' }
WDCRenderTargetFramebuffer >> validBabylonSurface [
	^ self propertyAt: #babylonSurface ifAbsentPut: [
		(engine babylonDriver surfaceWithExtent: width @height sampleCount: 1)
			gpuOnly: true;
			yourself
	]
]
