private
updateColorRampBuffer
	(colorRampEntryBuffer isNil or: [colorRampEntryBufferCapacity < colorRampEntries capacity]) ifTrue: [ self createColorRampEntryBuffer. ].
	LibC memCopy: colorRampEntries rawData to: colorRampEntryBuffer validPointer size: colorRampEntries rawDataSize