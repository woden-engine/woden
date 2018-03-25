Class {
	#name : #RWLayoutTest,
	#superclass : #TestCase,
	#instVars : [
		'view',
		'element1',
		'element2',
		'element3'
	],
	#category : 'WodenEngine-Roassal-Tests'
}

{ #category : #running }
RWLayoutTest >> setUp [
	view := RWView new.
	element1 := RWCube element.
	element2 := RWCube element.
	element3 := RWCube element.
	view add: element1; add: element2; add: element3.
]

{ #category : #'test layout' }
RWLayoutTest >> testCircleLayout [
	| element4 |
	element4 := RWCube element.
	view add: element4.
	"element1 position: (R3Vector3 newX: 1 y: 1 z: 1)."

	RWCircleLayout on: { element1 . element2 . element3 . element4 }.
	
	self assert: element1 position equals: (WMVector3F x: 2.0 y: 0.0 z: 0.0).
	self assert: (element2 position closeTo: (WMVector3F x: 0.0 y: 2.0 z: 0.0)).
	self assert: (element3 position closeTo: (WMVector3F x: -2.0 y: 0.0 z: 0.0)).
	self assert: (element4 position closeTo: (WMVector3F x: 0.0 y: -2.0 z: 0.0)).
]

{ #category : #'test layout' }
RWLayoutTest >> testLineLayoutEmpty [
	RWYLineLayout on: #()
]

{ #category : #'test layout' }
RWLayoutTest >> testLineLayoutOpen [
	| window |
	RWYLineLayout on: { element1 . element2 . element3 }.
	
	self shouldnt: [ window :=  view open ] raise: Error.
	window close.
]

{ #category : #'test layout' }
RWLayoutTest >> testNoLayout [
	self assert: element1 position = element2 position.
	self assert: element1 position = element3 position.
]

{ #category : #'test layout' }
RWLayoutTest >> testSetup [

	self assert: view numberOfElements = 3.
]

{ #category : #'test layout' }
RWLayoutTest >> testSphereLayout [
	"RWSphereLayout is not implemented yet"
"	element1 position: (WDVector3 x: 1 y: 1 z: 1).
	RWSphereLayout on: { element1 }.
	
	self assert: (element1 position closeTo: (WDVector3 zero)).
	"
]

{ #category : #'test layout' }
RWLayoutTest >> testSphereLayout2 [
	"RWSphereLayout is not implemented yet"

	"RWSphereLayout on: { element1 . element2 . element3 }.
	
	self deny: (element1 position length closeTo: 0.0).
	self assert: (element1 position length closeTo: element2 position length).
	self assert: (element2 position length closeTo: element3 position length).
	"
]

{ #category : #'test layout' }
RWLayoutTest >> testTreeLayout [
	| a b c d elements assocs edges |
	
	"A simple tree."
	a := RWCube element.
	b := RWCube element.
	c := RWCube element.
	d := RWCube element.
	
	elements := { a . b . c . d }.
	assocs := { a -> b .  b -> c . b -> d }.
	edges := RWEdge linesFor: assocs.
	
	"Check the layout."
	RWGridTreeLayout on: elements edges: edges.
	self assert: (c position y closeTo: d position y).
	self assert: (b position y > c position y).
	self assert: (a position y > b position y).
]

{ #category : #'test layout' }
RWLayoutTest >> testXLineLayout [
	RWXLineLayout on: { element1 . element2 . element3 }.
	
	self assert: element1 position x < element2 position x.
	self assert: element2 position x < element3 position x.

	self assert: element1 position y = element2 position y.
	self assert: element2 position y = element3 position y.

	self assert: element1 position z = element2 position z.
	self assert: element2 position z = element3 position z.
	
]

{ #category : #'test layout' }
RWLayoutTest >> testYLineLayout [
	RWYLineLayout on: { element1 . element2 . element3 }.
	
	self assert: element1 position x = element2 position x.
	self assert: element2 position x = element3 position x.

	self assert: element1 position y < element2 position y.
	self assert: element2 position y < element3 position y.

	self assert: element1 position z = element2 position z.
	self assert: element2 position z = element3 position z.
	
]

{ #category : #'test layout' }
RWLayoutTest >> testZLineLayout [
	RWZLineLayout on: { element1 . element2 . element3 }.
	
	self assert: element1 position x = element2 position x.
	self assert: element2 position x = element3 position x.

	self assert: element1 position y = element2 position y.
	self assert: element2 position y = element3 position y.

	self assert: element1 position z < element2 position z.
	self assert: element2 position z < element3 position z.
	
]
