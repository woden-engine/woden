Extension { #name : #Collection }

{ #category : #'*Woden2-Roassal' }
Collection >> asRWGroup [
	^ RWGroup withAll: self
]
