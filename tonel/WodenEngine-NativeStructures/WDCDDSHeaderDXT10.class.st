Class {
	#name : #WDCDDSHeaderDXT10,
	#superclass : #SysmelStructureType,
	#instVars : [
		'#dxgiFormat => UInt32',
		'#resourceDimension => UInt32',
		'#miscFlag => UInt32',
		'#arraySize => UInt32',
		'#miscFlags2 => UInt32'
	],
	#category : #'WodenEngine-NativeStructures-Core-Texture'
}

{ #category : #accessing }
WDCDDSHeaderDXT10 >> arraySize [
	^ arraySize
]

{ #category : #accessing }
WDCDDSHeaderDXT10 >> arraySize: anObject [
	arraySize := anObject
]

{ #category : #accessing }
WDCDDSHeaderDXT10 >> dxgiFormat [
	^ dxgiFormat
]

{ #category : #accessing }
WDCDDSHeaderDXT10 >> dxgiFormat: anObject [
	dxgiFormat := anObject
]

{ #category : #accessing }
WDCDDSHeaderDXT10 >> miscFlag [
	^ miscFlag
]

{ #category : #accessing }
WDCDDSHeaderDXT10 >> miscFlag: anObject [
	miscFlag := anObject
]

{ #category : #accessing }
WDCDDSHeaderDXT10 >> miscFlags2 [
	^ miscFlags2
]

{ #category : #accessing }
WDCDDSHeaderDXT10 >> miscFlags2: anObject [
	miscFlags2 := anObject
]

{ #category : #accessing }
WDCDDSHeaderDXT10 >> resourceDimension [
	^ resourceDimension
]

{ #category : #accessing }
WDCDDSHeaderDXT10 >> resourceDimension: anObject [
	resourceDimension := anObject
]
