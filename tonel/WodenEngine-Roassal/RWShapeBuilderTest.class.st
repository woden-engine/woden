Class {
	#name : #RWShapeBuilderTest,
	#superclass : #RWTest,
	#instVars : [
		'builder',
		'shapes'
	],
	#category : 'WodenEngine-Roassal-Builder'
}

{ #category : #running }
RWShapeBuilderTest >> setUp [

	builder := RWShapeBuilder new
]

{ #category : #tests }
RWShapeBuilderTest >> testColor [

	| e |
	builder rectangle color: Color blue.
	e := builder elementOn: 1.
	
	self assert: (e shape colorFor: e) equals: Color blue.
	self assert: e trachelShape color equals: Color blue.
]

{ #category : #tests }
RWShapeBuilderTest >> testColorIf [

	| e |
	builder box 
		if: true color: Color blue;
		if: true color: Color red.
	e := builder elementOn: 1.
	
	self assert: (e shape colorFor: e) equals: Color red.
	self assert: e trachelShape color equals: Color red.
]

{ #category : #'created elements' }
RWShapeBuilderTest >> testCreatingElements [
	builder rectangle.
	self assert: builder createdElements size = 0.
	builder elementsOn: (1 to: 10).
	self assert: builder createdElements size = 10.
	builder reset.
	self assert: builder createdElements size = 0.
]

{ #category : #tests }
RWShapeBuilderTest >> testFillColor [

	self assert: builder color isColor.
	self assert: builder fillColor isColor.
]

{ #category : #hasSetShape }
RWShapeBuilderTest >> testHasSetShape [

	"self deny: builder hasSetShape."
	builder rectangle.
	self assert: builder hasSetShape.
	"self deny: builder hasSetLineShape.
	
	builder line.
	self assert: builder hasSetShape.
	self assert: builder hasSetLineShape."
]

{ #category : #tests }
RWShapeBuilderTest >> testShape [
	| e1 e2 e3 |
	builder rectangle
		if: [ :o | o = 3 ] fillColor: Color blue;
		if: [ :o | o = 4 ] fillColor: Color red.
	e1 := builder elementOn: 3.
	e2 := builder elementOn: 4.
	e3 := builder elementOn: 5.
	
	self assert: (e1 shape colorFor: e1) = Color blue.
	self assert: e1 trachelShape color = Color blue.
	self assert: e2 trachelShape color = Color red.
	self assert: e3 trachelShape color = Color white.
]

{ #category : #tests }
RWShapeBuilderTest >> testShape2 [
	| e1 e2 e3 |
	builder rectangle
		ifElement: [ :el | el model = 3 ] fillColor: Color blue;
		ifElement: [ :el | el model = 4 ] fillColor: Color red.
	e1 := builder elementOn: 3.
	e2 := builder elementOn: 4.
	e3 := builder elementOn: 5.
	
	self assert: (e1 shape colorFor: e1) = Color blue.
	self assert: e1 trachelShape color = Color blue.
	self assert: e2 trachelShape color = Color red.
	self assert: e3 trachelShape color = Color white.
]
