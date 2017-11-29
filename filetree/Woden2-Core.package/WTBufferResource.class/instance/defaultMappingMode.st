private
defaultMappingMode
	| flags readSupported writeSupported |
	flags := description mapping_flags.
	readSupported := flags anyMask: AGPU_MAP_READ_BIT.
	writeSupported := flags anyMask: AGPU_MAP_READ_BIT.
	(readSupported and: [ writeSupported ]) ifTrue: [ ^ AGPU_READ_WRITE ].
	readSupported ifTrue: [ ^ AGPU_READ_ONLY ].
	writeSupported ifTrue: [ ^ AGPU_WRITE_ONLY ].
	self error: 'trying to map a buffer that cannot be mapped.'