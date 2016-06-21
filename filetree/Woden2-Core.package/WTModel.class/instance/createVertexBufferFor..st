as yet unclassified
createVertexBufferFor: anEngine
	^ anEngine createVertex: WTGenericVertexF structureSize elements: vertices size immutableBuffer: vertices rawData 