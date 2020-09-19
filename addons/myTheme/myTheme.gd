tool
class_name MyTheme
extends Theme

var boolData := {}
var enumData := {}
var enumNames := {}
var floatData := {}
var soundData := {}

static func get_class_static() -> String:
	return "MyTheme"

func clear_bool(p_name:String, p_type:String) -> void:
	if boolData.has(p_type):
		boolData[p_type].erase(p_name)
		if boolData[p_type].size() == 0:
			boolData.erase(p_type)
		property_list_changed_notify()
		emit_signal("changed")

func clear_enum(p_name:String, p_type:String) -> void:
	if enumData.has(p_type):
		enumData[p_type].erase(p_name)
		if enumData[p_type].size() == 0:
			enumData.erase(p_type)
		property_list_changed_notify()
		emit_signal("changed")
	if enumNames.has(p_type):
		enumNames[p_type].erase(p_name)
		if enumNames[p_type].size() == 0:
			enumNames.erase(p_type)

func clear_float(p_name:String, p_type:String) -> void:
	if floatData.has(p_type):
		floatData[p_type].erase(p_name)
		if floatData[p_type].size() == 0:
			floatData.erase(p_type)
		property_list_changed_notify()
		emit_signal("changed")

func clear_sound(p_name:String, p_type:String) -> void:
	if soundData.has(p_type):
		soundData[p_type].erase(p_name)
		if soundData[p_type].size() == 0:
			soundData.erase(p_type)
		property_list_changed_notify()
		emit_signal("changed")

func get_bool(p_name:String, p_type:String) -> bool:
	if boolData.has(p_type) && boolData[p_type].has(p_name):
		return boolData[p_type][p_name]
	return false

func get_bool_list(p_type:String) -> PoolStringArray:
	if boolData.has(p_type):
		return PoolStringArray(boolData[p_type].values())
	return PoolStringArray()

func get_enum(p_name:String, p_type:String) -> int:
	if enumData.has(p_type) && enumData[p_type].has(p_name):
		return enumData[p_type][p_name]
	return 0

func get_enum_list(p_type:String) -> PoolStringArray:
	if enumData.has(p_type):
		return PoolStringArray(enumData[p_type].values())
	return PoolStringArray()

func get_enum_name_list(p_name:String, p_type:String) -> PoolStringArray:
	if enumNames.has(p_type) && enumNames[p_type].has(p_name):
		return enumNames[p_type][p_name]
	return PoolStringArray()

func get_float(p_name:String, p_type:String) -> float:
	if floatData.has(p_type) && floatData[p_type].has(p_name):
		return floatData[p_type][p_name]
	return 0.0

func get_float_list(p_type:String) -> PoolStringArray:
	if floatData.has(p_type):
		return PoolStringArray(floatData[p_type].values())
	return PoolStringArray()

func get_sound(p_name:String, p_type:String) -> AudioStream:
	if soundData.has(p_type) && soundData[p_type].has(p_name):
		return soundData[p_type][p_name]
	return null

func get_sound_list(p_type:String) -> PoolStringArray:
	if soundData.has(p_type):
		return PoolStringArray(soundData[p_type].values())
	return PoolStringArray()

func has_bool(p_name:String, p_type:String) -> bool:
	return boolData.has(p_type) && boolData[p_type].has(p_name)

func has_enum(p_name:String, p_type:String) -> bool:
	return enumData.has(p_type) && enumData[p_type].has(p_name)

func has_float(p_name:String, p_type:String) -> bool:
	return floatData.has(p_type) && enumData[p_type].has(p_name)

func has_sound(p_name:String, p_type:String) -> bool:
	return soundData.has(p_type) && soundData[p_type].has(p_name)

func set_bool(p_name:String, p_type:String, p_value:bool) -> void:
	if !boolData.has(p_type):
		boolData[p_type] = {}
	boolData[p_type][p_name] = p_value
	property_list_changed_notify()
	emit_signal("changed")

func set_enum(p_name:String, p_type:String, p_value:int, p_dict:PoolStringArray = PoolStringArray()) -> void:
	if !enumData.has(p_type):
		enumData[p_type] = {}
	enumData[p_type][p_name] = p_value
	if p_dict.size() > 0:
		if !enumNames.has(p_type):
			enumNames[p_type] = {}
		enumNames[p_type][p_name] = p_dict
	elif !enumNames.has(p_type) || !enumNames[p_type].has(p_name):
		if !enumNames.has(p_type):
			enumNames[p_type] = {}
		enumNames[p_type][p_name] = p_dict
	property_list_changed_notify()
	emit_signal("changed")

func set_float(p_name:String, p_type:String, p_value:float) -> void:
	if !floatData.has(p_type):
		floatData[p_type] = {}
	floatData[p_type][p_name] = p_value
	property_list_changed_notify()
	emit_signal("changed")

func set_sound(p_name:String, p_type:String, p_sound:AudioStream) -> void:
	if !soundData.has(p_type):
		soundData[p_type] = {}
	if soundData[p_type].has(p_name) && soundData[p_type][p_name] != null:
		soundData[p_type][p_name].disconnect("changed", self, "_emit_theme_changed")
	soundData[p_type][p_name] = p_sound
	if p_sound != null:
		p_sound.connect("changed", self, "_emit_theme_changed")
	property_list_changed_notify()
	emit_signal("changed")

func _emit_theme_changed():
	emit_signal("changed")

