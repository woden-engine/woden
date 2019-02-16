Class {
	#name : #WodenMathSourceLoader,
	#superclass : #Object,
	#category : #'WodenMath-SourceLoader'
}

{ #category : #'as yet unclassified' }
WodenMathSourceLoader class >> loadWodenMathSources [
	<script>
	"Build the Lowtalk source code"
	| compiler wodenLowtalkSourcePath lowtalkSourceRelativePath |
	lowtalkSourceRelativePath := 'source/woden.ltk' asFileReference.
	wodenLowtalkSourcePath := Smalltalk imageDirectory resolve: lowtalkSourceRelativePath.
	wodenLowtalkSourcePath exists ifFalse: [
		wodenLowtalkSourcePath := IceLibgitRepository repositoriesLocation / #ronsaldo / #woden resolve: lowtalkSourceRelativePath.
	].
	
	wodenLowtalkSourcePath exists ifFalse: [ self error: 'Failed to find the Woden Lowtalk sources.' ].
	
	SourceFiles deferFlushDuring: [
    compiler := LowtalkCompiler compilationTarget: SLVMCompilationTarget forCurrentImage.
    compiler
    	optimizationLevel: 1;
    	evaluateFileNamed: wodenLowtalkSourcePath fullName;
	    buildModule;
    	ssaModule.
	].

]
