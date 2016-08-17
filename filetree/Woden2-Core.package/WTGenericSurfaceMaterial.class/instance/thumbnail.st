preview
thumbnail
	albedoTexture ifNotNil: [ ^ WTResourceThumbnailDBEntry type: self thumbnailType value: albedoTexture thumbnail ].
	^ WTResourceThumbnailDBEntry type: self thumbnailType value: self albedoColor asColor