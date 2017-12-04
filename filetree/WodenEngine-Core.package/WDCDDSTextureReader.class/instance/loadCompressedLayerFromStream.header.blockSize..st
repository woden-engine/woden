as yet unclassified
loadCompressedLayerFromStream: aBinaryStream header: header blockSize: blockSize
	| formatInfo pitch currentWidth currentHeight rows levelSize mipMapCount mipData mipLevels level width height |
	width := header width.
	height := header width.
	
	currentWidth := width.
	currentHeight := height.
	mipMapCount := header mipMapCount.
	mipLevels := (1 to: mipMapCount) collect: [ :i |
		pitch := ((currentWidth + 3) // 4 max: 1) * blockSize.
		rows := (currentHeight + 3) // 4 max: 1.
		levelSize := pitch * rows.
		
		mipData := aBinaryStream next: levelSize.
		level := WDCTextureLevelData new
			width: currentWidth;
			height: currentHeight;
			depth: 1;
			pitch: pitch;
			slicePitch: levelSize;
			data: mipData;
			yourself.

		
		currentWidth := currentWidth // 2 max: 1.
		currentHeight := currentHeight // 2 max: 1.
		
		level
	].
	
	^ WDCTextureLayerData new
		width: width;
		height: height;
		depth: 1;
		levels: mipLevels