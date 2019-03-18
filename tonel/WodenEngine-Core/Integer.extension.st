Extension { #name : #Integer }

{ #category : #'*WodenEngine-Core' }
Integer >> randomNoiseHash [
	"Hash function from: https://nullprogram.com/blog/2018/07/31/ and
	 https://github.com/skeeto/hash-prospector . Released by the original author on the public domain."
	| result |
	result := self & 16rFFFFFFFF.
	result := result bitXor: (result >> 16).
	result := (result * 16r7feb352d) & 16rFFFFFFFF.
	result := result bitXor: (result >> 15).
	result := (result * 16r846ca68b) & 16rFFFFFFFF.
	result := result bitXor: result >> 16.
	^ result
]

{ #category : #'*WodenEngine-Core' }
Integer >> randomNoiseHashNormalized [
	^ self randomNoiseHash / 4294967295.0
]
