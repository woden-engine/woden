Class {
	#name : #RWDatasetCodeMethod,
	#superclass : #RWDatasetCodeElement,
	#instVars : [
		'name',
		'linesOfCode',
		'sourceCode'
	],
	#category : #'WodenEngine-Roassal-Dataset-Code'
}

{ #category : #building }
RWDatasetCodeMethod >> buildFrom: method [
	name := method selector.
	linesOfCode := method linesOfCode.
	sourceCode := method sourceCode.
]

{ #category : #serialization }
RWDatasetCodeMethod >> decodeFromJSON: jsonObject [
	name := jsonObject at: #name ifAbsent: [ '' ].
	sourceCode := jsonObject at: #sourceCode ifAbsent: [ '' ].
	linesOfCode := jsonObject at: #linesOfCode ifAbsent: [ sourceCode lines size ].
]

{ #category : #serialization }
RWDatasetCodeMethod >> encodeForJSON [
	^ OrderedDictionary newFromPairs: { 
		#name . name.
		#linesOfCode . linesOfCode.
		#sourceCode . sourceCode.
	}
]

{ #category : #accessing }
RWDatasetCodeMethod >> linesOfCode [

	^ linesOfCode
]

{ #category : #accessing }
RWDatasetCodeMethod >> linesOfCode: anObject [

	linesOfCode := anObject
]

{ #category : #accessing }
RWDatasetCodeMethod >> name [

	^ name
]

{ #category : #accessing }
RWDatasetCodeMethod >> name: anObject [

	name := anObject
]

{ #category : #accessing }
RWDatasetCodeMethod >> sourceCode [

	^ sourceCode
]

{ #category : #accessing }
RWDatasetCodeMethod >> sourceCode: anObject [

	sourceCode := anObject
]
