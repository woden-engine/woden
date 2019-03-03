Class {
	#name : #WDBBabylonFontCache,
	#superclass : #BabylonFontCache,
	#instVars : [
		'driver',
		'modified',
		'shaderBinding',
		'texture'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Babylon-Font'
}

{ #category : #accessing }
WDBBabylonFontCache >> driver [
	^ driver
]

{ #category : #accessing }
WDBBabylonFontCache >> driver: anObject [
	driver := anObject
]

{ #category : #initialization }
WDBBabylonFontCache >> forBabylonDriver: aDriver [
	^ self
]

{ #category : #testing }
WDBBabylonFontCache >> hasFixedSize [
	^ true
]

{ #category : #initialization }
WDBBabylonFontCache >> initialize [
	super initialize.
	modified := true.
	texture := nil.
]

{ #category : #initialization }
WDBBabylonFontCache >> modified [
	modified := true
]

{ #category : #initialization }
WDBBabylonFontCache >> updateShaderBinding [
	texture ifNil: [ ^ self ].
	shaderBinding ifNil: [ ^ self ].
	shaderBinding bind: 0 texture: texture
]

{ #category : #initialization }
WDBBabylonFontCache >> validShaderBinding [
	shaderBinding ifNil: [
		shaderBinding := (WDBBabylonShaderSignature for: driver engine) newFont.
		self updateShaderBinding
	].

	^ shaderBinding
]

{ #category : #initialization }
WDBBabylonFontCache >> validTexture [
	| description |
	(texture isNotNil and: [ modified not ]) ifTrue: [ ^ texture ].
	
	self ensureLatin1.
	texture ifNil: [ 
		description := AGPUTextureDescription new
			type: AGPU_TEXTURE_2D;
			format: AGPU_TEXTURE_FORMAT_R8_UNORM;
			width: self width;
			height: self height;
			depthOrArraySize: 1;
			miplevels: 1;
			sample_count: 1;
			sample_quality: 0;
			flags: AGPU_TEXTURE_FLAG_UPLOADED;
			yourself.
		texture := (WDCTexture for: driver engine)
			description: description; 
			checkSession;
			yourself.
		self updateShaderBinding
	].

	texture validHandle uploadTextureData: 0 arrayIndex: 0 pitch: self width slicePitch: self width * self height data: bits.
	modified := false.
	^ texture
]
