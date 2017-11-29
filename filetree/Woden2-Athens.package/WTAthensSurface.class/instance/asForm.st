initialization
asForm
	framebufferForm ifNil: [
		framebufferForm := Form extent: extent depth: 32.
		changedData := true.
	].

	changedData ifTrue: [ self readColorBufferToForm ].
	changedData := false.
	^ framebufferForm