clipping
subtract: aBrush 
	| brushes |
	brushes := OrderedCollection new.
	self subtract: aBrush into: brushes.
	^ brushes