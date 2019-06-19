"
I have values to handle the data with RWGrapher
"
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
	#category : #'WodenEngine-Roassal-Builder-Grapher'
}

{ #category : #accessing }
RWAbstractData >> addedInBuilder: aBuilder [
	self builder: aBuilder.
]

{ #category : #accessing }
RWAbstractData >> builder: aBuilder [
	builder := aBuilder 
]

{ #category : #'private computation' }
RWAbstractData >> computeMinAndMax [
	#(x y z) do: [ :sel | self computeMinAndMaxFor: sel ].
]

{ #category : #'private computation' }
RWAbstractData >> computeMinAndMaxFor: selector [
	| computed arg min max |
	arg := self perform: selector.
	computed := elements collect: arg .
	self
		 assert: [ computed allSatisfy: [ :obj | obj isNumber ] ] 
		description: 'You have provided objects that are not number.'.
	min := SmallInteger maxVal.
	max := SmallInteger minVal.
	computed do: [ :n | 
		min := min min: n.
		max := max max: n ].
	(min < 0 and: [max < 0])
		ifTrue: [ max := 0 ].
	(min > 0 and: [max > 0])
		ifTrue: [ min := 0 ].
	self 
		perform: ('min', selector asUppercase, ':') asSymbol 
		withArguments: (Array with: min).
	self 
		perform: ('max', selector asUppercase, ':') asSymbol 
		withArguments: (Array with: max).
]

{ #category : #accessing }
RWAbstractData >> elements [
	"Private method - not meant to be used by a end user.
	Return the elements added by the data"
	^ elements
]

{ #category : #accessing }
RWAbstractData >> getModelForElement: element atIndex: index [
	"Return the model that is used to insert a label for the element. index is index-th label to be provided."
	"The default behavior is simply to return the model of the element"
	^ element model
]

{ #category : #initialization }
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

{ #category : #'accessing - position' }
RWAbstractData >> x [
	^ x
]

{ #category : #'accessing - position' }
RWAbstractData >> x: blockOrSymbol [
	self xElement: [ :anElement | blockOrSymbol rwValue: anElement model ]
]

{ #category : #'accessing - position' }
RWAbstractData >> xElement: blockOrSymbol [
	x := blockOrSymbol
]

{ #category : #'accessing - position' }
RWAbstractData >> y [
	^ y
]

{ #category : #'accessing - position' }
RWAbstractData >> y: blockOrSymbol [
	self yElement: [ :anElement | blockOrSymbol rwValue: anElement model ]
]

{ #category : #'accessing - position' }
RWAbstractData >> yElement: blockOrSymbol [
	y := blockOrSymbol
]

{ #category : #'accessing - position' }
RWAbstractData >> z [
	^ z
]

{ #category : #'accessing - position' }
RWAbstractData >> z: blockOrSymbol [
	self zElement: [ :anElement | blockOrSymbol rwValue: anElement model ]
]

{ #category : #'accessing - position' }
RWAbstractData >> zElement: blockOrSymbol [
	z := blockOrSymbol
]
