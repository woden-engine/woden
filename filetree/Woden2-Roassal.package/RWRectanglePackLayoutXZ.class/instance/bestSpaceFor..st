space-calculation
bestSpaceFor: anElement
	| elementsPadedExtent suitableSpaces |
	
	elementsPadedExtent := (anElement width @ anElement depth) + (gap * 2).
	
	suitableSpaces := freeSpace select: [ :space |
		elementsPadedExtent x <= space width and:
			[ elementsPadedExtent y <= space height ] ].
	
	^ (suitableSpaces
		fold: [ :best :current |
			| bestExt currentExt | 
			((currentExt := self extentByInserting: elementsPadedExtent into: current) <
			(bestExt := self extentByInserting: elementsPadedExtent  into: best) or: [ 
				currentExt = bestExt and: [
					(current width + current height) <
					(   best width +    best height) ] ])
						ifTrue: [ current ]
						ifFalse: [ best ] ]) origin +
							(anElement width @ anElement depth / 2)
							+ gap