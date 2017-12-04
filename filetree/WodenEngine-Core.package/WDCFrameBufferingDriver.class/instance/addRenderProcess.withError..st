rendering process
addRenderProcess: process withError: error
	process suspended: true.
	error freeze.
	[ error debug ] fork.
