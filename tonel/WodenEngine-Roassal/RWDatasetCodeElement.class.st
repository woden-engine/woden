Class {
	#name : #RWDatasetCodeElement,
	#superclass : #Object,
	#category : #'WodenEngine-Roassal-Dataset-Code'
}

{ #category : #building }
RWDatasetCodeElement class >> buildFrom: rpackage [
	^ self new buildFrom: rpackage; yourself
]

{ #category : #serialization }
RWDatasetCodeElement class >> decodeFromJSON: jsonObject [
	^ self new decodeFromJSON: jsonObject; yourself
]

{ #category : #building }
RWDatasetCodeElement >> buildFrom: pharoMetaObject [
	self subclassResponsibility
]

{ #category : #serialization }
RWDatasetCodeElement >> decodeFromJSON: jsonObject [
	self subclassResponsibility
]

{ #category : #serialization }
RWDatasetCodeElement >> encodeForJSON [
	self subclassResponsibility
]
