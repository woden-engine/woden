Extension { #name : #BlockClosure }

{ #category : #'*WodenEngine-Core' }
BlockClosure >> closureDescriptionForCaching [
	^ ByteString streamContents: [ :out |
		out nextPut: $[.
		out nextPutAll: self method sourceCode; cr.
		out nextPut: $|.
		1 to: self numCopiedValues do: [ :i |
			out nextPutAll: (self copiedValueAt: i) closureDescriptionForCaching
		].
		out nextPut: $|.
		out nextPut: $].
	]
]

{ #category : #'*WodenEngine-Core' }
BlockClosure >> closureHashForCaching [
	^ SHA256 hashMessage: self closureDescriptionForCaching
]

{ #category : #'*WodenEngine-Core' }
BlockClosure >> noiseValueAt: coord withAmplitude: amplitude [
	self numArgs = 1 ifTrue: [ ^ (self value: coord) * amplitude ].
	self numArgs = 2 ifTrue: [ ^ self value: coord value: amplitude ].
	self error: 'Invalid noise function for fBM.'
]

{ #category : #'*WodenEngine-Core' }
BlockClosure >> noiseValueAt: coord withAmplitude: amplitude withTilingPeriod: tilingPeriod [
	self numArgs = 2 ifTrue: [ ^ (self value: coord value: tilingPeriod) * amplitude ].
	self numArgs = 3 ifTrue: [ ^ self value: coord value: tilingPeriod value: amplitude ].
	self error: 'Invalid noise function for fBM.'
]

{ #category : #'*WodenEngine-Core' }
BlockClosure >> valueCachedInDisk [
	^ self valueCachedInDiskWithHash: self closureHashForCaching hex
]

{ #category : #'*WodenEngine-Core' }
BlockClosure >> valueCachedInDiskWithHash: hashString [
	| fileName value |
	fileName := WDCResourceCache proceduralContentDiskCache / (hashString , '.fuel').
	fileName exists ifTrue: [ 
		^ FLMaterializer materializeFromFileNamed: fileName fullName
	].

	value := self value.
	FLSerializer serialize: value toFileNamed: fileName fullName.
	^ value
]

{ #category : #'*WodenEngine-Core' }
BlockClosure >> valueCachedInDiskWithKey: keyValue [
	^ self valueCachedInDiskWithHash: (SHA256 hashMessage: keyValue closureDescriptionForCaching) hex
]
