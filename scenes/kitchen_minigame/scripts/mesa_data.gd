extends Node

var paths: Dictionary = {
	"assento_1": {
		"mesa_coord": [Vector3(-5, 1, -3)],
			
		"path": [
			Vector3(9, 1, -4),
			Vector3(4, 1, -4),
			Vector3(4, 1, -5),
			Vector3(-2, 1, -5),
			Vector3(-4, 1, -5),
			Vector3(-4, 1, -3) #Assento_1_coord
		],
		"ocupado": 0,
	},
	"assento_2": {
		"mesa_coord": [Vector3(-2, 1, -3)],
			
		"path": [
			Vector3(9, 1, -4),
			Vector3(4, 1, -4),
			Vector3(4, 1, -5),
			Vector3(-2, 1, -5),
			Vector3(-2, 1, -4) #Assento_2_coord
		],
		"ocupado": 0,
	},
	
	"assento_3": {
		"mesa_coord": [Vector3(2, 1, -4)],
			
		"path": [
			Vector3(9, 1, -4),
			Vector3(3, 1, -4) #Assento_3_coord
		],
		"ocupado": 0,
	},
	
	"assento_4": {
		"mesa_coord": [Vector3(5, 1, -3)],
			
		"path": [
			Vector3(9, 1, -4),
			Vector3(4, 1, -4),
			Vector3(4, 1, -3) #Assento_4_coord
		],
		"ocupado": 0,
	}
}
