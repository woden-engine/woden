Class {
	#name : #WDCAbstractProceduralMap,
	#superclass : #Object,
	#category : #'WodenEngine-Core-Texture'
}

{ #category : #'as yet unclassified' }
WDCAbstractProceduralMap >> asDastrelLiteralAt: aPosition inContext: context for: variable [
	^ (context codeConverter generateAnonymousFunction: self argumentTypes: #(float) returnType: #float4)
		position: aPosition;
		yourself
]

{ #category : #'as yet unclassified' }
WDCAbstractProceduralMap >> inferDastrelTypeIn: context for: var [
	^ context codeConverter functionTypeReturning: (context codeConverter evaluateTypeSpecification: #float4)
]

{ #category : #testing }
WDCAbstractProceduralMap >> isGrayscaleColorMap [
	^ false
]
