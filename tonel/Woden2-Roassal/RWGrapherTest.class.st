Class {
	#name : #RWGrapherTest,
	#superclass : #RWTest,
	#category : 'Woden2-Roassal-Builder-Grapher'
}

{ #category : #tests }
RWGrapherTest >> testBasic [

	| g d |
	g := RWGrapher new.
	d := RWData new.
	d points: #(#(1 2 3) #(5 0 3)).
	d x: #first.
	d y: #second.
	d z: #third.
	g add: d.
	g build

]
