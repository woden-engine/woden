public
on: elements
	| n rowSizes rowPositions columnSizes columnPositions levelSizes levelPositions |
	elements ifEmpty: [ ^ self ].
	n := (elements size nthRoot: 3) ceiling.
	
	"Initialize the cell sizes"	
	rowSizes := Array new: n.
	columnSizes := Array new: n.
	levelSizes := Array new: n.
		
	(1 to: n) do: [ :i |  
		rowSizes at: i put: 0.
		columnSizes at: i put: 0.
		levelSizes at: i put: 0.
	].

	"Compute the cell sizes according to the elements extent"
	self doElementsWithCell: elements side: n block:  [:el :row :column :level |
		| extent|
		extent := el extent.
		columnSizes at: column put: ((columnSizes at: column) max: extent x).
		rowSizes at: row put: ((rowSizes at: row) max: extent y).
		levelSizes at: level put: ((levelSizes at: level) max: extent z).
	].

	"Compute iteratively the cell positions"
	rowPositions := Array new: n.
	rowPositions at: 1 put: 0.

	columnPositions := Array new: n.
	columnPositions at: 1 put: 0.
	
	levelPositions := Array new: n.
	levelPositions at: 1 put: 0.
	
	(2 to: n) do: [ :i |  
		rowPositions at: i put: (rowPositions at: (i-1)) + (rowSizes at: (i-1)) + gap.
		columnPositions  at: i put: (columnPositions at: (i-1)) + (columnSizes at: (i-1)) + gap.
		levelPositions  at: i put: (levelPositions at: (i-1)) + (levelSizes at: (i-1)) + gap.
	].

	"Move the elements into their cells"
	self doElementsWithCell: elements side: n block:  [:el :row :column :level |
		el translateToX: (columnPositions at: column) y: (rowPositions at: row) z: (levelPositions at: level)
	].

	self centerElements: elements.