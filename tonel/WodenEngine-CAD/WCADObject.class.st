Class {
	#name : #WCADObject,
	#superclass : #Object,
	#classVars : [
		'Epsilon'
	],
	#category : #'WodenEngine-CAD-CSG'
}

{ #category : #'class initialization' }
WCADObject class >> initialize [
	Epsilon := 1e-10.
]
