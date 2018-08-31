Extension { #name : #Number }

{ #category : #'*WodenEngine-Core' }
Number >> cubicHemineCurve [
	^ self * self * (3.0 - (2.0*self))
]

{ #category : #'*WodenEngine-Core' }
Number >> floorFract [
	^ self - self floor
]

{ #category : #'*WodenEngine-Core' }
Number >> randomNoise [
	^ (self sin * 543414.1841453565) floorFract 
	
]

{ #category : #'*WodenEngine-Core' }
Number >> signedRandomNoise [
	^ self randomNoise * 2.0 - 1.0

]

{ #category : #'*WodenEngine-Core' }
Number >> signedValueNoise [
	^ self valueNoise * 2.0 - 1.0
]

{ #category : #'*WodenEngine-Core' }
Number >> smoothInterpolateTo: aNumber at: param [
	^ self interpolateTo: aNumber at: param cubicHemineCurve
]

{ #category : #'*WodenEngine-Core' }
Number >> valueNoise [
	| lower |
	lower := self floor.
	^ lower randomNoise interpolateTo: (lower + 1.0) randomNoise at: (self - lower) cubicHemineCurve
]
