Class {
	#name : #WDCLodenFontGlyphMetadata,
	#superclass : #SysmelStructureType,
	#instVars : [
		'#box => RectangleF32',
		'#advance => Float32x2',
		'#size => Float32x2',
		'#horizontalBearing => Float32x2',
		'#verticalBearing => Float32x2'
	],
	#category : #'WodenEngine-NativeStructures-Core-Font'
}

{ #category : #accessing }
WDCLodenFontGlyphMetadata >> advance [
	^ advance
]

{ #category : #accessing }
WDCLodenFontGlyphMetadata >> advance: anObject [
	advance := anObject
]

{ #category : #accessing }
WDCLodenFontGlyphMetadata >> box [
	^ box
]

{ #category : #accessing }
WDCLodenFontGlyphMetadata >> box: anObject [
	box := anObject
]

{ #category : #metrics }
WDCLodenFontGlyphMetadata >> computeDestinationRectangleWithScale: scale margin: margin position: position [
	| drawPosition drawExtent |
	drawPosition := position + ((Float32x2 x: horizontalBearing x - margin y: (horizontalBearing y + margin) negated) * scale).
	drawExtent := (box max - box min + (Float32x2 x: margin * 2.0 y: margin * 2.0)) * scale.
	^ RectangleF32 min: drawPosition max: drawPosition + drawExtent
]

{ #category : #metrics }
WDCLodenFontGlyphMetadata >> computePreciseAscent [
	^ horizontalBearing y
]

{ #category : #metrics }
WDCLodenFontGlyphMetadata >> computePreciseDescent [
	^ box max y - box min y - self computePreciseAscent
]

{ #category : #metrics }
WDCLodenFontGlyphMetadata >> computeSourceRectangleWithTexcoordScale: texcoordScale margin: margin [
	^ RectangleF32
		min: ((box min - (Float32x2 x: margin y: margin)) * texcoordScale)
		max: ((box max + (Float32x2 x: margin y: margin)) * texcoordScale)
]

{ #category : #metrics }
WDCLodenFontGlyphMetadata >> height [
	^ box height
]

{ #category : #accessing }
WDCLodenFontGlyphMetadata >> horizontalBearing [
	^ horizontalBearing
]

{ #category : #accessing }
WDCLodenFontGlyphMetadata >> horizontalBearing: anObject [
	horizontalBearing := anObject
]

{ #category : #accessing }
WDCLodenFontGlyphMetadata >> size [
	^ size
]

{ #category : #accessing }
WDCLodenFontGlyphMetadata >> size: anObject [
	size := anObject
]

{ #category : #accessing }
WDCLodenFontGlyphMetadata >> verticalBearing [
	^ verticalBearing
]

{ #category : #accessing }
WDCLodenFontGlyphMetadata >> verticalBearing: anObject [
	verticalBearing := anObject
]
