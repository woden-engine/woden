accessing
maxSize: anInteger
	"aBlock is evaluated on each node model. 
	Set the maximum size of each element"
	elements do: [ :el | 
		el trachelShape extent: (el trachelShape extent min: anInteger @ anInteger) ]