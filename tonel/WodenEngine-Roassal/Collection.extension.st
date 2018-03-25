Extension { #name : #Collection }

{ #category : #'*WodenEngine-Roassal' }
Collection >> asRWGroup [
	^ RWGroup withAll: self
]
