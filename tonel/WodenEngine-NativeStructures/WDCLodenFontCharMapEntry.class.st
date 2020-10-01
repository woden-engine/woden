Class {
	#name : #WDCLodenFontCharMapEntry,
	#superclass : #SysmelStructureType,
	#instVars : [
		'#character => Int32',
		'#glyph => Int32'
	],
	#category : #'WodenEngine-NativeStructures-Core-Font'
}

{ #category : #accessing }
WDCLodenFontCharMapEntry >> character [
	^ character
]

{ #category : #accessing }
WDCLodenFontCharMapEntry >> character: anObject [
	character := anObject
]

{ #category : #accessing }
WDCLodenFontCharMapEntry >> glyph [
	^ glyph
]

{ #category : #accessing }
WDCLodenFontCharMapEntry >> glyph: anObject [
	glyph := anObject
]
