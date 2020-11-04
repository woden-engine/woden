"
I have a collection of examples for RWGrapher class
"
Class {
	#name : #RWGrapherExample,
	#superclass : #RWObject,
	#category : #'WodenEngine-Roassal-Builder-Grapher'
}

{ #category : #examples }
RWGrapherExample >> example01 [
	<script: 'self new example01'>
	| g d |
	g := RWGrapher new.
	d := RWData new.
	d points: #(#(10 0 0) #(0 10 0) #(0 0 10) #(0 0 0)).
	d x: #first.
	d y: #second.
	d z: #third.
	g add: d.
	g build.
	
	g view open

]

{ #category : #examples }
RWGrapherExample >> example02 [
	<script: 'self new example02'>
	| g d |
	g := RWGrapher new.
	d := RWData new.
	d points: RWShape withAllSubclasses.
	d x: [:m | m instVarNames size ].
	d y: #numberOfMethods.
	d z: #linesOfCode.
	g add: d.
	g build.
	g view addInteraction: RWOrbitController.
	g view open
]

{ #category : #examples }
RWGrapherExample >> example03 [
	<script: 'self new example03 open'>
	| g d |
	g := RWGrapher new.
	d := RWData new.
	d points: (0.0 to: 3.14 by: 0.1).
	d x: #sin.
	d y: #cos.
	d z: #yourself.
	g add: d.
	g build.
	g view addInteraction: RWOrbitController.
	^ g view

]

{ #category : #examples }
RWGrapherExample >> example04 [
	"
	self new sampleData
	"
	<script: 'self new example04 open'>
	| points g ds  colors view  |
	points := self sampleData.
	g := RWGrapher new.
	g extent: {20 . 20 . 20}.
	colors := (Color wheel: points size) asOrderedCollection.
	ds := RWData new.
	ds dotShape sphere
		size: 1;
		color: [ :sample | colors at: sample fourth ].
	ds points: points.
	ds
		x: #first;
		y: #second;
		z: [:m | m third ].
	g add: ds.
	g build.
	view := g view.
	view addInteraction: RWOrbitController.
	^ view
]

{ #category : #data }
RWGrapherExample >> sampleData [
	<script: 'self new sampleData inspect' >
	| res r |
	r := SharedRandom globalGenerator.
	
	res := OrderedCollection new.
	1 to: 20 do: [ :x | 
		1 to: 20 do: [ :z |
			res add: { x. r next * 10 + 1. z . res size + 1 } ] ].
	^ res
]
