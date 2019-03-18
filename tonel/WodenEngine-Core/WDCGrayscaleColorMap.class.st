Class {
	#name : #WDCGrayscaleColorMap,
	#superclass : #WDCAbstractProceduralMap,
	#category : #'WodenEngine-Core-Texture'
}

{ #category : #converting }
WDCGrayscaleColorMap >> asDastrelColorMapFunction [
	| source |
	source := '
	function colorMapFunction(x: float) -> float4 {
		return float4(x, x, x, 1.0f);
	}
'.

	^ (DASLParser parse: source) modules first
]

{ #category : #testing }
WDCGrayscaleColorMap >> isGrayscaleColorMap [
	^ true
]

{ #category : #accessing }
WDCGrayscaleColorMap >> value: gray [
	^ Color gray: (gray min: 1.0 max: 0.0)
]
