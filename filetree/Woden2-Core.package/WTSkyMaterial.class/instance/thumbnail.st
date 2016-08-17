preview
thumbnail
	skyTexture ifNotNil: [ ^ WTResourceThumbnailDBEntry type: #sky value: skyTexture thumbnail ].
	^ WTResourceThumbnailDBEntry type: #sky value: Color cyan