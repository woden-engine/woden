class initialization
initialize
	"
	self initialize
	"
	super initialize.
	
	ShaderBindingTypeMap := IdentityDictionary newFromPairs: {
		#'uniform-buffer' . AGPU_SHADER_BINDING_TYPE_UNIFORM_BUFFER .
		#'sampled-image' . AGPU_SHADER_BINDING_TYPE_SAMPLED_IMAGE .
		#'storage-image' . AGPU_SHADER_BINDING_TYPE_STORAGE_IMAGE .
		#sampler . AGPU_SHADER_BINDING_TYPE_SAMPLER .
	}.
	
	ShaderLanguageNameMap := Dictionary newFromPairs: {
		AGPU_SHADER_LANGUAGE_NONE . #none .
		AGPU_SHADER_LANGUAGE_GLSL . #glsl .
		AGPU_SHADER_LANGUAGE_EGLSL . #eglsl .
		AGPU_SHADER_LANGUAGE_HLSL . #hlsl .
		AGPU_SHADER_LANGUAGE_BINARY . #binary .
		AGPU_SHADER_LANGUAGE_SPIR_V . #spirv .
		AGPU_SHADER_LANGUAGE_METAL . #metal .
		AGPU_SHADER_LANGUAGE_METAL_AIR . #'metal-air'
	}.
	
	StageNameMap := Dictionary newFromPairs: {
		#fragment . AGPU_FRAGMENT_SHADER .
		#vertex . AGPU_VERTEX_SHADER .
		#geometry . AGPU_GEOMETRY_SHADER .
		#'tessellation-control' . AGPU_TESSELLATION_CONTROL_SHADER .
		#'tessellation-evaluation' . AGPU_TESSELLATION_EVALUATION_SHADER .
		#compute . AGPU_COMPUTE_SHADER .
	}.
	
	PipelineStateObjectAttributeParser := Dictionary newFromPairs: { 
		'abstract' . #setPipeline:dummyAttribute: .
		'inherit-from' . #setPipeline:dummyAttribute: .
		'shader-signature' . #setPipeline:shaderSignatureNamed: .
		'render-target-count' . #setPipeline:renderTargetCount: .
		'render-target-formats' . #setPipeline:renderTargetFormats: .
		'depth-stencil-format' . #setPipeline:depthStencilFormat: .
		'vertex-layout' . #setPipeline:vertexLayoutNamed: .
		'primitive-type' . #setPipeline:primitiveTypeNamed: .
		'shader' . #setPipeline:shaderNamed: .
	}.
	
	PrimitiveTopologyNameMap := IdentityDictionary newFromPairs: { 
		#points . AGPU_POINTS .
		#lines . AGPU_LINES .
		#'lines-adjacency' . AGPU_LINES_ADJACENCY .
		#'line-strip' . AGPU_LINE_STRIP .
		#'line-strip-adjacency' . AGPU_LINE_STRIP_ADJACENCY .
		#triangles . AGPU_TRIANGLES .
		#'triangles-adjacency' . AGPU_TRIANGLES_ADJACENCY .
		#'triangle-strip' . AGPU_TRIANGLE_STRIP .
		#'triangle-strip-adjacency' . AGPU_TRIANGLE_STRIP_ADJACENCY .
		#patches . AGPU_PATCHES .
	}.