Extension { #name : #Symbol }

{ #category : #'*WodenEngine-Core' }
Symbol >> noiseValueAt: coord withAmplitude: amplitude [
	^ (coord perform: self) * amplitude
]
