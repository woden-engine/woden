dimension calculation
minimumNumberOfElementsForElementsPerSide: elementsPerSide
	| elementsPerLayer minimumNumberOfLayers |
	elementsPerLayer := self elementsPerLayerForElementsPerSide: elementsPerSide.
	minimumNumberOfLayers := self minimumNumberOfLayersForElementsPerSide: elementsPerSide.
	^ minimumNumberOfLayers * elementsPerLayer