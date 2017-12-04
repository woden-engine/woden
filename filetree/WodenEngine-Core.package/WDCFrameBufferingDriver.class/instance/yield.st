rendering process
yield
	[ yieldSemaphore signal ] forkAt: Processor lowestPriority.
	yieldSemaphore wait; consumeAllSignals