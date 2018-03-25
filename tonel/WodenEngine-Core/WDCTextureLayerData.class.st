Class {
	#name : #WDCTextureLayerData,
	#superclass : #Object,
	#instVars : [
		'width',
		'height',
		'depth',
		'levels'
	],
	#category : 'WodenEngine-Core-Texture'
}

{ #category : #accessing }
WDCTextureLayerData >> depth [
	^ depth
]

{ #category : #accessing }
WDCTextureLayerData >> depth: anObject [
	depth := anObject
]

{ #category : #accessing }
WDCTextureLayerData >> height [
	^ height
]

{ #category : #accessing }
WDCTextureLayerData >> height: anObject [
	height := anObject
]

{ #category : #accessing }
WDCTextureLayerData >> levels [
	^ levels
]

{ #category : #accessing }
WDCTextureLayerData >> levels: anObject [
	levels := anObject
]

{ #category : #accessing }
WDCTextureLayerData >> width [
	^ width
]

{ #category : #accessing }
WDCTextureLayerData >> width: anObject [
	width := anObject
]
