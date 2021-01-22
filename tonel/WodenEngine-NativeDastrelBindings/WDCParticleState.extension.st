Extension { #name : #WDCParticleState }

{ #category : #'*WodenEngine-NativeDastrelBindings' }
WDCParticleState class >> asDastrelConversionTypeWith: codeConverter [
	^ codeConverter sysmelStructureWrapper: self to: #ParticleStateData
]
