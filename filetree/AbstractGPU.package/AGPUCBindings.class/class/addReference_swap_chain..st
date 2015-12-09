swap_chain
addReference_swap_chain: swap_chain
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuAddSwapChainReference (agpu_swap_chain* swap_chain) )
