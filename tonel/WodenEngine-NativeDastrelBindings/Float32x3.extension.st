Extension { #name : #Float32x3 }

{ #category : #'*WodenEngine-NativeDastrelBindings' }
Float32x3 class >> asDastrelConversionTypeWith: codeConverter [
	^ codeConverter sysmelStructureWrapper: self to: #float3
]

{ #category : #'*WodenEngine-NativeDastrelBindings' }
Float32x3 >> asDastrelLiteralAt: aPosition inContext: context for: variable [
	| type |
	type := self inferDastrelTypeIn: context for: nil.
	^ (context astBuilder literalVector: #float3 values: {
			context astBuilder literalFloat: x.
			context astBuilder literalFloat: y.
			context astBuilder literalFloat: z
		})
		position: aPosition;
		yourself
]

{ #category : #'*WodenEngine-NativeDastrelBindings' }
Float32x3 >> formatAsDastrelColor [
	^ 'float4({1}f, {2}f, {3}f, 1.0f)' format: {x . y . z}
]

{ #category : #'*WodenEngine-NativeDastrelBindings' }
Float32x3 >> inferDastrelTypeIn: context for: variable [
	^ #float3
]
