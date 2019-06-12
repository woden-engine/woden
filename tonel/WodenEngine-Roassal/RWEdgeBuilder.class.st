"
I am a basic edge builder for woden
"
Class {
	#name : #RWEdgeBuilder,
	#superclass : #RWObject,
	#instVars : [
		'view',
		'fromElements',
		'toElements',
		'createdEdges',
		'shape'
	],
	#category : #'WodenEngine-Roassal-Builder'
}

{ #category : #public }
RWEdgeBuilder >> connectFrom: fromBlock to: toBlock [
	self resetEdges.
	self fromElements copy do: [ :e|
		| fromElement toElement |
		fromElement := self fromElements 
			elementFromModel: (fromBlock rwValue: e model).
		toElement := self toElements 
			elementFromModel: (toBlock rwValue: e model).
		self createEdgeIfNecessaryFrom: fromElement to: toElement
		 ].
	^ createdEdges
]

{ #category : #private }
RWEdgeBuilder >> createEdgeIfNecessaryFrom: fromElement to: toElement [
	(self shouldCreateEdgeFrom: fromElement to: toElement)
		ifTrue: [ createdEdges add: (self edgeFrom: fromElement to: toElement) ]
]

{ #category : #accessing }
RWEdgeBuilder >> edgeFrom: fromElement to: toElement [
	view add: (self shape edgeFrom: fromElement to: toElement).
]

{ #category : #accessing }
RWEdgeBuilder >> elements: aCollection [
	self fromElements: aCollection.
	self toElements: aCollection.
]

{ #category : #accessing }
RWEdgeBuilder >> fromElements [
	fromElements ifNil: [ ^ self view elements ].
	^ fromElements
]

{ #category : #accessing }
RWEdgeBuilder >> fromElements: aCollection [
	fromElements := aCollection
]

{ #category : #initialization }
RWEdgeBuilder >> initialize [
	super initialize.
	self shape: RWLine new.
]

{ #category : #private }
RWEdgeBuilder >> resetEdges [
	createdEdges := RWGroup new
]

{ #category : #accessing }
RWEdgeBuilder >> shape [
	^ shape
]

{ #category : #accessing }
RWEdgeBuilder >> shape: aShapeBuilder [
	shape := aShapeBuilder
]

{ #category : #private }
RWEdgeBuilder >> shouldCreateEdgeFrom: fromElement to: toElement [
	"Return true if an edge has to be created"
	^ fromElement notNil
		and: [ toElement notNil and: [ fromElement ~~ toElement ] ]
]

{ #category : #accessing }
RWEdgeBuilder >> toElements [
	toElements ifNil: [ ^ self view elements ].
	^ toElements
]

{ #category : #accessing }
RWEdgeBuilder >> toElements: aCollection [
	toElements := aCollection
]

{ #category : #accessing }
RWEdgeBuilder >> view [
	^ view
]

{ #category : #accessing }
RWEdgeBuilder >> view: aView [
	view := aView
]
