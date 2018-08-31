Extension { #name : #BlockClosure }

{ #category : #'*WodenEngine-Core' }
BlockClosure >> noiseValueAt: coord withAmplitude: amplitude [
	self numArgs = 1 ifTrue: [ ^ (self value: coord) * amplitude ].
	self numArgs = 2 ifTrue: [ ^ self value: coord value: amplitude ].
	self error: 'Invalid noise function for fBM.'
]
