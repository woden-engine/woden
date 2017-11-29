private
doElementsWithCell: elements side: n block: block
	elements doWithIndex: [ :el :i |
		| level levelIdx row column|
		level := ((i-1) / (n*n)) floor.
		levelIdx := (i-1) % (n*n).
		row := (levelIdx / n) floor.
		column := levelIdx % n.
		block value: el value: row+1 value: column+1 value: level+1
	]