FileStream stdout nextPutAll: 'Loading FileTree'; lf.

Metacello new
	baseline: 'FileTree';
	repository: 'github://dalehenrich/filetree:issue_161/repository';
	load: 'MonticelloFileTree-Git'.

"Use the modified version of monticello"
'scripts/MonticelloMethodSorting.cs' asFileReference fileIn.

"Load the runtime changes that are required for Lowcode"
'scripts/LowcodeRuntimeChanges.cs' asFileReference fileIn.

"Load Abstract GPU bindings"
"FileStream stdout nextPutAll: 'Loading Woden2'; lf.
Metacello new
	baseline: 'AbstractGPU';
	repository: 'gitfiletree://filetree';
	load.
"

"Load Bloc2"
Gofer new
    smalltalkhubUser: 'GlennCavarle' project: 'Bloc2';
    package: 'ConfigurationOfBloc2';
    load.
(Smalltalk at: #ConfigurationOfBloc2) loadBleedingEdge.

"Load Woden 2"
FileStream stdout nextPutAll: 'Loading Woden2'; lf.
Metacello new
	baseline: 'Woden2';
	repository: 'gitfiletree://filetree';
	load.

"Save the image"
(Smalltalk saveAs: 'woden2') 
    ifFalse: [ Smalltalk snapshot: false andQuit: true ].

