Class {
	#name : #WDCLinearRamp,
	#superclass : #Object,
	#instVars : [
		'edges'
	],
	#category : #'WodenEngine-Core-Texture'
}

{ #category : #'as yet unclassified' }
WDCLinearRamp class >> with: edges [
	^ self new edges: edges
]

{ #category : #converting }
WDCLinearRamp >> asMorph [
	^ self visualizationForm asMorph
]

{ #category : #accessing }
WDCLinearRamp >> edges [
	^ edges
]

{ #category : #accessing }
WDCLinearRamp >> edges: anObject [
	edges := anObject
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
	^ (v1*(1.0 - alpha)) + (v2*alpha)
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
