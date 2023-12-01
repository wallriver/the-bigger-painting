extends Node

@onready var loading_screen = preload("res://scenes/ui/loading_screen.tscn")

var scene_to_load_path: String
var loading_screen_instance: Node
var loading: bool = false

func load_scene(path: String):
	print("about to load " + path)
	var current_scene = get_tree().current_scene
	scene_to_load_path = path
	loading = true
	
	loading_screen_instance = loading_screen.instantiate()
	get_tree().root.call_deferred("add_child", loading_screen_instance)
	
	ResourceLoader.load_threaded_request(path)
	
#	if ResourceLoader.has_cached(path):
#		print("we have cached it")
#		ResourceLoader.load_threaded_get(path)
#	else:
#		print("we have not cached it yet")
#		ResourceLoader.load_threaded_request(path)
	
	current_scene.queue_free()

func _process(_delta):
	if not loading:
		return
	
	var progress = []
	var status = ResourceLoader.load_threaded_get_status(scene_to_load_path, progress)
	print("loading is true, status is " + str(status))
	print(str(progress))
	print(str(loading_screen_instance))
	
	if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		loading_screen_instance.progress_bar.value = progress[0] * 100
		print("progress is " + str(loading_screen_instance.progress_bar.value))
		loading_screen_instance.show_message("loading...")		
	elif status == ResourceLoader.THREAD_LOAD_LOADED:
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(scene_to_load_path))
		loading_screen_instance.queue_free()
		loading = false
	elif status == ResourceLoader.THREAD_LOAD_FAILED:
		print("ResourceLoader.THREAD_LOAD_FAILED")
		loading_screen_instance.show_message("loading failed")
		loading = false
	elif status == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
		print("ResourceLoader.THREAD_LOAD_INVALID_RESOURCE")
		loading_screen_instance.show_message("loading failed: invalid resource")
		loading = false
	else:
		print("error while loading the next scene: " + str(status))
		loading_screen_instance.show_message("loading failed: error while loading (" + str(status) + ")")		
		loading = false
