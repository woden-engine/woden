Extension { #name : #WDCEngine }

{ #category : #'*WodenEngine-Babylon' }
WDCEngine >> babylonDriver [
	^ babylonDriver ifNil: [ WDBBabylonDriver forEngine: self ]
]
