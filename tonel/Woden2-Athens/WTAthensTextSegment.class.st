Class {
	#name : #WTAthensTextSegment,
	#superclass : #AthensPathSegment,
	#instVars : [
		'endPoint',
		'string',
		'font'
	],
	#category : 'Woden2-Athens'
}

{ #category : #accessing }
WTAthensTextSegment >> endPoint [
	^ endPoint
]

{ #category : #accessing }
WTAthensTextSegment >> endPoint: anObject [
	endPoint := anObject
]

{ #category : #accessing }
WTAthensTextSegment >> font [
	^ font
]

{ #category : #accessing }
WTAthensTextSegment >> font: anObject [
	font := anObject
]

{ #category : #testing }
WTAthensTextSegment >> isTextSegment [
	^ true
]

{ #category : #accessing }
WTAthensTextSegment >> string [
	^ string
]

{ #category : #accessing }
WTAthensTextSegment >> string: anObject [
	string := anObject
]
