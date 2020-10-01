Class {
	#name : #WDCWaveHeader,
	#superclass : #SysmelStructureType,
	#instVars : [
		'#signature => UInt32',
		'#chunkSize => UInt32',
		'#waveID => UInt32'
	],
	#category : #'WodenEngine-NativeStructures-Core-Sound'
}

{ #category : #accessing }
WDCWaveHeader >> chunkSize [
	^ chunkSize
]

{ #category : #accessing }
WDCWaveHeader >> chunkSize: anObject [
	chunkSize := anObject
]

{ #category : #accessing }
WDCWaveHeader >> signature [
	^ signature
]

{ #category : #accessing }
WDCWaveHeader >> signature: anObject [
	signature := anObject
]

{ #category : #accessing }
WDCWaveHeader >> waveID [
	^ waveID
]

{ #category : #accessing }
WDCWaveHeader >> waveID: anObject [
	waveID := anObject
]
