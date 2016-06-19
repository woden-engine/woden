private
createColorRampEntryBuffer
	colorRampEntryBufferCapacity := colorRampEntries capacity max: 16.
	colorRampEntryBuffer := engine createStreamingStorageBuffer: WTColorRampEntry structureSize* colorRampEntryBufferCapacity.
	
	viewportUniformBinding bind: 1 storageBuffer: colorRampEntryBuffer
