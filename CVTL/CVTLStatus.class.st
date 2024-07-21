Class {
	#name : #CVTLStatus,
	#superclass : #Object,
	#instVars : [
		'state',
		'pos',
		'address'
	],
	#category : #'CVTL-Core'
}

{ #category : #accessing }
CVTLStatus >> address [

	^ address
]

{ #category : #accessing }
CVTLStatus >> address: anObject [

	address := anObject
]

{ #category : #accessing }
CVTLStatus >> bePrompted [

	state := #prompted
]

{ #category : #accessing }
CVTLStatus >> beStepping [

	state := #stepping
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
CVTLStatus >> pos [

	^ pos
]

{ #category : #accessing }
CVTLStatus >> pos: anInteger [

	pos := anInteger
]

{ #category : #printing }
CVTLStatus >> printOn: aStream [

	aStream
		nextPutAll: 'Status[state=';
		nextPutAll: state asString;
		nextPutAll: ',pos=';
		nextPutAll: pos asString;
		nextPutAll: ',address=';
		nextPutAll: address asString;
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
