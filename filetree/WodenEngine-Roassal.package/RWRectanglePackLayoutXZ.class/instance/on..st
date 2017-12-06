public
on: elements
	| sortedElements |
	bounds := 0@0.
		
	sortedElements := SortedCollection sortBlock:  [ :larger :smaller |
		(larger  width + larger  depth) >
		(smaller width + smaller depth) ].
	sortedElements addAll: elements.
		
	freeSpace := Set new.
	freeSpace add: (0@0 corner: 
		(sortedElements inject: 0@0 into: [ :sum :el |
			sum + (el width @ el depth) + (gap * 2) ])).
	
	sortedElements
		do: [ :element | self packIn: element ]
		displayingProgress: 'Laying out elements'