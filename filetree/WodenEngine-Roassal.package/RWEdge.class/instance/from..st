accessing
from: anElement
	[ anElement class == RWElement ] assert.
	from := anElement.
	anElement addConnectedEdge: self