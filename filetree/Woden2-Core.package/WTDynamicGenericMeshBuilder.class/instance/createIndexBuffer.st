as yet unclassified
createIndexBuffer
	(indexBuffer isNil or: [ indexBufferCapacity < indices size ]) ifTrue: [
		indexBufferCapacity := indices capacity.
		indexBuffer := engine createIndex: indices elementSize streamingElements: indexBufferCapacity.
	].

	LibC memCopy: indices rawData to: indexBuffer validPointer size: indices rawDataSize.
	^ indexBuffer