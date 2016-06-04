transformations
restoreAfter: aBlock
	| oldMatrix |
	oldMatrix := matrix.
	aBlock ensure: [ matrix := oldMatrix. ]