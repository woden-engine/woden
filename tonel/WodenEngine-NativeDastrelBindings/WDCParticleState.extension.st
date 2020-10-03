Extension { #name : #WDCParticleState }

{ #category : #'*WodenEngine-NativeDastrelBindings' }
WDCParticleState >> asDastrelConversionTypeWith: codeConverter [
	^ codeConverter sysmelStructureWrapper: self to: #ParticleStateData
]
