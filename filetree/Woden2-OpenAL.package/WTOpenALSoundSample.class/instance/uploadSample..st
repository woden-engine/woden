as yet unclassified
uploadSample: sample
	| data |
	sample data ifNil: [ ^ self ].
	data := sample data.
	
	device asCurrentDo: [
		OpenAL bufferData: handle format: (self mapFormat: sample format channels: sample channels) data: data size: data size freq: sample sampleRate
	]