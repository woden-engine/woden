resource building
buildHandle
	self assert: description isNotNil.
	handle := engine device createBuffer: description initial_data: self initialData.
	(description mapping_flags anyMask: AGPU_MAP_PERSISTENT_BIT) ifTrue: [ 
		pointer := handle map: self defaultMappingMode.
		self assert: pointer isNull not.
		data isSessionPersistentExternalBuffer ifTrue: [
			data pointer: pointer size: description size
		].
	].
