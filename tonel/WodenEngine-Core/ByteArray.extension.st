Extension { #name : #ByteArray }

{ #category : #'*WodenEngine-Core' }
ByteArray >> bgraColorAt: index [
	| b g r a |
	b := (self unsignedByteAt: index) asFloatFromNormalizedUByte.
	g := (self unsignedByteAt: index + 1) asFloatFromNormalizedUByte.
	r := (self unsignedByteAt: index + 2) asFloatFromNormalizedUByte.
	a := (self unsignedByteAt: index + 3) asFloatFromNormalizedUByte.
	^ WMVector4F x: r y: g z: b w: a
]

{ #category : #'*WodenEngine-Core' }
ByteArray >> bgraColorAt: index put: aColor [
	| r g b a |
	r := aColor r asNormalizedUByte.
	g := aColor g asNormalizedUByte.
	b := aColor b asNormalizedUByte.
	a := aColor a asNormalizedUByte.
	self
		at: index put: b;
		at: index + 1 put: g;
		at: index + 2 put: r;
		at: index + 3 put: a
]

{ #category : #'*WodenEngine-Core' }
ByteArray >> closureDescriptionForCaching [
	^ 'ba ' , (self size < 32 ifTrue: [
		 self hex
	] ifFalse: [
		(SHA256 hashMessage: self) hex
	])
]

{ #category : #'*WodenEngine-Core' }
ByteArray >> sBGR_A_colorAt: index [
	| b g r a |
	b := (self unsignedByteAt: index) asFloatFromNormalizedUByte decodeSRGBComponent.
	g := (self unsignedByteAt: index + 1) asFloatFromNormalizedUByte decodeSRGBComponent.
	r := (self unsignedByteAt: index + 2) asFloatFromNormalizedUByte decodeSRGBComponent.
	a := (self unsignedByteAt: index + 3) asFloatFromNormalizedUByte.
	^ WMVector4F x: r y: g z: b w: a
]

{ #category : #'*WodenEngine-Core' }
ByteArray >> sBGR_A_colorAt: index put: aColor [
	| r g b a |
	r := aColor r encodeSRGBComponent asNormalizedUByte.
	g := aColor g encodeSRGBComponent asNormalizedUByte.
	b := aColor b encodeSRGBComponent asNormalizedUByte.
	a := aColor a asNormalizedUByte.
	self
		at: index put: b;
		at: index + 1 put: g;
		at: index + 2 put: r;
		at: index + 3 put: a
]
