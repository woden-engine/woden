Class {
	#name : #WDCWaveChunkHeader,
	#superclass : #SysmelStructureType,
	#instVars : [
		'#chunkID => UInt32',
		'#chunkSize => UInt32'
	],
	#category : #'WodenEngine-NativeStructures-Core-Sound'
}

{ #category : #accessing }
WDCWaveChunkHeader >> chunkID [
	^ chunkID
]

{ #category : #accessing }
WDCWaveChunkHeader >> chunkID: anObject [
	chunkID := anObject
]

{ #category : #accessing }
WDCWaveChunkHeader >> chunkSize [
	^ chunkSize
]

{ #category : #accessing }
WDCWaveChunkHeader >> chunkSize: anObject [
	chunkSize := anObject
]
