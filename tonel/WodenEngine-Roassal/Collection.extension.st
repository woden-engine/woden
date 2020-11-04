Extension { #name : #Collection }

{ #category : #'*WodenEngine-Roassal' }
Collection >> asRWElementList [
	^ RWElementList withAll: self
]
