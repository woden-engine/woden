Class {
	#name : #RWGrapherExample,
	#superclass : #RWObject,
	#category : 'WodenEngine-Roassal-Builder-Grapher'
}

{ #category : #'as yet unclassified' }
RWGrapherExample >> example01 [
	"
	self new example01
	"	
	| g d |
	g := RWGrapher new.
	d := RWData new.
	d points: #(#(10 0 0) #(0 10 0) #(0 0 10) #(0 0 0)).
	d x: #first.
	d y: #second.
	d z: #third.
	g add: d.
	g build.
	g view addInteraction: OrbitController.
	^ g view

]

{ #category : #'as yet unclassified' }
RWGrapherExample >> example02 [
	"
	self new example02
	"	
	| g d |
	g := RWGrapher new.
	d := RWData new.
	d points: RTShape withAllSubclasses.
	d x: #numberOfVariables.
	d y: #numberOfMethods.
	d z: #numberOfLinesOfCode.
	g add: d.
	g build.
	g view addInteraction: OrbitController.
	^ g view

]

{ #category : #'as yet unclassified' }
RWGrapherExample >> example03 [
	"
	self new example01
	"	
	| g d |
	g := RWGrapher new.
	d := RWData new.
	d points: (0.0 to: 3.14 by: 0.1).
	d x: #sin.
	d y: #cos.
	d z: #yourself.
	g add: d.
	g build.
	g view addInteraction: OrbitController.
	^ g view

]
