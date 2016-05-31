resource building
streamingMappedBufferMappingFlags
	^ ((AGPU_MAP_READ_BIT
		bitOr: AGPU_MAP_WRITE_BIT)
		bitOr: AGPU_MAP_PERSISTENT_BIT)
		bitOr: AGPU_MAP_COHERENT_BIT