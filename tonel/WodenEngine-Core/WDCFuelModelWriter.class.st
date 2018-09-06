"
I am woden model writer that uses fuel for saving models.
"
Class {
	#name : #WDCFuelModelWriter,
	#superclass : #WDCModelWriter,
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #accessing }
WDCFuelModelWriter class >> extension [
	^ 'fmdl'
]

{ #category : #accessing }
WDCFuelModelWriter >> save: model intoFileReference: aFileReference [
	FLSerializer serialize: model toFileNamed: aFileReference fullName
]
