device
createSwapChain_device: device swapChainInfo: swapChainInfo
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_swap_chain* agpuCreateSwapChain (agpu_device* device , agpu_swap_chain_create_info* swapChainInfo) )
