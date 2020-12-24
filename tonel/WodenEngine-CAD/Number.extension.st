Extension { #name : #Number }

{ #category : #'*WodenEngine-CAD' }
Number >> cm [
	^ self * 0.01
]

{ #category : #'*WodenEngine-CAD' }
Number >> km [
	^ self * 1000
]

{ #category : #'*WodenEngine-CAD' }
Number >> m [
	^ self
]
