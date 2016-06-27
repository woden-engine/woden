as yet unclassified
createVertexBufferFor: anEngine
	^ anEngine createVertex: vertices elementSize elements: vertices size immutableBuffer: vertices rawData 