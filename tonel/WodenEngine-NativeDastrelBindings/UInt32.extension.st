Extension { #name : #UInt32 }

{ #category : #'*WodenEngine-NativeDastrelBindings' }
UInt32 class >> asDastrelConversionTypeWith: codeConverter [
	^ DASLType uintType
]
