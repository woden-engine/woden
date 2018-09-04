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

{ #category : #'as yet unclassified' }
WDCTextureLayerData >> generateLevelsWithBpp: bitsPerPixel [
	| levelWidth levelHeight levelDepth pitch slicePitch data |
	levelWidth := width.
	levelHeight := height.
	levelDepth := depth.
	levels := Array streamContents: [ :out |
		pitch := levelWidth * bitsPerPixel / 8 alignedTo: 4.
		slicePitch := pitch * levelHeight.
		data := ByteArray new: slicePitch * levelDepth.
		out nextPut: (WDCTextureLevelData new
				width: levelWidth;
				height: levelHeight;
				depth: levelDepth;
				pitch: pitch;
				slicePitch: slicePitch;
				data: data)
	]
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
