as yet unclassified
writeGPUStateInto: pointer at: offset
	self updateRenderTransform.
	objectState transform: renderTransform.
	objectState storeBytesIn: pointer position: offset + 1.