event handling
selectionChanged
	| selection |
	editor ifNil: [ ^ self ].
	
	selection := editor selection.
	xScale text: (self optionalValueToString: selection xTextureScale) asText.
	yScale text: (self optionalValueToString: selection yTextureScale) asText.
	xOffset text: (self optionalValueToString: selection xTextureOffset) asText.
	yOffset text: (self optionalValueToString: selection yTextureOffset) asText.
	rotation text: (self optionalValueToString: selection textureRotation) asText.