Class {
	#name : #WDCRenderTargetTextureDescription,
	#superclass : #WDCResourceWithDependants,
	#instVars : [
		'name',
		'extent',
		'pixelFormat',
		'srgbPixelFormat'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Texture'
}

{ #category : #converting }
WDCRenderTargetTextureDescription >> asTextureFor: anEngine [
	self assert: anEngine isNotNil.
	^ self concretizeWodenTextureWithResourceCache: anEngine resourceCache
]

{ #category : #converting }
WDCRenderTargetTextureDescription >> asWodenNormalTexture [
	^ self asWodenTexture
]

{ #category : #converting }
WDCRenderTargetTextureDescription >> asWodenSRGBTexture [
	^ self asWodenTexture
]

{ #category : #converting }
WDCRenderTargetTextureDescription >> asWodenTexture [
	^ self
]

{ #category : #'as yet unclassified' }
WDCRenderTargetTextureDescription >> concretizeWodenTextureWithResourceCache: resourceCache [
	^ resourceCache getOrCreateNamedRenderTargetTexture: name withExtent: extent pixelFormat: srgbPixelFormat
]

{ #category : #accessing }
WDCRenderTargetTextureDescription >> extent [
	^ extent
]

{ #category : #accessing }
WDCRenderTargetTextureDescription >> extent: anObject [
	extent := anObject
]

{ #category : #initialization }
WDCRenderTargetTextureDescription >> initialize [
	super initialize.
	pixelFormat := AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM.
	srgbPixelFormat := AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB.
]

{ #category : #accessing }
WDCRenderTargetTextureDescription >> name [
	^ name
]

{ #category : #accessing }
WDCRenderTargetTextureDescription >> name: anObject [
	name := anObject
]

{ #category : #accessing }
WDCRenderTargetTextureDescription >> pixelFormat [
	^ pixelFormat
]

{ #category : #accessing }
WDCRenderTargetTextureDescription >> pixelFormat: anObject [
	pixelFormat := anObject
]

{ #category : #accessing }
WDCRenderTargetTextureDescription >> srgbPixelFormat [
	^ srgbPixelFormat
]

{ #category : #accessing }
WDCRenderTargetTextureDescription >> srgbPixelFormat: anObject [
	srgbPixelFormat := anObject
]
