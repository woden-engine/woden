Class {
	#name : #RWData,
	#superclass : #RWAbstractData,
	#instVars : [
		'dotBuilder'
	],
	#category : 'WodenEngine-Roassal-Builder-Grapher'
}

{ #category : #accessing }
RWData >> dotShape [
	^ dotBuilder
]

{ #category : #accessing }
RWData >> getValuesX [
	^ elements collect: x
]

{ #category : #accessing }
RWData >> getValuesY [
	^ elements collect: y
]

{ #category : #accessing }
RWData >> getValuesZ [
	^ elements collect: z
]

{ #category : #initialization }
RWData >> initialize [
	super initialize.
	dotBuilder := RWShapeBuilder new.
]

{ #category : #accessing }
RWData >> numberOfPoints [
	"Return the number of points the dataset is representing"
	^ elements size
]

{ #category : #accessing }
RWData >> points [
	^ elements collect: #model
]

{ #category : #accessing }
RWData >> points: objects [
	^ elements := dotBuilder elementsOn: objects
]

{ #category : #rendering }
RWData >> renderDotAndLinesIn: aView [

	builder view addAll: elements.
	"elements do: [ :el |  ]"
	RWMetricNormalizer new
		elements: elements;
		normalizeElementX: [ :anElement | x rwValue: anElement ]
			min: 0
			max: builder extent first
			minValue: minX
			maxValue: maxX.
			
	RWMetricNormalizer new
		elements: elements;
		normalizeElementY: [ :anElement | y rwValue: anElement ]
			min: 0
			max: builder extent second
			minValue: minY
			maxValue: maxY.

	RWMetricNormalizer new
		elements: elements;
		normalizeElementZ: [ :anElement | z rwValue: anElement ]
			min: 0
			max: builder extent third
			minValue: minZ
			maxValue: maxZ.
			
	elementActions do: [ :act | act rwValue: elements ].
			
]

{ #category : #rendering }
RWData >> renderIn: aView [

	self renderDotAndLinesIn: aView
]

{ #category : #accessing }
RWData >> x: blockOrSymbol [
	self xElement: [ :anElement | blockOrSymbol rwValue: anElement model ]
]

{ #category : #accessing }
RWData >> xElement: blockOrSymbol [
	x := blockOrSymbol
]

{ #category : #accessing }
RWData >> y [
	^ y
]

{ #category : #accessing }
RWData >> y: blockOrSymbol [
	self yElement: [ :anElement | blockOrSymbol rwValue: anElement model ]
]

{ #category : #accessing }
RWData >> yElement: blockOrSymbol [
	y := blockOrSymbol
]

{ #category : #accessing }
RWData >> z [
	^ z
]

{ #category : #accessing }
RWData >> z: blockOrSymbol [
	self zElement: [ :anElement | blockOrSymbol rwValue: anElement model ]
]

{ #category : #accessing }
RWData >> zElement: blockOrSymbol [
	z := blockOrSymbol
]
