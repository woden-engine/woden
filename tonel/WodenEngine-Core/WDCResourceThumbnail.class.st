Class {
	#name : #WDCResourceThumbnail,
	#superclass : #Object,
	#instVars : [
		'name',
		'type',
		'value'
	],
	#category : #'WodenEngine-Core-Engine'
}

{ #category : #constructor }
WDCResourceThumbnail class >> type: type value: value [
	^ self new type: type; value: value; yourself
]

{ #category : #accessing }
WDCResourceThumbnail >> name [
	^ name
]

{ #category : #accessing }
WDCResourceThumbnail >> name: anObject [
	name := anObject
]

{ #category : #accessing }
WDCResourceThumbnail >> type [
	^ type
]

{ #category : #accessing }
WDCResourceThumbnail >> type: anObject [
	type := anObject
]

{ #category : #accessing }
WDCResourceThumbnail >> value [
	^ value
]

{ #category : #accessing }
WDCResourceThumbnail >> value: anObject [
	value := anObject
]
