Extension { #name : #Symbol }

{ #category : #'*WodenEngine-Roassal' }
Symbol >> rwValue: anObject [ 
	^ anObject perform: self
]
