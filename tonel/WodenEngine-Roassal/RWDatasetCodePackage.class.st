Class {
	#name : #RWDatasetCodePackage,
	#superclass : #RWDatasetCodeElement,
	#instVars : [
		'name',
		'classes'
	],
	#category : #'WodenEngine-Roassal-Dataset-Code'
}

{ #category : #building }
RWDatasetCodePackage >> buildFrom: rpackage [
	name := rpackage name.
	classes addAll: (rpackage classes collect: [ :each | RWDatasetCodeClass buildFrom: each ])
]

{ #category : #accessing }
RWDatasetCodePackage >> classes [

	^ classes
]

{ #category : #accessing }
RWDatasetCodePackage >> classes: anObject [

	classes := anObject
]

{ #category : #serialization }
RWDatasetCodePackage >> decodeFromJSON: jsonObject [
	name := jsonObject at: #name ifAbsent: [ '' ].
	jsonObject at: #classes ifPresent: [ :found |
		classes addAll: (found collect: [ :each | RWDatasetCodeClass decodeFromJSON: each ])
	].
]

{ #category : #serialization }
RWDatasetCodePackage >> encodeForJSON [
	^ OrderedDictionary newFromPairs: { 
		#name . name .
		#classes . (classes collect: [:each | each encodeForJSON ]).
	}
]

{ #category : #initialization }
RWDatasetCodePackage >> initialize [
	super initialize.
	classes := OrderedCollection new.
]

{ #category : #'source code management' }
RWDatasetCodePackage >> linesOfCode [
	"An approximate measure of lines of code.
	Includes comments, but excludes blank lines."
	^ classes inject: 0 into: [:sum :each | sum + each linesOfCode]
]

{ #category : #accessing }
RWDatasetCodePackage >> name [

	^ name
]

{ #category : #accessing }
RWDatasetCodePackage >> name: anObject [

	name := anObject
]

{ #category : #printing }
RWDatasetCodePackage >> printOn: aStream [
	aStream nextPutAll: 'Package '; nextPutAll: name
]
