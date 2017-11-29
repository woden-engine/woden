execution
packIn: anElement
	| newPosition2D base |

	newPosition2D := self bestSpaceFor: anElement.

	anElement
		translateToX: newPosition2D x
					y: anElement position y
					z: newPosition2D y.
					
	base := self yCrossSectionOf: anElement boundingBox.
	
	bounds := bounds max: base corner + gap.
	
	self recalculateFreeSpacesWith: base