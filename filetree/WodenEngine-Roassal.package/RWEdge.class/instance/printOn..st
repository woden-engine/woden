printing
printOn: stream
	stream nextPutAll: 'a RWEdge<'.
	model printOn: stream.
	stream nextPutAll: ', from: '.
	from printOn: stream.
	stream nextPutAll: ', to: '.
	to printOn: stream.
	stream nextPutAll: '>'.