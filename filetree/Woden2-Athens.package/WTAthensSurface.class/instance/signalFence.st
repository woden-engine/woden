private
signalFence
	synchronizationFence ifNil: [ synchronizationFence := engine device createFence ].
	commandQueue signalFence: synchronizationFence.
	fenceSignaled := true.