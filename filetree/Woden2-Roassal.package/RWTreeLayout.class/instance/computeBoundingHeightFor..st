private
computeBoundingHeightFor: nodeCollection
	| height |
	height := 0.0.
	nodeCollection do: [ :node | height := node height max: height ].
	^ height