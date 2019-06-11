Extension { #name : #Stream }

{ #category : #'*WodenEngine-Core' }
Stream >> closureDescriptionForCaching [
	^ 'st ' , (SHA256 hashStream: self) hex
]
