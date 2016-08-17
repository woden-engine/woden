private
computeGridSize
	| columns |
	columns := self width // self computeCellWidth max: 1.
	^ columns @ ((thumbnailCells size + columns - 1) // columns)