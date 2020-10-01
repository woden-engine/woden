Class {
	#name : #WDCDDSFileHeader,
	#superclass : #SysmelStructureType,
	#instVars : [
		'#size => UInt32',
		'#flags => UInt32',
		'#height => UInt32',
		'#width => UInt32',
		'#pitchOrLinearSize => UInt32',
		'#depth => UInt32',
		'#mipMapCount => UInt32',
		'#reserved1 => (UInt32 array: 11)',
		'#pixelFormat => WDCDDSPixelFormat',
		'#caps => UInt32',
		'#caps2 => UInt32',
		'#caps3 => UInt32',
		'#caps4 => UInt32',
		'#reserved2 => UInt32'
	],
	#category : #'WodenEngine-NativeStructures-Core-Texture'
}

{ #category : #accessing }
WDCDDSFileHeader >> caps [
	^ caps
]

{ #category : #accessing }
WDCDDSFileHeader >> caps2 [
	^ caps2
]

{ #category : #accessing }
WDCDDSFileHeader >> caps2: anObject [
	caps2 := anObject
]

{ #category : #accessing }
WDCDDSFileHeader >> caps3 [
	^ caps3
]

{ #category : #accessing }
WDCDDSFileHeader >> caps3: anObject [
	caps3 := anObject
]

{ #category : #accessing }
WDCDDSFileHeader >> caps4 [
	^ caps4
]

{ #category : #accessing }
WDCDDSFileHeader >> caps4: anObject [
	caps4 := anObject
]

{ #category : #accessing }
WDCDDSFileHeader >> caps: anObject [
	caps := anObject
]

{ #category : #accessing }
WDCDDSFileHeader >> depth [
	^ depth
]

{ #category : #accessing }
WDCDDSFileHeader >> depth: anObject [
	depth := anObject
]

{ #category : #accessing }
WDCDDSFileHeader >> flags [
	^ flags
]

{ #category : #accessing }
WDCDDSFileHeader >> flags: anObject [
	flags := anObject
]

{ #category : #accessing }
WDCDDSFileHeader >> height [
	^ height
]

{ #category : #accessing }
WDCDDSFileHeader >> height: anObject [
	height := anObject
]

{ #category : #accessing }
WDCDDSFileHeader >> mipMapCount [
	^ mipMapCount
]

{ #category : #accessing }
WDCDDSFileHeader >> mipMapCount: anObject [
	mipMapCount := anObject
]

{ #category : #accessing }
WDCDDSFileHeader >> pitchOrLinearSize [
	^ pitchOrLinearSize
]

{ #category : #accessing }
WDCDDSFileHeader >> pitchOrLinearSize: anObject [
	pitchOrLinearSize := anObject
]

{ #category : #accessing }
WDCDDSFileHeader >> pixelFormat [
	^ pixelFormat
]

{ #category : #accessing }
WDCDDSFileHeader >> pixelFormat: anObject [
	pixelFormat := anObject
]

{ #category : #accessing }
WDCDDSFileHeader >> reserved1 [
	^ reserved1
]

{ #category : #accessing }
WDCDDSFileHeader >> reserved1: anObject [
	reserved1 := anObject
]

{ #category : #accessing }
WDCDDSFileHeader >> reserved2 [
	^ reserved2
]

{ #category : #accessing }
WDCDDSFileHeader >> reserved2: anObject [
	reserved2 := anObject
]

{ #category : #accessing }
WDCDDSFileHeader >> size [
	^ size
]

{ #category : #accessing }
WDCDDSFileHeader >> size: anObject [
	size := anObject
]

{ #category : #accessing }
WDCDDSFileHeader >> width [
	^ width
]

{ #category : #accessing }
WDCDDSFileHeader >> width: anObject [
	width := anObject
]
