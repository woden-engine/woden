private
createIndexBuffer
	Transcript show: 'create index buffer'; cr.
	indexBufferCapacity := indices capacity.
	indexBuffer := engine createIndex: indices elementSize streamingElements: indexBufferCapacity.
	