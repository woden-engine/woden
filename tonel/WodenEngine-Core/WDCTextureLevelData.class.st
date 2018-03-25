Class {
	#name : #WDCTextureLevelData,
	#superclass : #Object,
	#instVars : [
		'width',
		'height',
		'depth',
		'pitch',
		'slicePitch',
		'data'
	],
	#category : 'WodenEngine-Core-Texture'
}

{ #category : #accessing }
WDCTextureLevelData >> data [
	^ data
]

{ #category : #accessing }
WDCTextureLevelData >> data: anObject [
	data := anObject
]

{ #category : #accessing }
WDCTextureLevelData >> depth [
	^ depth
]

{ #category : #accessing }
WDCTextureLevelData >> depth: anObject [
	depth := anObject
]

{ #category : #accessing }
WDCTextureLevelData >> height [
	^ height
]

{ #category : #accessing }
WDCTextureLevelData >> height: anObject [
	height := anObject
]

{ #category : #accessing }
WDCTextureLevelData >> pitch [
	^ pitch
]

{ #category : #accessing }
WDCTextureLevelData >> pitch: anObject [
	pitch := anObject
]

{ #category : #accessing }
WDCTextureLevelData >> slicePitch [
	^ slicePitch
]

{ #category : #accessing }
WDCTextureLevelData >> slicePitch: anObject [
	slicePitch := anObject
]

{ #category : #accessing }
WDCTextureLevelData >> width [
	^ width
]

{ #category : #accessing }
WDCTextureLevelData >> width: anObject [
	width := anObject
]
