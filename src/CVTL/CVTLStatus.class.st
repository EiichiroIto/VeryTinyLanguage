Class {
	#name : #CVTLStatus,
	#superclass : #Object,
	#instVars : [
		'state',
		'topOfLine',
		'position'
	],
	#category : #'CVTL-Core'
}

{ #category : #accessing }
CVTLStatus >> bePrompted [

	state := #prompted.
	^ self
]

{ #category : #accessing }
CVTLStatus >> beStepping [

	state := #stepping.
	^ self
]

{ #category : #initialization }
CVTLStatus >> initialize [

	self bePrompted
]

{ #category : #testing }
CVTLStatus >> isPrompted [

	^ state = #prompted
]

{ #category : #testing }
CVTLStatus >> isStepping [

	^ state = #stepping
]

{ #category : #accessing }
CVTLStatus >> position [

	^ position
]

{ #category : #accessing }
CVTLStatus >> position: anInteger [

	position := anInteger
]

{ #category : #printing }
CVTLStatus >> printOn: aStream [

	aStream
		nextPutAll: 'Status[state=';
		nextPutAll: state asString;
		nextPutAll: ',position=';
		nextPutAll: position asString;
		nextPutAll: ',topOfLine=';
		nextPutAll: topOfLine asString;
		nextPut: $]
]

{ #category : #accessing }
CVTLStatus >> state [

	^ state
]

{ #category : #accessing }
CVTLStatus >> state: anObject [

	state := anObject
]

{ #category : #accessing }
CVTLStatus >> topOfLine [

	^ topOfLine
]

{ #category : #accessing }
CVTLStatus >> topOfLine: anObject [

	topOfLine := anObject
]
