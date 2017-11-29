private
updateIndexBuffer
	(indexBuffer isNil or: [indexBufferCapacity < indices capacity]) ifTrue: [ self createIndexBuffer. ].
	LibC memCopy: indices rawData to: indexBuffer validPointer size: indices rawDataSize