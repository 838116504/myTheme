tool
class_name ControlMethod
extends Reference

const BOOL_META_NAME = "boolOverride"
const ENUM_META_NAME = "enumOverride"
const FLOAT_META_NAME = "floatOverride"
const SOUND_META_NAME = "soundOverride"

static func _add_override(p_control:Control, p_name:String, p_value, p_metaName:String):
	if p_value == null:
		if p_control.has_meta(p_metaName):
			var data = p_control.get_meta(p_metaName)
			if data is Dictionary:
				data.erase(p_name)
		return
	
	var data
	if p_control.has_meta(p_metaName):
		data = p_control.get_meta(p_metaName)
		if not data is Dictionary:
			data = {}
			p_control.set_meta(p_metaName, data)
	else:
		data = {}
		p_control.set_meta(p_metaName, data)
	data[p_name] = p_value
	p_control.notification(Control.NOTIFICATION_THEME_CHANGED)

static func add_bool_override(p_control:Control, p_name:String, p_value):
	if p_value != null:
		assert(p_value is bool)
	_add_override(p_control, p_name, p_value, BOOL_META_NAME)

static func add_enum_override(p_control:Control, p_name:String, p_value):
	if p_value != null:
		assert(p_value is int)
	_add_override(p_control, p_name, p_value, ENUM_META_NAME)

static func add_float_override(p_control:Control, p_name:String, p_value):
	if p_value == null:
		if p_control.has_meta(FLOAT_META_NAME):
			var data = p_control.get_meta(FLOAT_META_NAME)
			if data is Dictionary:
				data.erase(p_name)
		return
	
	assert(p_value is float || p_value is int)
	var data
	if p_control.has_meta(FLOAT_META_NAME):
		data = p_control.get_meta(FLOAT_META_NAME)
		if not data is Dictionary:
			data = {}
			p_control.set_meta(FLOAT_META_NAME, data)
	else:
		data = {}
		p_control.set_meta(FLOAT_META_NAME, data)
	data[p_name] = float(p_value)
	p_control.notification(Control.NOTIFICATION_THEME_CHANGED)

static func add_sound_override(p_control:Control, p_name:String, p_value):
	if p_value == null && not p_value is Object:
		if p_control.has_meta(SOUND_META_NAME):
			var data = p_control.get_meta(SOUND_META_NAME)
			if data is Dictionary:
				data.erase(p_name)
		return
	
	var data
	if p_control.has_meta(SOUND_META_NAME):
		data = p_control.get_meta(SOUND_META_NAME)
		if not data is Dictionary:
			data = {}
			p_control.set_meta(SOUND_META_NAME, data)
	else:
		data = {}
		p_control.set_meta(SOUND_META_NAME, data)
	data[p_name] = p_value
	p_control.notification(Control.NOTIFICATION_THEME_CHANGED)

static func get_bool(p_control:Control, p_name:String, p_type := "", p_default := true):
	if p_type == "" || p_type == p_control.get_class():
		if has_bool_override(p_control, p_name):
			return p_control.get_meta(BOOL_META_NAME)[p_name]
	var type = p_control.get_class() if p_type == "" else p_type
	var classNameArray = []
	classNameArray.append(type)
	var control = p_control
	while control.has_method("get_parent_class"):
		var temp = control.get_parent_class()
		if not temp is GDScript:
			break
		temp = temp.new()
		if control != p_control:
			control.queue_free()
		control = temp
		if control.has_method("get_class"):
			classNameArray.append(control.get_class())
	if control != p_control:
		control.queue_free()
	
	var i = p_control
	while i != null:
		for j in classNameArray:
			if i.theme is MyTheme && i.theme.has_bool(p_name, j):
				return i.theme.get_bool(p_name, j)
		
		i = i.get_parent()
		if i == null || not i is Control:
			break
	
	var defaultProjectThemePath = ProjectSettings.get_setting("gui/theme/custom")
	var dir = Directory.new()
	if dir.file_exists(defaultProjectThemePath):
		var defaultProjectTheme = load(defaultProjectThemePath)
		if defaultProjectTheme != null && defaultProjectTheme is MyTheme && defaultProjectTheme.has_bool(p_name, type):
			return defaultProjectTheme.get_bool(p_name, type)
	
	if !p_default:
		return null
	
	var defaultTheme = MyTheme.new()
	defaultTheme.copy_default_theme()
	return defaultTheme.get_bool(p_name, type, false)

