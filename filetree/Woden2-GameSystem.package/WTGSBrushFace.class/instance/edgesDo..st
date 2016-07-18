as yet unclassified
edgesDo: aBlock
	| start end |
	1 to: indices size do: [ :i |
		start := i.
		end := ((i + 1) % indices size) + 1.
		aBlock value: start value: end
	]