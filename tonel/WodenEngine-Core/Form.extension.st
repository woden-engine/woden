Extension { #name : #Form }

{ #category : #'*WodenEngine-Core' }
Form >> asSRGBTextureFor: anEngine [
	^ anEngine createTextureFromForm: self
]

{ #category : #'*WodenEngine-Core' }
Form >> asTextureFor: anEngine [
	^ anEngine createLinearTextureFromForm: self
]

{ #category : #'*WodenEngine-Core' }
Form >> asWodenNormalTexture [
	^ self asWodenTexture
]

{ #category : #'*WodenEngine-Core' }
Form >> asWodenSRGBTexture [
	^ self asWodenTextureData asWodenSRGBTexture
]

{ #category : #'*WodenEngine-Core' }
Form >> asWodenTexture [
	^ self asWodenTextureData swizzleXYZNormalMap asWodenTexture
]

{ #category : #'*WodenEngine-Core' }
Form >> asWodenTextureData [
	depth < 32 ifTrue: [
		^ (self asFormOfDepth: 32) asWodenTextureData
	].

	^ WDCTextureData fromForm: self
]

{ #category : #'*WodenEngine-Core' }
Form >> thumbnail [
	^ self
]
