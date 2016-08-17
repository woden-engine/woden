accessing
thumbnailFor: resourceName ifAbsentPut: aBlock
	^ resources at: resourceName ifAbsentPut: aBlock