static func get_enum(p_control:Control, p_name:String, p_type := "", p_default := true):
	if p_type == "" || p_type == p_control.get_class():
		if has_enum_override(p_control, p_name):
			return p_control.get_meta(ENUM_META_NAME)[p_name]
	
	var type = p_control.get_class() if p_type == "" else p_type
	var classNameArray = []
	classNameArray.append(type)
	var control = p_control
	while control.has_method("get_parent_class"):
		var temp = control.get_parent_class()
		if not temp is GDScript:
			break
		temp = temp.new()
		if control != p_control:
			control.queue_free()
		control = temp
		if control.has_method("get_class"):
			classNameArray.append(control.get_class())
	if control != p_control:
		control.queue_free()
	
	var i = p_control
	while i != null:
		for j in classNameArray:
			if i.theme is MyTheme && i.theme.has_enum(p_name, j):
				return i.theme.get_enum(p_name, j)
		
		i = i.get_parent()
		if i == null || not i is Control:
			break
	
	var defaultProjectThemePath = ProjectSettings.get_setting("gui/theme/custom")
	var dir = Directory.new()
	if dir.file_exists(defaultProjectThemePath):
		var defaultProjectTheme = load(defaultProjectThemePath)
		if defaultProjectTheme != null && defaultProjectTheme is MyTheme && defaultProjectTheme.has_enum(p_name, type):
			return defaultProjectTheme.get_enum(p_name, type)
	
	if !p_default:
		return null
	
	var defaultTheme = MyTheme.new()
	defaultTheme.copy_default_theme()
	return defaultTheme.get_enum(p_name, type, false)

static func get_float(p_control:Control, p_name:String, p_type := "", p_default := true):
	if p_type == "" || p_type == p_control.get_class():
		if has_float_override(p_control, p_name):
			return p_control.get_meta(FLOAT_META_NAME)[p_name]
	
	var type = p_control.get_class() if p_type == "" else p_type
	var classNameArray = []
	classNameArray.append(type)
	var control = p_control
	while control.has_method("get_parent_class"):
		var temp = control.get_parent_class()
		if not temp is GDScript:
			break
		temp = temp.new()
		if control != p_control:
			control.queue_free()
		control = temp
		if control.has_method("get_class"):
			classNameArray.append(control.get_class())
	if control != p_control:
		control.queue_free()
	
	var i = p_control
	while i != null:
		for j in classNameArray:
			if i.theme is MyTheme && i.theme.has_float(p_name, j):
				return i.theme.get_float(p_name, j)
		
		i = i.get_parent()
		if i == null || not i is Control:
			break
	
	var defaultProjectThemePath = ProjectSettings.get_setting("gui/theme/custom")
	var dir = Directory.new()
	if dir.file_exists(defaultProjectThemePath):
		var defaultProjectTheme = load(defaultProjectThemePath)
		if defaultProjectTheme != null && defaultProjectTheme is MyTheme && defaultProjectTheme.has_float(p_name, type):
			return defaultProjectTheme.get_float(p_name, type)
	
	if !p_default:
		return null
	
	var defaultTheme = MyTheme.new()
	defaultTheme.copy_default_theme()
	return defaultTheme.get_float(p_name, type, false)


static func get_sound(p_control:Control, p_name:String, p_type := "", p_default := true):
	if p_type == "" || p_type == p_control.get_class():
		if has_sound_override(p_control, p_name):
			var data = p_control.get_meta(SOUND_META_NAME)
			return data[p_name]
	
	var type = p_control.get_class() if p_type == "" else p_type
	var classNameArray = []
	classNameArray.append(type)
	var control = p_control
	while control.has_method("get_parent_class"):
		var temp = control.get_parent_class()
		if not temp is GDScript:
			break
		temp = temp.new()
		if control != p_control:
			control.queue_free()
		control = temp
		if control.has_method("get_class"):
			classNameArray.append(control.get_class())
	if control != p_control:
		control.queue_free()
	
	var i = p_control
	while i != null:
		for j in classNameArray:
			if i.theme is MyTheme && i.theme.has_sound(p_name, j):
				return i.theme.get_sound(p_name, j)
		
		i = i.get_parent()
		if i == null || not i is Control:
			break
	
	var defaultProjectThemePath = ProjectSettings.get_setting("gui/theme/custom")
	var dir = Directory.new()
	if dir.file_exists(defaultProjectThemePath):
		var defaultProjectTheme = load(defaultProjectThemePath)
		if defaultProjectTheme != null && defaultProjectTheme is MyTheme && defaultProjectTheme.has_sound(p_name, type):
			return defaultProjectTheme.get_sound(p_name, type)
	
	if !p_default:
		return null
	
	var defaultTheme = MyTheme.new()
	defaultTheme.copy_default_theme()
	return defaultTheme.get_sound(p_name, type, false)


static func has_bool(p_control:Control, p_name:String, p_type := "") -> bool:
	if p_type == "" || p_type == p_control.get_class():
		if has_bool_override(p_control, p_name):
			return true
	var type = p_control.get_class() if p_type == "" else p_type
	var classNameArray = []
	classNameArray.append(type)
	var control = p_control
	while control.has_method("get_parent_class"):
		var temp = control.get_parent_class()
		if not temp is GDScript:
			break
		temp = temp.new()
		if control != p_control:
			control.queue_free()
		control = temp
		if control.has_method("get_class"):
			classNameArray.append(control.get_class())
	if control != p_control:
		control.queue_free()
	
	var i = p_control
	while i != null:
		for j in classNameArray:
			if i.theme is MyTheme && i.theme.has_bool(p_name, j):
				return true
		
		i = i.get_parent()
		if i == null || not i is Control:
			break
	var defaultProjectThemePath = ProjectSettings.get_setting("gui/theme/custom")
	var dir = Directory.new()
	if dir.file_exists(defaultProjectThemePath):
		var defaultProjectTheme = load(defaultProjectThemePath)
		if defaultProjectTheme != null && defaultProjectTheme is MyTheme && defaultProjectTheme.has_bool(p_name, type):
			return true
	
	return false

