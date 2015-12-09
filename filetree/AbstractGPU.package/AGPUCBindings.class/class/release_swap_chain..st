swap_chain
release_swap_chain: swap_chain
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuReleaseSwapChain (agpu_swap_chain* swap_chain) )
