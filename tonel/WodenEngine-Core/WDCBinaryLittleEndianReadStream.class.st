"
I am a stream for reading little endian encoded binary data.
"
Class {
	#name : #WDCBinaryLittleEndianReadStream,
	#superclass : #DecoratorStream,
	#category : #'WodenEngine-Core-Stream'
}

{ #category : #accessing }
WDCBinaryLittleEndianReadStream >> next: anInteger [
	^ decoratedStream next: anInteger
]

{ #category : #accessing }
WDCBinaryLittleEndianReadStream >> nextFloat32 [
	^ Float fromIEEE32Bit: self nextUInt32
]

{ #category : #accessing }
WDCBinaryLittleEndianReadStream >> nextFloat64 [
	^ Float fromIEEE64Bit: self nextUInt64
]

{ #category : #accessing }
WDCBinaryLittleEndianReadStream >> nextInt16 [
	| result |
	result := self nextUInt16.
	^ (result & 16r7fff) - (result & 16r8000)
]

{ #category : #accessing }
WDCBinaryLittleEndianReadStream >> nextInt32 [
	| result |
	result := self nextUInt32.
	^ (result & 16r7fffffff) - (result & 16r80000000)
]

{ #category : #accessing }
WDCBinaryLittleEndianReadStream >> nextInt64 [
	| result |
	result := self nextUInt64.
	^ (result & 16r7fffffffffffffff) - (result & 16r8000000000000000)
]

{ #category : #accessing }
WDCBinaryLittleEndianReadStream >> nextInt8 [
	| result |
	result := self nextUInt8.
	^ (result & 16r7f) - (result & 16r80)
]

{ #category : #accessing }
WDCBinaryLittleEndianReadStream >> nextUInt16 [
	^ self next |
		(self next << 8)
]

{ #category : #accessing }
WDCBinaryLittleEndianReadStream >> nextUInt32 [
	^ self next |
		(self next << 8) |
		(self next << 16) |
		(self next << 24)
]

{ #category : #accessing }
WDCBinaryLittleEndianReadStream >> nextUInt64 [
	^ self next |
		(self next << 8) |
		(self next << 16) |
		(self next << 24) |
		(self next << 32) |
		(self next << 40) |
		(self next << 48) |
		(self next << 56)
]

{ #category : #accessing }
WDCBinaryLittleEndianReadStream >> nextUInt8 [
	^ self next
]