static func has_bool_override(p_control:Control, p_name:String) -> bool:
	return p_control.has_meta(BOOL_META_NAME) && p_control.get_meta(BOOL_META_NAME) is Dictionary && p_control.get_meta(BOOL_META_NAME).has(p_name)

static func has_enum(p_control:Control, p_name:String, p_type = "") -> bool:
	if p_type == "" || p_type == p_control.get_class():
		if has_enum_override(p_control, p_name):
			return true
	
	var type = p_control.get_class() if p_type == "" else p_type
	var classNameArray = []
	classNameArray.append(type)
	var control = p_control
	while control.has_method("get_parent_class"):
		var temp = control.get_parent_class()
		if not temp is GDScript:
			break
		temp = temp.new()
		if control != p_control:
			control.queue_free()
		control = temp
		if control.has_method("get_class"):
			classNameArray.append(control.get_class())
	if control != p_control:
		control.queue_free()
	
	var i = p_control
	while i != null:
		for j in classNameArray:
			if i.theme is MyTheme && i.theme.has_enum(p_name, j):
				return true
		
		i = i.get_parent()
		if i == null || not i is Control:
			break
	
	var defaultProjectThemePath = ProjectSettings.get_setting("gui/theme/custom")
	var dir = Directory.new()
	if dir.file_exists(defaultProjectThemePath):
		var defaultProjectTheme = load(defaultProjectThemePath)
		if defaultProjectTheme != null && defaultProjectTheme is MyTheme && defaultProjectTheme.has_enum(p_name, type):
			return true

	return false

static func has_enum_override(p_control:Control, p_name:String) -> bool:
	return p_control.has_meta(ENUM_META_NAME) && p_control.get_meta(ENUM_META_NAME) is Dictionary && p_control.get_meta(ENUM_META_NAME).has(p_name)

static func has_float(p_control:Control, p_name:String, p_type = ""):
	if p_type == "" || p_type == p_control.get_class():
		if has_float_override(p_control, p_name):
			return true
	
	var type = p_control.get_class() if p_type == "" else p_type
	var classNameArray = []
	classNameArray.append(type)
	var control = p_control
	while control.has_method("get_parent_class"):
		var temp = control.get_parent_class()
		if not temp is GDScript:
			break
		temp = temp.new()
		if control != p_control:
			control.queue_free()
		control = temp
		if control.has_method("get_class"):
			classNameArray.append(control.get_class())
	if control != p_control:
		control.queue_free()
	
	var i = p_control
	while i != null:
		for j in classNameArray:
			if i.theme is MyTheme && i.theme.has_float(p_name, j):
				return true
		
		i = i.get_parent()
		if i == null || not i is Control:
			break
	
	var defaultProjectThemePath = ProjectSettings.get_setting("gui/theme/custom")
	var dir = Directory.new()
	if dir.file_exists(defaultProjectThemePath):
		var defaultProjectTheme = load(defaultProjectThemePath)
		if defaultProjectTheme != null && defaultProjectTheme is MyTheme && defaultProjectTheme.has_float(p_name, type):
			return true
	
	return false

static func has_float_override(p_control:Control, p_name:String) -> bool:
	return p_control.has_meta(FLOAT_META_NAME) && p_control.get_meta(FLOAT_META_NAME) is Dictionary && p_control.get_meta(FLOAT_META_NAME).has(p_name)

static func has_sound(p_control:Control, p_name:String, p_type = "") -> bool:
	if p_type == "" || p_type == p_control.get_class():
		if has_sound_override(p_control, p_name):
			return true
	
	var type = p_control.get_class() if p_type == "" else p_type
	var classNameArray = []
	classNameArray.append(type)
	var control = p_control
	while control.has_method("get_parent_class"):
		var temp = control.get_parent_class()
		if not temp is GDScript:
			break
		temp = temp.new()
		if control != p_control:
			control.queue_free()
		control = temp
		if control.has_method("get_class"):
			classNameArray.append(control.get_class())
	if control != p_control:
		control.queue_free()
	
	var i = p_control
	while i != null:
		for j in classNameArray:
			if i.theme is MyTheme && i.theme.has_sound(p_name, j):
				return true
		
		i = i.get_parent()
		if i == null || not i is Control:
			break
	
	var defaultProjectThemePath = ProjectSettings.get_setting("gui/theme/custom")
	var dir = Directory.new()
	if dir.file_exists(defaultProjectThemePath):
		var defaultProjectTheme = load(defaultProjectThemePath)
		if defaultProjectTheme != null && defaultProjectTheme is MyTheme && defaultProjectTheme.has_sound(p_name, type):
			return true
	
	return false

static func has_sound_override(p_control:Control, p_name:String) -> bool:
	return p_control.has_meta(SOUND_META_NAME) && p_control.get_meta(SOUND_META_NAME) is Dictionary && p_control.get_meta(SOUND_META_NAME).has(p_name)
