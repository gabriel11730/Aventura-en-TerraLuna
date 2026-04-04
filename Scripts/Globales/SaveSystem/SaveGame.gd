extends Resource

class_name SaveGame

## Path to the level that was loaded when the game was saved
@export var level_path:String
## Position of the player
@export var position_personaje:Vector2
## Health of the player
@export var life_personaje:float
## Coins Collected
@export var coins_collected_personaje: int
## Habilidades desbloqueadas
@export var dash_estado: bool
@export var doble_salto_estado: bool
@export var sword_estado: bool
## Antorcha Desbloqueada
@export var antorcha_estado: bool

# deberia modificar directamente los valores en GameState?

## Saved data for all dynamic parts of the level
@export var saved_data:Array[SavedData] = []
