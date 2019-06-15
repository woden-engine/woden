Class {
	#name : #WDCGrayscaleColorMap,
	#superclass : #WDCAbstractProceduralMap,
	#category : #'WodenEngine-Core-Texture'
}

{ #category : #converting }
WDCGrayscaleColorMap >> generateDastrelFunctionWith: codeConverter withName: requiredName argumentTypes: argumentType returnType: returnType [
	| source |
	source := 'function ' , requiredName , '(x: float) -> float4 {
		return float4(x, x, x, 1.0f);
	}
'.

	^ codeConverter parseFunctionDefinition: source
]

{ #category : #testing }
WDCGrayscaleColorMap >> isGrayscaleColorMap [
	^ true
]

{ #category : #accessing }
WDCGrayscaleColorMap >> value: gray [
	^ Color gray: (gray min: 1.0 max: 0.0)
]
