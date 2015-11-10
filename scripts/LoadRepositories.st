FileStream stdout nextPutAll: 'Loading FileTree'; lf.

Metacello new
	baseline: 'FileTree';
	repository: 'github://dalehenrich/filetree:issue_161/repository';
	load: 'MonticelloFileTree-Git'.

FileStream stdout nextPutAll: 'Loading the AbstractGPU'; lf.
FileStream stdout nextPutAll: 'TODO'; lf.

FileStream stdout nextPutAll: 'Loading Woden2'; lf.
FileStream stdout nextPutAll: 'TODO'; lf.

