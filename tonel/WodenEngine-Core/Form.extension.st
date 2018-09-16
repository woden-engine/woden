Extension { #name : #Form }

{ #category : #'*WodenEngine-Core' }
Form >> asSRGBTextureFor: anEngine [
	^ anEngine createTextureFromForm: self
]

{ #category : #'*WodenEngine-Core' }
Form >> asTextureFor: anEngine [
	^ anEngine createLinearTextureFromForm: self
]

{ #category : #'*WodenEngine-Core' }
Form >> thumbnail [
	^ self
]
