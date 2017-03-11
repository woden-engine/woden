private
waitFence
	(synchronizationFence isNotNil and: [ fenceSignaled ]) ifTrue: [
		synchronizationFence waitOnClient
	].
	fenceSignaled := false