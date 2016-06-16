pipeline state object building
setPipeline: pipeline depthState: stateDescription
	| enabled writeMask function|
	enabled := stateDescription at: 'enabled'.
	writeMask := stateDescription at: 'write-mask'.
	function := CompareFunctionNameMap at: (stateDescription at: 'function').
	pipeline setDepthState: enabled writeMask: writeMask function: function