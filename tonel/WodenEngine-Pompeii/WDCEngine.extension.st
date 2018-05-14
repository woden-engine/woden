Extension { #name : #WDCEngine }

{ #category : #'*WodenEngine-Pompeii' }
WDCEngine >> pompeiiDriver [
	^ pompeiiDriver ifNil: [ WDPPompeiiDriver forEngine: self ]
]
