Class {
	#name : #WDCWaveFormatChunk,
	#superclass : #SysmelStructureType,
	#instVars : [
		'#formatTag => UInt16',
		'#channels => UInt16',
		'#samplersPerSecond => UInt32',
		'#averageBytesPerSecond => UInt32',
		'#blockAlign => UInt16',
		'#bitsPerSample => UInt16',
		'#chunkBlockSize => UInt16',
		'#validBitsPerSample => UInt32',
		'#subFormat => (UInt8 array: 16)'
	],
	#category : #'WodenEngine-NativeStructures-Core-Sound'
}

{ #category : #accessing }
WDCWaveFormatChunk >> averageBytesPerSecond [
	^ averageBytesPerSecond
]

{ #category : #accessing }
WDCWaveFormatChunk >> averageBytesPerSecond: anObject [
	averageBytesPerSecond := anObject
]

{ #category : #accessing }
WDCWaveFormatChunk >> bitsPerSample [
	^ bitsPerSample
]

{ #category : #accessing }
WDCWaveFormatChunk >> bitsPerSample: anObject [
	bitsPerSample := anObject
]

{ #category : #accessing }
WDCWaveFormatChunk >> blockAlign [
	^ blockAlign
]

{ #category : #accessing }
WDCWaveFormatChunk >> blockAlign: anObject [
	blockAlign := anObject
]

{ #category : #accessing }
WDCWaveFormatChunk >> channels [
	^ channels
]

{ #category : #accessing }
WDCWaveFormatChunk >> channels: anObject [
	channels := anObject
]

{ #category : #accessing }
WDCWaveFormatChunk >> chunkBlockSize [
	^ chunkBlockSize
]

{ #category : #accessing }
WDCWaveFormatChunk >> chunkBlockSize: anObject [
	chunkBlockSize := anObject
]

{ #category : #accessing }
WDCWaveFormatChunk >> formatTag [
	^ formatTag
]

{ #category : #accessing }
WDCWaveFormatChunk >> formatTag: anObject [
	formatTag := anObject
]

{ #category : #accessing }
WDCWaveFormatChunk >> samplersPerSecond [
	^ samplersPerSecond
]

{ #category : #accessing }
WDCWaveFormatChunk >> samplersPerSecond: anObject [
	samplersPerSecond := anObject
]

{ #category : #accessing }
WDCWaveFormatChunk >> subFormat [
	^ subFormat
]

{ #category : #accessing }
WDCWaveFormatChunk >> subFormat: anObject [
	subFormat := anObject
]

{ #category : #accessing }
WDCWaveFormatChunk >> validBitsPerSample [
	^ validBitsPerSample
]

{ #category : #accessing }
WDCWaveFormatChunk >> validBitsPerSample: anObject [
	validBitsPerSample := anObject
]
