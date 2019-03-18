Class {
	#name : #WDCLinearRamp,
	#superclass : #WDCAbstractProceduralMap,
	#instVars : [
		'edges'
	],
	#category : #'WodenEngine-Core-Texture'
}

{ #category : #'as yet unclassified' }
WDCLinearRamp class >> with: edges [
	^ self new edges: edges
]

{ #category : #'dastrel color ramp' }
WDCLinearRamp >> asDastrelColorMapFunction [
	| source |
	source := ByteString streamContents: [ :out |
		out nextPutAll: 'function colorMapFunction(x: float) -> float4 {'; lf.
		
		out nextPutAll: ('if(x < {1}f) return {2};' format: {edges first key asFloat . edges first value valueForLinearInterpolation formatAsDastrelColor}); lf.
		out nextPutAll: ('if(x > {1}f) return {2};' format: {edges last key asFloat . edges last value valueForLinearInterpolation formatAsDastrelColor}); lf.
		
		out tab; nextPutAll: 'let result : float4;'; lf.
		self emitDastrelColorMapPartitionStart: 1 size: edges size - 1 into: out.
	
		out tab; nextPutAll: 'return result;'; lf.
		out nextPutAll: '}'; lf
	].

	^ (DASLParser parse: source) modules first
]

{ #category : #converting }
WDCLinearRamp >> asMorph [
	^ self visualizationForm asMorph
]

{ #category : #'dastrel color ramp' }
WDCLinearRamp >> constructDastrelAlphaLeft: leftEdgePosition right: rightEdgePosition [
	^ '(x - {1}f)*{2}f' format: { leftEdgePosition asFloat . (rightEdgePosition - leftEdgePosition) reciprocal asFloat}.
]

{ #category : #'dastrel color ramp' }
WDCLinearRamp >> constructDastrelMix: leftColor with: rightColor at: alpha [
	^ 'mix({1}, {2}, {3})' format: { leftColor . rightColor . alpha}
]

{ #category : #accessing }
WDCLinearRamp >> edges [
	^ edges
]

{ #category : #accessing }
WDCLinearRamp >> edges: anObject [
	edges := anObject
]

{ #category : #'dastrel color ramp' }
WDCLinearRamp >> emitDastrelColorMapPartitionStart: partitionIndex size: partitionSize into: out [
	| leftEdge rightEdge alpha leftColor rightColor leftSize rightSize partitionMiddle partitionEdges |
	partitionSize == 0 ifTrue: [ 
		self error: 'This should not happen.'
	].

	partitionSize == 1 ifTrue: [
		leftEdge := edges at: partitionIndex.
		rightEdge := edges at: partitionIndex + 1.
		alpha := self constructDastrelAlphaLeft: leftEdge key right: rightEdge key.
		leftColor := leftEdge value valueForLinearInterpolation formatAsDastrelColor.
		rightColor := rightEdge value valueForLinearInterpolation formatAsDastrelColor.
		^ out nextPutAll: 'result = '; nextPutAll: (self constructDastrelMix: leftColor with: rightColor at: alpha); nextPut: $;; lf
	].

	leftSize := partitionSize // 2.
	rightSize := partitionSize - leftSize.
	partitionMiddle := partitionIndex + leftSize.

	partitionEdges := edges at: partitionMiddle.
	out nextPutAll: ('if(x < {1}f) ' format: {partitionEdges key asFloat}); nextPut: ${; lf.
		self emitDastrelColorMapPartitionStart: partitionIndex size: leftSize into: out.
	out nextPutAll: '} else {'; lf.
		self emitDastrelColorMapPartitionStart: partitionMiddle size: rightSize into: out.
	out nextPut: $}; lf.
]

{ #category : #accessing }
WDCLinearRamp >> evalValue: aValue between: lowerEdge and: upperEdge [
	| alpha |
	self assert: lowerEdge key <= aValue.
	self assert: aValue <= upperEdge key.
	alpha := (aValue - lowerEdge key) / (upperEdge key - lowerEdge key).
	^ (self interpolate: lowerEdge value valueForLinearInterpolation with: upperEdge value valueForLinearInterpolation at: alpha) resultForLinearInterpolation
]

{ #category : #'as yet unclassified' }
WDCLinearRamp >> gtInspectorFormIn: composite [
	<gtInspectorPresentationOrder: 0>  
	^ composite morph 
		title: 'Color ramp';
		display: [ self asMorph ]
]

{ #category : #accessing }
WDCLinearRamp >> interpolate: v1 with: v2 at: alpha [
	^ (v1 linearRampMultiply: (1.0 - alpha)) + (v2 linearRampMultiply: alpha)
]

{ #category : #'as yet unclassified' }
WDCLinearRamp >> isColorRamp [
	^ edges first value isColor
]

{ #category : #accessing }
WDCLinearRamp >> value: aValue [
	| lastEdge |
	self flag: 'TODO: Use a binary search.'.
	lastEdge := nil.
	
	edges do: [ :edge |
		edge key >= aValue ifTrue: [ 
			lastEdge ifNil: [ ^ edge value ].
			^ self evalValue: aValue between: lastEdge and: edge
		].
	
		lastEdge := edge
	].

	^ lastEdge value
]

{ #category : #converting }
WDCLinearRamp >> visualizationColors [
	| parts |
	parts := 128. 
	^ (0 to: parts - 1) collect: [ :i |
		(self value: (i / (parts - 1)) asFloat) asVisualizationColor
	]
]

{ #category : #converting }
WDCLinearRamp >> visualizationForm [
	| colors form height |
	colors := self visualizationColors.
	height := 16.
	form := Form extent: colors size @ height depth: 32.
	colors doWithIndex: [ :color :i |
		0 to: height -1 do: [ :y |
			form colorAt: (i-1)@y put: color 
		]
	].
	^ form
]
