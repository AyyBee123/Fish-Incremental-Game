@tool
extends EditorScript

const SPECIES_FOLDER: String = "res://Resources/Species/"
const GENERIC_UPGRADES: Array[String] = [
	"res://Resources/Upgrades/Species/increase_1.tres",
]


func _run() -> void:
	var dir: DirAccess = DirAccess.open(SPECIES_FOLDER)
	
	if dir == null:
		push_error("Could not open species folder.")
		return
	
	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".tres"):
			process_species(SPECIES_FOLDER + file_name)
		
		file_name = dir.get_next()
	
	dir.list_dir_end()


func process_species(path: String) -> void:
	var species: FishSpeciesResource = load(path) as FishSpeciesResource
	
	if species == null:
		return
	
	var new_upgrades: Array[UpgradeResource] = []
	
	# copy existing upgrades into a new array
	for existing: UpgradeResource in species.available_upgrades:
		new_upgrades.append(existing)
	
	var added: int = 0
	
	for upgrade_path: String in GENERIC_UPGRADES:
		var upgrade: UpgradeResource = load(upgrade_path) as UpgradeResource
		
		if upgrade == null:
			push_warning("Could not load upgrade: " + upgrade_path)
			continue
		
		var already_exists: bool = false
		
		for existing: UpgradeResource in new_upgrades:
			if existing.id == upgrade.id:
				already_exists = true
				break
		
		if not already_exists:
			new_upgrades.append(upgrade)
			added += 1
		
	if added > 0:
		species.available_upgrades = new_upgrades
		
		var error: Error = ResourceSaver.save(species, path)
		
		if error == OK:
			print("Updated ", path, " - added ", added, " upgrades.")
		else:
			push_error("Failed to save: " + path)
