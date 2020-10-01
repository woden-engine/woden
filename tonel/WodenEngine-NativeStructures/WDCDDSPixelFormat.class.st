Class {
	#name : #WDCDDSPixelFormat,
	#superclass : #SysmelStructureType,
	#instVars : [
		'#size => UInt32',
		'#flags => UInt32',
		'#fourCC => UInt32',
		'#rgbBitCount => UInt32',
		'#rBitMask => UInt32',
		'#gBitMask => UInt32',
		'#bBitMask => UInt32',
		'#aBitMask => UInt32'
	],
	#category : #'WodenEngine-NativeStructures-Core-Texture'
}

{ #category : #accessing }
WDCDDSPixelFormat >> aBitMask [
	^ aBitMask
]

{ #category : #accessing }
WDCDDSPixelFormat >> aBitMask: anObject [
	aBitMask := anObject
]

{ #category : #accessing }
WDCDDSPixelFormat >> bBitMask [
	^ bBitMask
]

{ #category : #accessing }
WDCDDSPixelFormat >> bBitMask: anObject [
	bBitMask := anObject
]

{ #category : #accessing }
WDCDDSPixelFormat >> flags [
	^ flags
]

{ #category : #accessing }
WDCDDSPixelFormat >> flags: anObject [
	flags := anObject
]

{ #category : #accessing }
WDCDDSPixelFormat >> fourCC [
	^ fourCC
]

{ #category : #accessing }
WDCDDSPixelFormat >> fourCC: anObject [
	fourCC := anObject
]

{ #category : #accessing }
WDCDDSPixelFormat >> gBitMask [
	^ gBitMask
]

{ #category : #accessing }
WDCDDSPixelFormat >> gBitMask: anObject [
	gBitMask := anObject
]

{ #category : #accessing }
WDCDDSPixelFormat >> rBitMask [
	^ rBitMask
]

{ #category : #accessing }
WDCDDSPixelFormat >> rBitMask: anObject [
	rBitMask := anObject
]

{ #category : #accessing }
WDCDDSPixelFormat >> rgbBitCount [
	^ rgbBitCount
]

{ #category : #accessing }
WDCDDSPixelFormat >> rgbBitCount: anObject [
	rgbBitCount := anObject
]

{ #category : #accessing }
WDCDDSPixelFormat >> size [
	^ size
]

{ #category : #accessing }
WDCDDSPixelFormat >> size: anObject [
	size := anObject
]
