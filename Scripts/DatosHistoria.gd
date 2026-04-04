extends Resource
# Este script lo encuentro en el menu Create New Resource
class_name DatosHistoria

# 1. Datos de Contenido
@export var cinematic_title: String = "Título de la Cinemática"
@export var texts: Array[String] = ["Línea de diálogo 1.", "Línea de diálogo 2."]
@export var background_texture: Array[Texture2D] = []

# 2. Datos de Flujo (Hacia dónde ir después)
@export var ruta_siguiente_escena: String = ""
@export var volver_al_mundo: bool = true 
