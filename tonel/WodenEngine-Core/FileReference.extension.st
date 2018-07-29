Extension { #name : #FileReference }

{ #category : #'*WodenEngine-Core' }
FileReference >> concretizeWodenSRGBTextureWithResourceCache: resourceCache [
	^ resourceCache loadSRGBTexture: self
]

{ #category : #'*WodenEngine-Core' }
FileReference >> concretizeWodenTextureWithResourceCache: resourceCache [
	^ resourceCache loadTexture: self
]
