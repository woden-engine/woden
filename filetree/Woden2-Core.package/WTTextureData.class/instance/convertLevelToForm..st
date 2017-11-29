converting
convertLevelToForm: level
	| selector |
	selector := PixelFormatDecoderSelector at: pixelFormat.
	^ self perform: selector with: level