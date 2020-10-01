Class {
	#name : #WDCLodenFontHeader,
	#superclass : #SysmelStructureType,
	#instVars : [
		'#numberOfGlyphs => UInt32',
		'#numberOfCharMapEntries => UInt32',
		'#cellMargin => UInt32',
		'#pointSize => Float32',
		'#flags => UInt32'
	],
	#category : #'WodenEngine-NativeStructures-Core-Font'
}

{ #category : #accessing }
WDCLodenFontHeader >> cellMargin [
	^ cellMargin
]

{ #category : #accessing }
WDCLodenFontHeader >> cellMargin: anObject [
	cellMargin := anObject
]

{ #category : #accessing }
WDCLodenFontHeader >> flags [
	^ flags
]

{ #category : #accessing }
WDCLodenFontHeader >> flags: anObject [
	flags := anObject
]

{ #category : #accessing }
WDCLodenFontHeader >> numberOfCharMapEntries [
	^ numberOfCharMapEntries
]

{ #category : #accessing }
WDCLodenFontHeader >> numberOfCharMapEntries: anObject [
	numberOfCharMapEntries := anObject
]

{ #category : #accessing }
WDCLodenFontHeader >> numberOfGlyphs [
	^ numberOfGlyphs
]

{ #category : #accessing }
WDCLodenFontHeader >> numberOfGlyphs: anObject [
	numberOfGlyphs := anObject
]

{ #category : #accessing }
WDCLodenFontHeader >> pointSize [
	^ pointSize
]

{ #category : #accessing }
WDCLodenFontHeader >> pointSize: anObject [
	pointSize := anObject
]
