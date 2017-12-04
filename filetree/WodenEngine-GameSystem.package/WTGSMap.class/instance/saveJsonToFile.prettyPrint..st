as yet unclassified
saveJsonToFile: fileName prettyPrint: prettyPrint
	fileName asFileReference writeStreamDo: [ :out |
		out truncate.
		(NeoJSONWriter on: out)
			prettyPrint: prettyPrint;
			nextPut: self asJsonData
	].
