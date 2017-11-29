as yet unclassified
initialize
	super initialize.
	
	WaveHeaderSignature := self fourCC: 'RIFF'.
	WaveIDValue := self fourCC: 'WAVE'.
	FormatChunkSignature := self fourCC: 'fmt '.
	DataChunkSignature := self fourCC: 'data'.
	
	FormatPCM := 16r1.
	FormatIEEEFloat := 16r6.