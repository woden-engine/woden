private
createIndexBuffer
	indexBufferCapacity := indices capacity.
	indexBuffer := engine createIndex: indices elementSize streamingElements: indexBufferCapacity.
	