Extension { #name : #Float32x4 }

{ #category : #'*WodenEngine-NativeDastrelBindings' }
Float32x4 class >> asDastrelConversionTypeWith: codeConverter [
	^ codeConverter sysmelStructureWrapper: self to: #float4
]

{ #category : #'*WodenEngine-NativeDastrelBindings' }
Float32x4 >> asDastrelLiteralAt: aPosition inContext: context for: variable [
	| type |
	type := self inferDastrelTypeIn: context for: nil.
	^ (context astBuilder literalVector: #float4 values: {
			context astBuilder literalFloat: x.
			context astBuilder literalFloat: y.
			context astBuilder literalFloat: z.
			context astBuilder literalFloat: w
		})
		position: aPosition;
		yourself
]

{ #category : #'*WodenEngine-NativeDastrelBindings' }
Float32x4 >> formatAsDastrelColor [
	^ 'float4({1}f, {2}f, {3}f, {4}f)' format: {x . y . z . w}
]

{ #category : #'*WodenEngine-NativeDastrelBindings' }
Float32x4 >> inferDastrelTypeIn: context for: variable [
	^ #float4
]
