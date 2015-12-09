device
createSwapChain_device: device commandQueue: commandQueue swapChainInfo: swapChainInfo
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_swap_chain* agpuCreateSwapChain (agpu_device* device , agpu_command_queue* commandQueue , agpu_swap_chain_create_info* swapChainInfo) )
