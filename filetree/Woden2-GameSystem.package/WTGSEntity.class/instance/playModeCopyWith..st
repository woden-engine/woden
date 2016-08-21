copying
playModeCopyWith: copiedDictionary
	| result |
	result := self class new.
	result worldEntity: worldEntity.
		
	self componentsSelect: #isUsedInPlayMode thenDo: [:comp |
		result addComponent: (copiedDictionary at: comp ifAbsentPut: [comp playModeCopyWith: copiedDictionary])
	].

	^ result