public
highlight: aBlock
	"aBlock return an object or a list of objects to highlight"
	highlightElements := [ :el | 
		| objects |
		objects := aBlock rtValue: el model.
		(objects collect: [ :o | el view elementFromModel: o ]) copyWithout: nil
		]