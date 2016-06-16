pipeline state object building
setPipeline: pipeline cullMode: modeName
	| mode |
	mode := CullModeNameMap at: modeName.
	pipeline setCullMode: mode