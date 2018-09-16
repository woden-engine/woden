Extension { #name : #Object }

{ #category : #'*WodenEngine-Core' }
Object >> addWodenResourceDependant: dependant [
]

{ #category : #'*WodenEngine-Core' }
Object >> closureDescriptionForCaching [
	^ self
]

{ #category : #'*WodenEngine-Core' }
Object >> isSessionPersistentExternalBuffer [
	^ false
]

{ #category : #'*WodenEngine-Core' }
Object >> linearRampMultiply: factor [
	^ self * factor
]

{ #category : #'*WodenEngine-Core' }
Object >> removeWodenResourceDependant: dependant [
]

{ #category : #'*WodenEngine-Core' }
Object >> resultForLinearInterpolation [
	^ self
]

{ #category : #'*WodenEngine-Core' }
Object >> valueForLinearInterpolation [
	^ self
]
