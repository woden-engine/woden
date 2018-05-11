Class {
	#name : #RWData,
	#superclass : #RWAbstractData,
	#instVars : [
		'dotBuilder'
	],
	#category : 'WodenEngine-Roassal-Builder-Grapher'
}

{ #category : #'as yet unclassified' }
RWData >> getValuesX [
	^ elements collect: x
]

{ #category : #'as yet unclassified' }
RWData >> getValuesY [
	^ elements collect: y
]

{ #category : #'as yet unclassified' }
RWData >> getValuesZ [
	^ elements collect: z
]

{ #category : #'as yet unclassified' }
RWData >> initialize [
	super initialize.
	dotBuilder := RWShapeBuilder new.
]

{ #category : #'as yet unclassified' }
RWData >> numberOfPoints [
	"Return the number of points the dataset is representing"
	^ elements size
]

{ #category : #'as yet unclassified' }
RWData >> points [
	^ elements collect: #model
]

{ #category : #'as yet unclassified' }
RWData >> points: objects [
	elements := dotBuilder elementsOn: objects
]

{ #category : #'as yet unclassified' }
RWData >> renderDotAndLinesIn: aView [

	builder view addAll: elements.
	"interaction setUpElements: elements."
	
	RWMetricNormalizer new
		elements: elements;
		normalizeElementX: [ :anElement | x rwValue: anElement ]
			min: 0
			max: builder extent x
			minValue: minX
			maxValue: maxX.
			
	RWMetricNormalizer new
		elements: elements;
		normalizeElementY: [ :anElement | y rwValue: anElement ]
			min: 0
			max: builder extent y negated
			minValue: minY
			maxValue: maxY.

	RWMetricNormalizer new
		elements: elements;
		normalizeElementZ: [ :anElement | z rwValue: anElement ]
			min: 0
			max: builder extent y negated
			minValue: minY
			maxValue: maxY.
			
	elementActions do: [ :act | act rwValue: elements ].
			
	"self renderLinesFor: elements in: aView"
]

{ #category : #'as yet unclassified' }
RWData >> renderIn: aView [

	self renderDotAndLinesIn: aView
]

{ #category : #'as yet unclassified' }
RWData >> x: blockOrSymbol [
	self xElement: [ :anElement | blockOrSymbol rwValue: anElement model ]
]

{ #category : #'as yet unclassified' }
RWData >> xElement: blockOrSymbol [
	x := blockOrSymbol
]

{ #category : #'as yet unclassified' }
RWData >> y [
	^ y
]

{ #category : #'as yet unclassified' }
RWData >> y: blockOrSymbol [
	self yElement: [ :anElement | blockOrSymbol rwValue: anElement model ]
]

{ #category : #'as yet unclassified' }
RWData >> yElement: blockOrSymbol [
	y := blockOrSymbol
]

{ #category : #'as yet unclassified' }
RWData >> z [
	^ z
]

{ #category : #'as yet unclassified' }
RWData >> z: blockOrSymbol [
	self zElement: [ :anElement | blockOrSymbol rwValue: anElement model ]
]

{ #category : #'as yet unclassified' }
RWData >> zElement: blockOrSymbol [
	z := blockOrSymbol
]
