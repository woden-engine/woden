Class {
	#name : #RWAbstractData,
	#superclass : #RWObject,
	#instVars : [
		'builder',
		'maxX',
		'maxY',
		'maxZ',
		'minX',
		'minY',
		'minZ',
		'x',
		'y',
		'z',
		'elements',
		'barBuilder',
		'elementActions'
	],
	#category : 'Woden2-Roassal-Builder-Grapher'
}

{ #category : #'as yet unclassified' }
RWAbstractData >> addedInBuilder: aBuilder [
	self builder: aBuilder.
]

{ #category : #'as yet unclassified' }
RWAbstractData >> builder: aBuilder [
	builder := aBuilder 
]

{ #category : #'as yet unclassified' }
RWAbstractData >> computeMinAndMax [
	self computeMinAndMaxForX.
	self computeMinAndMaxForY.
	self computeMinAndMaxForZ.
]

{ #category : #'as yet unclassified' }
RWAbstractData >> computeMinAndMaxForX [
	| computed |
	computed := elements collect: x.
	self assert: [ computed allSatisfy: [ :obj | obj isKindOf: Number ] ] description: 'You have provided objects that are not number. Please adjust what you provide to #points: #x: and #y:'.
	minX := computed min.
	maxX := computed max.

	(minX < 0 and: [ maxX < 0 ]) ifTrue: [ maxX := 0 ].
	(minX > 0 and: [ maxX > 0 ]) ifTrue: [ minX := 0 ].
	


]

{ #category : #'as yet unclassified' }
RWAbstractData >> computeMinAndMaxForY [
	| computed |
	computed := elements collect: y.
	self assert: [ computed allSatisfy: [ :obj | obj isKindOf: Number ] ] description: 'You have provided objects that are not number. Please adjust what you provide to #points: #x: and #y:'.
	minY := computed min.
	maxY := computed max.
	
	(minY < 0 and: [ maxY < 0 ]) ifTrue: [ maxY := 0 ].
	(minY > 0 and: [ maxY > 0 ]) ifTrue: [ minY := 0 ].
	
]

{ #category : #'as yet unclassified' }
RWAbstractData >> computeMinAndMaxForZ [
	| computed |
	computed := elements collect: z.
	self assert: [ computed allSatisfy: [ :obj | obj isKindOf: Number ] ] description: 'You have provided objects that are not number. Please adjust what you provide to #points: #x: and #y:'.
	minZ := computed min.
	maxZ := computed max.
	
	(minZ < 0 and: [ maxZ < 0 ]) ifTrue: [ maxZ := 0 ].
	(minZ > 0 and: [ maxZ > 0 ]) ifTrue: [ minZ := 0 ].
	
]

{ #category : #'as yet unclassified' }
RWAbstractData >> defaultMaxValue [
	^ 1000000
]

{ #category : #'as yet unclassified' }
RWAbstractData >> defaultMinValue [
	^ -1000000
]

{ #category : #'as yet unclassified' }
RWAbstractData >> elements [
	"Private method - not meant to be used by a end user.
	Return the elements added by the data"
	^ elements
]

{ #category : #'as yet unclassified' }
RWAbstractData >> getModelForElement: element atIndex: index [
	"Return the model that is used to insert a label for the element. index is index-th label to be provided."
	"The default behavior is simply to return the model of the element"
	^ element model
]

{ #category : #'as yet unclassified' }
RWAbstractData >> initialize [
	super initialize.
	elementActions := OrderedCollection new.
]

{ #category : #accessing }
RWAbstractData >> maxX [
	^ maxX
]

{ #category : #accessing }
RWAbstractData >> maxX: anObject [
	maxX := anObject
]

{ #category : #accessing }
RWAbstractData >> maxY [
	^ maxY
]

{ #category : #accessing }
RWAbstractData >> maxY: anObject [
	maxY := anObject
]

{ #category : #accessing }
RWAbstractData >> maxZ [
	^ maxZ
]

{ #category : #accessing }
RWAbstractData >> maxZ: anObject [
	maxZ := anObject
]

{ #category : #accessing }
RWAbstractData >> minX [
	^ minX
]

{ #category : #accessing }
RWAbstractData >> minX: anObject [
	minX := anObject
]

{ #category : #accessing }
RWAbstractData >> minY [
	^ minY
]

{ #category : #accessing }
RWAbstractData >> minY: anObject [
	minY := anObject
]

{ #category : #accessing }
RWAbstractData >> minZ [
	^ minZ
]

{ #category : #accessing }
RWAbstractData >> minZ: anObject [
	minZ := anObject
]
