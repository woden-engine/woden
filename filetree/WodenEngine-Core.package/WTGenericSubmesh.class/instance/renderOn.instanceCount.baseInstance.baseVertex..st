rendering
renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex 
	material ifNil: [ ^ self ].
	(stateTracker activateMaterial: material) ifFalse: [ ^ self].
	stateTracker
		primitiveType: primitiveType;
		drawElements: indexCount instance_count: instanceCount first_index: firstIndex base_vertex: baseVertex base_instance: baseInstance