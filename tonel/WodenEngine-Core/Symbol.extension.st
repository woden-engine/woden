Extension { #name : #Symbol }

{ #category : #'*WodenEngine-Core' }
Symbol >> noiseValueAt: coord withAmplitude: amplitude [
	^ (coord perform: self) * amplitude
]

{ #category : #'*WodenEngine-Core' }
Symbol >> noiseValueAt: coord withAmplitude: amplitude withTilingPeriod: tilingPeriod [
	^ (coord perform: self with: tilingPeriod) * amplitude
]
