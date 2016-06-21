as yet unclassified
createIndexBufferFor: anEngine
	^ anEngine createIndex: indices elementSize elements: indices size immutableBuffer: indices rawData