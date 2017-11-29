public
useColorRamp: aColorRamp
	| colorRampDescription |
	colorRampDescription := colorRampDictionary at: aColorRamp ifAbsentPut: [ self createColorRampDescription: aColorRamp ].
	self deferDrawCommand: [ commandList pushConstants: 0 size: WTColorRampDescription structureSize values: colorRampDescription asByteArray ].