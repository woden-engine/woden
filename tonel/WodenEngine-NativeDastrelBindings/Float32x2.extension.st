Extension { #name : #Float32x2 }

{ #category : #'*WodenEngine-NativeDastrelBindings' }
Float32x2 class >> asDastrelConversionTypeWith: codeConverter [
	^ codeConverter sysmelStructureWrapper: self to: #float2
]

{ #category : #'*WodenEngine-NativeDastrelBindings' }
Float32x2 >> asDastrelLiteralAt: aPosition inContext: context for: variable [
	| type |
	type := self inferDastrelTypeIn: context for: nil.
	^ (context astBuilder literalVector: #float2 values: {
			context astBuilder literalFloat: x.
			context astBuilder literalFloat: y
		})
		position: aPosition;
		yourself
]

{ #category : #'*WodenEngine-NativeDastrelBindings' }
Float32x2 >> formatAsDastrelColor [
	^ 'float4({1}f, {2}f, 0.0f, 1.0f)' format: {x . y}
]

{ #category : #'*WodenEngine-NativeDastrelBindings' }
Float32x2 >> inferDastrelTypeIn: context for: variable [
	^ #float2
]
