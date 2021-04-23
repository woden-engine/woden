Class {
	#name : #RWDatasetCodeInstanceVariable,
	#superclass : #RWDatasetCodeElement,
	#instVars : [
		'name'
	],
	#category : #'WodenEngine-Roassal-Dataset-Code'
}

{ #category : #building }
RWDatasetCodeInstanceVariable >> buildFrom: slot [
	name := slot name
]

{ #category : #serialization }
RWDatasetCodeInstanceVariable >> decodeFromJSON: jsonObject [
	name := jsonObject at: #name ifAbsent: [ '' ].
]

{ #category : #serialization }
RWDatasetCodeInstanceVariable >> encodeForJSON [
	^ OrderedDictionary newFromPairs: { 
		#name . name.
	}
]

{ #category : #accessing }
RWDatasetCodeInstanceVariable >> name [

	^ name
]

{ #category : #accessing }
RWDatasetCodeInstanceVariable >> name: anObject [

	name := anObject
]

{ #category : #printing }
RWDatasetCodeInstanceVariable >> printOn: aStream [
	aStream nextPutAll: 'Instance variable '; nextPutAll: name
]
