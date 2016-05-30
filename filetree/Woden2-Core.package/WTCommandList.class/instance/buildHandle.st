resource building
buildHandle
	handle := engine device createCommandList: allocator listType allocator: allocator validHandle initial_pipeline_state: nil.
	self assert: handle isNull not.
	handle close.