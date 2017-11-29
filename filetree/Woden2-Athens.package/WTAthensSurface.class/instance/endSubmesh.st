public
endSubmesh
	| start count |
	start := startIndex.
	count := indices size - startIndex.
	count = 0 ifTrue: [ ^ self ].

	self deferDrawCommand: [
		commandList drawElements: count instance_count: 1 first_index: start base_vertex: 0 base_instance: 0
	].

	startIndex := indices size.
