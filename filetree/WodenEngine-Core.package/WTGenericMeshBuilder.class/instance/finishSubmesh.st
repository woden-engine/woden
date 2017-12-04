as yet unclassified
finishSubmesh
	| last |
	submeshes ifEmpty: [ ^ self ].
	last := submeshes last.
	last indexCount: indices size - last firstIndex.