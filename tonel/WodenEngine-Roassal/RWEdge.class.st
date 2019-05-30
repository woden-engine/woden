Class {
	#name : #RWEdge,
	#superclass : #RWElement,
	#instVars : [
		'controlPoints',
		'from',
		'to'
	],
	#category : 'WodenEngine-Roassal-Core'
}

{ #category : #constructions }
RWEdge class >> linesFor: aCollectionOfAssociations [
	^ aCollectionOfAssociations collect: [ :assoc | RWLine black elementFrom: assoc key to: assoc value ]
]

{ #category : #visiting }
RWEdge >> accept: aVisitor [
	^ aVisitor visitEdge: self
]

{ #category : #'as yet unclassified' }
RWEdge >> connectedElementChanged: anElement [
	self changed
]

{ #category : #accessing }
RWEdge >> controlPoint: at [
	controlPoints ifNil: [ self error: 'Not a bezier edge' ].
	^ controlPoints at: at
]

{ #category : #accessing }
RWEdge >> controlPoint: at put: controlPoint [
	controlPoints at: at put: controlPoint
]

{ #category : #accessing }
RWEdge >> controlPoints [
	
	^ controlPoints
]

{ #category : #accessing }
RWEdge >> controlPoints: anObject [
	
	controlPoints := anObject
]

{ #category : #accessing }
RWEdge >> extent [
	^ self localBoundingBox extent
]

{ #category : #accessing }
RWEdge >> from [
	
	^ from
]

{ #category : #accessing }
RWEdge >> from: anElement [
	from := anElement.
	anElement addConnectedEdge: self
]

{ #category : #accessing }
RWEdge >> fromPosition [
	^ from position
]

{ #category : #testing }
RWEdge >> isEdge [
	^ true.
]

{ #category : #printing }
RWEdge >> printOn: stream [
	stream nextPutAll: 'a RWEdge<'.
	model printOn: stream.
	stream nextPutAll: ', from: '.
	from printOn: stream.
	stream nextPutAll: ', to: '.
	to printOn: stream.
	stream nextPutAll: '>'.
]

{ #category : #'ray casting' }
RWEdge >> rayCast: ray [
	^ nil -> nil
]

{ #category : #accessing }
RWEdge >> to [
	
	^ to
]

{ #category : #accessing }
RWEdge >> to: anElement [
	to := anElement.
	anElement addConnectedEdge: self
]

{ #category : #accessing }
RWEdge >> toPosition [
	^ from position
]
