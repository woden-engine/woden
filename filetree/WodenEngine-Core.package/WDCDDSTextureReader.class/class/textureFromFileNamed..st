as yet unclassified
textureFromFileNamed: fileName
	| stream |
	stream := FileStream readOnlyFileNamed: fileName.
	[
		stream binary.
		^ self textureFromStream: stream
	] ensure: [ stream close ]