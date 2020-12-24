Class {
	#name : #WCADExamples,
	#superclass : #Object,
	#category : #'WodenEngine-CAD-Examples'
}

{ #category : #'as yet unclassified' }
WCADExamples class >> example01BooleanOperations [
	| box sphere cylinders solid |
	box := WCADSolid box.
	sphere := WCADSolid sphere radius: 0.6; subdivisions: 2.

	cylinders :=
		(WCADSolid cylinderX radius: 0.2) union:
		((WCADSolid cylinderY radius: 0.2) union:
		(WCADSolid cylinderZ radius: 0.2)).

	solid := (box intersection: sphere) - cylinders.
	solid bspTree saveWaveFrontObjTo: 'test.obj'
]
