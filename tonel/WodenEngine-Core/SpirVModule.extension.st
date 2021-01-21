Extension { #name : #SpirVModule }

{ #category : #'*WodenEngine-Core' }
SpirVModule >> asWDCShaderCode [
	^ WDCShaderCode new data: self bytes; entryPoints: entryPoints; yourself
]
