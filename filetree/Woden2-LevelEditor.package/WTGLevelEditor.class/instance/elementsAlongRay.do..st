selection
elementsAlongRay: ray do: aBlock
	selectionBoxView elementsAlongRay: ray do: aBlock.
	
	map elementsAlongRay: ray mode: #brush do: aBlock