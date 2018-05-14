Class {
	#name : #WDPPompeiiFontCache,
	#superclass : #PompeiiFontCache,
	#instVars : [
		'driver',
		'modified',
		'texture',
		'shaderBinding'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Pompeii'
}

{ #category : #initialization }
WDPPompeiiFontCache >> activateMaterialIn: aSurface [
	self validTexture.
	aSurface stateTracker
		vertexShader: driver vertexShader;
		fragmentShader: driver colorFontShader;
		useShaderResources: self validShaderBinding.

	"| context program |
	context := aSurface driver context.
	program := aSurface driver textProgram.
	aSurface useProgram: program.
	program
		uniform: #fontTexture int: 0;
		uniform: #fontTextureInvertedSize float: self width asFloat reciprocal float: self height asFloat reciprocal.
		
	context gl
		activeTexture: GL_TEXTURE0;
		bindTexture_target: GL_TEXTURE_2D texture: (self textureFor: context) validHandle
	"
]

{ #category : #accessing }
WDPPompeiiFontCache >> driver [
	^ driver
]

{ #category : #accessing }
WDPPompeiiFontCache >> driver: anObject [
	driver := anObject
]

{ #category : #initialization }
WDPPompeiiFontCache >> forPompeiiDriver: aDriver [
	^ self
]

{ #category : #testing }
WDPPompeiiFontCache >> hasFixedSize [
	^ true
]

{ #category : #initialization }
WDPPompeiiFontCache >> initialize [
	super initialize.
	modified := true.
	texture := nil.
]

{ #category : #initialization }
WDPPompeiiFontCache >> modified [
	modified := true
]

{ #category : #initialization }
WDPPompeiiFontCache >> updateShaderBinding [
	texture ifNil: [ ^ self ].
	shaderBinding ifNil: [ ^ self ].
	shaderBinding bind: 0 texture: texture startMiplevel: 0 miplevels: -1 lodclamp: 100000.0
]

{ #category : #initialization }
WDPPompeiiFontCache >> validShaderBinding [
	shaderBinding ifNil: [
		shaderBinding := (WDPPompeiiShaderSignature for: driver engine) newFont.
		self updateShaderBinding
	].

	^ shaderBinding
]

{ #category : #initialization }
WDPPompeiiFontCache >> validTexture [
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
	self inspect.
	modified := false.
	^ texture
]