func clear():
	boolData.clear()
	enumData.clear()
	enumNames.clear()
	floatData.clear()
	soundData.clear()
	property_list_changed_notify()
	.clear()

func get_type_list(p_type) -> PoolStringArray:
	var ret = .get_type_list(p_type)
	var dict := {}
	for i in boolData.keys():
		dict[i] = null
	for i in enumData.keys():
		dict[i] = null
	for i in floatData.keys():
		dict[i] = null
	for i in soundData.keys():
		dict[i] = null
	
	for i in dict.keys():
		if not i in ret:
			ret.append(i)
	
	return ret

func copy_theme(p_theme:Theme):
	if p_theme is get_script():
		_dictionary_copy(boolData, p_theme.boolData)
		_dictionary_copy(enumData, p_theme.enumData)
		_dictionary_copy(enumNames, p_theme.enumNames)
		_dictionary_copy(floatData, p_theme.floatData)
		_dictionary_copy(soundData, p_theme.soundData)
	.copy_theme(p_theme)

func _dictionary_copy(p_source:Dictionary, p_target:Dictionary):
	for i in p_target.keys():
		if p_source.has(i):
			for j in p_target[i].keys():
				p_source[i][j] = p_target[i][j]
		else:
			p_source[i] = p_target[i]

func copy_default_theme():
	var needScanDirs := [ "res://" ]
	var gds := []
	var dir := Directory.new()
	var file:String
	var path:String
	while needScanDirs.size() > 0:
		path = needScanDirs[0]
		needScanDirs.pop_front()
		dir.change_dir(path)
		dir.list_dir_begin(true)
		file = dir.get_next()
		while file != "":
			if dir.current_is_dir():
				if path.ends_with("//"):
					needScanDirs.append(path + file)
				else:
					needScanDirs.append(path + "/" + file)
			elif file.get_extension() == "gd":
				if path.ends_with("//"):
					gds.append(path + file)
				else:
					gds.append(path + "/" + file)
			file = dir.get_next()
	
	var temp
	for i in gds:
		temp = load(i)
		var methodList = temp.get_script_method_list()
		for j in methodList:
			if j.has("name") && j["name"] == "_register_default_theme":
				temp.call("_register_default_theme", self)
#				temp = temp.new()
#				if temp == null:
#					break
#				if temp is Control:
#					temp._register_default_theme(self)
#					temp.queue_free()
#				elif not temp is Reference:
#					if temp is Node:
#						temp.queue_free()
#					else:
#						temp.free()
				break
	

#	var classNames = ClassDB.get_inheriters_from_class("Control")
#	for i in classNames.size():
#		if ClassDB.class_has_method(classNames[i], "_register_default_theme", true):
##			var expression = Expression.new()
##			var err = expression.parse(classNames[i] + "._register_default_theme(self)", [ "self" ])
##			if err == OK:
##				expression.execute([self])
#			var node = ClassDB.instance(classNames[i])
#			node._register_default_theme(self)
#			node.free()
	.copy_default_theme()
#	print("Inherit classes = ", str(classNames))


func _set(p_property, p_value):
	var array = p_property.split("/", true, 2)
	if array.size() < 3:
		return false
	
	if array[1] == "bools":
		set_bool(array[2], array[0], p_value)
	elif array[1] == "enums":
		set_enum(array[2], array[0], p_value)
	elif array[1] == "floats":
		set_float(array[2], array[0], p_value)
	elif array[1] == "sounds":
		set_sound(array[2], array[0], p_value)
	else:
		return false
	return true

func _get(p_property):
	var array = p_property.split("/", true, 2)
	
	if array.size() < 3:
		return null
	
	if array[1] == "bools":
		return get_bool(array[2], array[0])
	elif array[1] == "enums":
		return get_enum(array[2], array[0])
	elif array[1] == "floats":
		return get_float(array[2], array[0])
	elif array[1] == "sounds":
		var sound = get_sound(array[2], array[0])
		if sound == null:
			return Object()
		return sound

	return null

func _get_property_list():
	var ret = []
	var dict:Dictionary
	for i in boolData.keys():
		for j in boolData[i].keys():
			dict = {}
			dict["name"] = i + "/bools/" + j
			dict["type"] = TYPE_BOOL
			dict["usage"] = PROPERTY_USAGE_DEFAULT
			ret.append(dict)
	for i in enumData.keys():
		for j in enumData[i].keys():
			dict = {}
			dict["name"] = i + "/enums/" + j
			dict["type"] = TYPE_INT
			dict["usage"] = PROPERTY_USAGE_DEFAULT
			dict["hint"] = PROPERTY_HINT_ENUM
			if enumNames.has(i) && enumNames[i].has(j):
				dict["hint_string"] = enumNames[i][j]
			ret.append(dict)
	for i in floatData.keys():
		for j in floatData[i].keys():
			dict = {}
			dict["name"] = i + "/floats/" + j
			dict["type"] = TYPE_REAL
			dict["usage"] = PROPERTY_USAGE_DEFAULT
			ret.append(dict)
	for i in soundData.keys():
		for j in soundData[i].keys():
			dict = {}
			dict["name"] = i + "/sounds/" + j
			dict["type"] = TYPE_OBJECT
			dict["usage"] = PROPERTY_USAGE_DEFAULT
			dict["hint"] = PROPERTY_HINT_RESOURCE_TYPE
			dict["hint_string"] = "AudioStream"
			ret.append(dict)
	return ret
