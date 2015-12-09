swap_chain
swapBuffers_swap_chain: swap_chain
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuSwapBuffers (agpu_swap_chain* swap_chain) )
