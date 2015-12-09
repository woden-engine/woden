swap_chain
getCurrentBackBuffer_swap_chain: swap_chain
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_framebuffer* agpuGetCurrentBackBuffer (agpu_swap_chain* swap_chain) )
