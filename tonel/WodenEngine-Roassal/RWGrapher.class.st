Class {
	#name : #RWGrapher,
	#superclass : #RWBuilder,
	#instVars : [
		'datasets',
		'axisConfigurationX',
		'axisConfigurationY',
		'axisConfigurationZ',
		'minX',
		'maxX',
		'minY',
		'maxY',
		'minZ',
		'maxZ',
		'extent'
	],
	#category : 'WodenEngine-Roassal-Builder-Grapher'
}

{ #category : #public }
RWGrapher class >> sampleData [
	| res r |
	r := SharedRandom globalGenerator.
	
	res := OrderedCollection new.
	1 to: 20 do: [ :x | 
		1 to: 20 do: [ :z |
			res add: { x. r next * 10. z } ] ].
	^ res
]

{ #category : #adding }
RWGrapher >> add: aDataSet [
	"Essential method. Add a dataset into the grapher. Only non-empty set are considered"
	aDataSet numberOfPoints = 0 ifTrue: [ ^ self ].
	
	datasets add: aDataSet.
	aDataSet addedInBuilder: self
]

{ #category : #'public - axis' }
RWGrapher >> axisX [
	self checkIfDataSetHaveBeenAdded.
	"^ super axisX"
]

{ #category : #'public - axis' }
RWGrapher >> axisY [
	self checkIfDataSetHaveBeenAdded.
	"^ super axisX"
]

{ #category : #'public - axis' }
RWGrapher >> axisZ [
	self checkIfDataSetHaveBeenAdded.
	"^ super axisX"
]

{ #category : #utility }
RWGrapher >> checkIfDataSetHaveBeenAdded [
	datasets ifEmpty: [ self error: 'No dataset has been added?' ]
]

{ #category : #'min - max' }
RWGrapher >> datasetComputeMinAndMax [
	datasets do: #computeMinAndMax
]

{ #category : #accessing }
RWGrapher >> datasets [
	^ datasets copy
]

{ #category : #utility }
RWGrapher >> defineAxesIfNecessary [
	
	self isXAxisDefined ifFalse: [ self axisX ].
	self isYAxisDefined ifFalse: [ self axisY ].
	self isZAxisDefined ifFalse: [ self axisZ ].	
]

{ #category : #accessing }
RWGrapher >> extent [
	^ extent
]

{ #category : #accessing }
RWGrapher >> extent: anArray [
	extent := anArray
]

{ #category : #testing }
RWGrapher >> hasDataSet [
	^ self numberOfDataSets > 0
]

{ #category : #'min - max' }
RWGrapher >> homogenizeMinAndMax [
	
	minX := self minX.
	maxX := self maxX.
	minY := self minY.
	maxY := self maxY.
	minZ := self minZ.
	maxZ := self maxZ.
	datasets do: [ :ds |
		ds minX: minX.
		ds minY: minY.
		ds maxX: maxX.
		ds maxY: maxY.
		ds maxX: maxZ.
		ds maxY: maxZ. ]
]

{ #category : #initialization }
RWGrapher >> initialize [
	super initialize.
	
	"Collection of data sets"
	datasets := OrderedCollection new.

	minX := 0.
	minY := 0.
	minZ := 0.
	maxX := 0.
	maxY := 0.
	maxZ := 0.
	
	extent := #(10 10 10).
]

{ #category : #testing }
RWGrapher >> isXAxisDefined [
	"Return true is X axis has been defined"
	^ axisConfigurationX notNil
]

{ #category : #testing }
RWGrapher >> isYAxisDefined [
	"Return true is X axis has been defined"
	^ axisConfigurationY notNil
]

{ #category : #testing }
RWGrapher >> isZAxisDefined [
	"Return true is X axis has been defined"
	^ axisConfigurationZ notNil
]

{ #category : #accessing }
RWGrapher >> maxX [
	^ self hasDataSet 
		ifTrue: [ maxX max: self maxXFromDataSets ]
		ifFalse: [ maxX ]
]

{ #category : #accessing }
RWGrapher >> maxX: anObject [
	maxX := anObject
]

{ #category : #accessing }
RWGrapher >> maxXFromDataSets [
	^ (datasets collect: #maxX) max
]

{ #category : #accessing }
RWGrapher >> maxY [
	^ self hasDataSet 
		ifTrue: [ maxY max: self maxYFromDataSets ]
		ifFalse: [ maxY ] 
]

{ #category : #accessing }
RWGrapher >> maxY: anObject [
	maxY := anObject
]

{ #category : #accessing }
RWGrapher >> maxYFromDataSets [
	^ (datasets collect: #maxY) max
]

{ #category : #accessing }
RWGrapher >> maxZ [
	^ self hasDataSet 
		ifTrue: [ maxZ max: self maxYFromDataSets ]
		ifFalse: [ maxZ ] 
]

{ #category : #accessing }
RWGrapher >> maxZ: anObject [
	maxZ := anObject
]

{ #category : #accessing }
RWGrapher >> maxZFromDataSets [
	^ (datasets collect: #maxZ) max
]

{ #category : #accessing }
RWGrapher >> minX [
	^ self hasDataSet 
		ifTrue: [ minX min: self minXFromDataSets ]
		ifFalse: [ minX ]
]

{ #category : #accessing }
RWGrapher >> minX: anObject [
	minX := anObject
]

{ #category : #accessing }
RWGrapher >> minXFromDataSets [
	^ (datasets collect: #minX) min
]

{ #category : #accessing }
RWGrapher >> minY [
	^ self hasDataSet 
		ifTrue: [ minY min: self minYFromDataSets ]
		ifFalse: [ minY ] 
]

{ #category : #accessing }
RWGrapher >> minY: anObject [
	minY := anObject
]

{ #category : #accessing }
RWGrapher >> minYFromDataSets [
	^ (datasets collect: #minY) min
]

{ #category : #accessing }
RWGrapher >> minZ [
	^ minZ
]

{ #category : #accessing }
RWGrapher >> minZ: anObject [
	minZ := anObject
]

{ #category : #accessing }
RWGrapher >> minZFromDataSets [
	^ (datasets collect: #minZ) min
]

{ #category : #accessing }
RWGrapher >> numberOfDataSets [
	^ datasets size
]

{ #category : #rendering }
RWGrapher >> renderAxis [
]

{ #category : #rendering }
RWGrapher >> renderDataSetsIn: aView [
	datasets do: [ :aDataset | aDataset renderIn: aView ]
]

{ #category : #rendering }
RWGrapher >> renderIn: aView [
	self datasetComputeMinAndMax.
	self defineAxesIfNecessary.
	self homogenizeMinAndMax.
	self renderAxis.
"	self renderAllDecoratorsInFront."
	self renderDataSetsIn: aView.
"	self renderAllDecoratorsBehind"
]
