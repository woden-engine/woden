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
	WDCEngine generateOfflineMipmapsGPU ifTrue: [ 
		^ ((WDCEngine default resourceCache mainProceduralOfflineTextureRendererForExtent: self extent)
			createNormalTextureFromForm: self)
				asWodenTexture
	].

	^ self asWodenTextureData swizzleXYZNormalMap asWodenTexture
]

{ #category : #'*WodenEngine-Core' }
Form >> asWodenSRGBTexture [
	WDCEngine generateOfflineMipmapsGPU ifTrue: [ 
		^ ((WDCEngine default resourceCache mainProceduralOfflineTextureRendererForExtent: self extent)
			createSRGBTextureDataFromForm: self)
				asWodenSRGBTexture
	].
	^ self asWodenTextureData asWodenSRGBTexture
]

{ #category : #'*WodenEngine-Core' }
Form >> asWodenTexture [
	WDCEngine generateOfflineMipmapsGPU ifTrue: [ 
		^ ((WDCEngine default resourceCache mainProceduralOfflineTextureRendererForExtent: self extent)
			createTextureDataFromForm: self)
				asWodenTexture

	].

	^ self asWodenTextureData asWodenTexture
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
