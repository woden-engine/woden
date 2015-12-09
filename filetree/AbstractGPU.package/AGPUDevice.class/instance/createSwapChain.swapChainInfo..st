wrappers
createSwapChain: commandQueue swapChainInfo: swapChainInfo
	| result |
	result := AGPUCBindings createSwapChain_device: (self validHandle) commandQueue: (self validHandleOf: commandQueue) swapChainInfo: swapChainInfo.
	^ AGPUSwapChain forHandle: result
