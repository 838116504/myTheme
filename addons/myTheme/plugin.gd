tool
extends EditorPlugin


var themeVBC
var themeMenuPopup
var themeToolBtn
var myAddDelDialog
var typeEdit := LineEdit.new()
var nameEdit := LineEdit.new()
var typeMenu := MenuButton.new()
var nameLabel := Label.new()
var nameHBC := HBoxContainer.new()
var nameMenu := MenuButton.new()
var typeSelectLabel := Label.new()
var typeSelectBtn := OptionButton.new()
var rootContainer
var tempThemeMenuSignal
var popupMode
var editTheme

func _enter_tree():
#	add_custom_type("MyControl", "Control", preload("myControl.gd"), get_editor_interface().get_base_control().get_icon("Control", "EditorIcons"))
	
	_find_themeVBC()
	_create_add_del_dialog()

func _find_themeVBC():
	var dummyControl := Control.new()
	var bottomBtn = add_control_to_bottom_panel(dummyControl, "dummy")
	bottomBtn.hide()
	
	for i in bottomBtn.get_parent().get_parent().get_parent().get_children():
		if i.get_class() == "ThemeEditor":
			themeVBC = i
			themeToolBtn = bottomBtn.get_parent().get_child(i.get_index())
			themeMenuPopup = themeVBC.get_child(0).get_child(2).get_popup()
			rootContainer = themeVBC.get_child(1)
			break
	remove_control_from_bottom_panel(dummyControl)
	dummyControl.queue_free()

func _create_add_del_dialog():
	if themeVBC == null:
		return
	
	myAddDelDialog = ConfirmationDialog.new()
	myAddDelDialog.hide()
	myAddDelDialog.get_ok().connect("pressed", self, "_my_add_del_dialog_confirmed")
	themeVBC.add_child(myAddDelDialog)
	
	var vbc = VBoxContainer.new()
	myAddDelDialog.add_child(vbc)
	
	var typeLabel = Label.new()
	typeLabel.text = "Type:"
	vbc.add_child(typeLabel)
	
	var typeHBC = HBoxContainer.new()
	vbc.add_child(typeHBC)
	
	typeEdit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	typeHBC.add_child(typeEdit)
	
	typeMenu.flat = false
	typeMenu.text = ".."
	typeMenu.get_popup().connect("id_pressed", self, "_type_menu_id_pressed")
	typeHBC.add_child(typeMenu)
	
	nameLabel.text = "Name:"
	vbc.add_child(nameLabel)
	
	vbc.add_child(nameHBC)
	
	nameEdit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	nameHBC.add_child(nameEdit)
	
	nameMenu.flat = false
	nameMenu.text = ".."
	nameMenu.get_popup().connect("id_pressed", self, "_name_menu_id_pressed")
	nameMenu.get_popup().connect("about_to_show", self, "_name_menu_about_to_show")
	nameHBC.add_child(nameMenu)
	
	typeSelectLabel.text = "Data Type:"
	vbc.add_child(typeSelectLabel)
	
	typeSelectBtn.add_item("Icon")
	typeSelectBtn.add_item("Style")
	typeSelectBtn.add_item("Font")
	typeSelectBtn.add_item("Color")
	typeSelectBtn.add_item("Constant")
	typeSelectBtn.add_item("Bool")
	typeSelectBtn.add_item("Enum")
	typeSelectBtn.add_item("Float")
	typeSelectBtn.add_item("Sound")
	vbc.add_child(typeSelectBtn)

func _exit_tree():
#	remove_custom_type("MyControl")
	pass

func _type_menu_id_pressed(p_id):
	typeEdit.text = typeMenu.get_popup().get_item_text(p_id)

func _name_menu_id_pressed(p_id):
	nameEdit.text = nameMenu.get_popup().get_item_text(p_id)

func _name_menu_about_to_show():
	var type = typeEdit.text
	var names
	if popupMode == POPUP_ADD:
		var baseTheme = MyTheme.new()
		baseTheme.copy_default_theme()
		match typeSelectBtn.get_selected_id():
			0:
				names = Array(baseTheme.get_icon_list(type))
			1:
				names = Array(baseTheme.get_stylebox_list(type))
			2:
				names = Array(baseTheme.get_font_list(type))
			3:
				names = Array(baseTheme.get_color_list(type))
			4:
				names = Array(baseTheme.get_constant_list(type))
			5:
				names = Array(baseTheme.get_bool_list(type))
			6:
				names = Array(baseTheme.get_enum_list(type))
			7:
				names = Array(baseTheme.get_float_list(type))
			8:
				names = Array(baseTheme.get_sound_list(type))
	else:
		names = Array(editTheme.get_icon_list(type))
		var temp = editTheme.get_stylebox_list(type)
		for i in temp:
			names.append(i)
		temp = Array(editTheme.get_font_list(type))
		for i in temp:
			names.append(i)
		temp = Array(editTheme.get_color_list(type))
		for i in temp:
			names.append(i)
		temp = Array(editTheme.get_constant_list(type))
		for i in temp:
			names.append(i)
		temp = Array(editTheme.get_bool_list(type))
		for i in temp:
			names.append(i)
		temp = Array(editTheme.get_enum_list(type))
		for i in temp:
			names.append(i)
		temp = Array(editTheme.get_float_list(type))
		for i in temp:
			names.append(i)
		temp = Array(editTheme.get_sound_list(type))
		for i in temp:
			names.append(i)
	names.sort()
	var popup = nameMenu.get_popup()
	popup.clear()
	for i in names:
		popup.add_item(i)

func _my_add_del_dialog_confirmed():
	var type = typeEdit.text
	match popupMode:
		POPUP_ADD:
			var fromName = nameEdit.text
			var baseTheme = MyTheme.new()
			baseTheme.copy_default_theme()
			match typeSelectBtn.get_selected_id():
				0:
					editTheme.set_icon(fromName, type, baseTheme.get_icon(fromName, type))
				1:
					editTheme.set_stylebox(fromName, type, baseTheme.get_stylebox(fromName, type))
				2:
					editTheme.set_font(fromName, type, baseTheme.get_font(fromName, type))
				3:
					editTheme.set_color(fromName, type, baseTheme.get_color(fromName, type))
				4:
					editTheme.set_constant(fromName, type, baseTheme.get_constant(fromName, type))
				5:
					editTheme.set_bool(fromName, type, baseTheme.get_bool(fromName, type))
				6:
					editTheme.set_enum(fromName, type, baseTheme.get_enum(fromName, type), baseTheme.get_enum_name_list(fromName, type))
				7:
					editTheme.set_float(fromName, type, baseTheme.get_float(fromName, type))
				8:
					editTheme.set_sound(fromName, type, baseTheme.get_sound(fromName, type))
		POPUP_CLASS_ADD:
			var baseTheme = MyTheme.new()
			baseTheme.copy_default_theme()
			var names = baseTheme.get_icon_list(type)
			for i in names:
				editTheme.set_icon(i, type, baseTheme.get_icon(i, type))
			names = baseTheme.get_stylebox_list(type)
			for i in names:
				editTheme.set_stylebox(i, type, baseTheme.get_stylebox(i, type))
			names = baseTheme.get_font_list(type)
			for i in names:
				editTheme.set_font(i, type, baseTheme.get_font(i, type))
			names = baseTheme.get_color_list(type)
			for i in names:
				editTheme.set_color(i, type, baseTheme.get_color(i, type))
			names = baseTheme.get_constant_list(type)
			for i in names:
				editTheme.set_constant(i, type, baseTheme.get_constant(i, type))
			names = baseTheme.get_bool_list(type)
			for i in names:
				editTheme.set_bool(i, type, baseTheme.get_bool(i, type))
			names = baseTheme.get_enum_list(type)
			for i in names:
				editTheme.set_enum(i, type, baseTheme.get_enum(i, type), baseTheme.get_enum_name_list(i, type))
			names = baseTheme.get_float_list(type)
			for i in names:
				editTheme.set_float(i, type, baseTheme.get_float(i, type))
			names = baseTheme.get_sound_list(type)
			for i in names:
				editTheme.set_sound(i, type, baseTheme.get_sound(i, type))
		POPUP_REMOVE:
			var fromName = nameEdit.text
			match typeSelectBtn.get_selected_id():
				0:
					editTheme.clear_icon(fromName, type)
				1:
					editTheme.clear_stylebox(fromName, type)
				2:
					editTheme.clear_font(fromName, type)
				3:
					editTheme.clear_color(fromName, type)
				4:
					editTheme.clear_constant(fromName, type)
				5:
					editTheme.clear_bool(fromName, type)
				6:
					editTheme.clear_enum(fromName, type)
				7:
					editTheme.clear_float(fromName, type)
				8:
					editTheme.clear_sound(fromName, type)
		POPUP_CLASS_REMOVE:
			var names = editTheme.get_icon_list(type)
			for i in names:
				editTheme.clear_icon(i, type)
			names = editTheme.get_stylebox_list(type)
			for i in names:
				editTheme.clear_stylebox(i, type)
			names = editTheme.get_font_list(type)
			for i in names:
				editTheme.clear_font(i, type)
			names = editTheme.get_color_list(type)
			for i in names:
				editTheme.clear_color(i, type)
			names = editTheme.get_constant_list(type)
			for i in names:
				editTheme.clear_constant(i, type)
			names = editTheme.get_bool_list(type)
			for i in names:
				editTheme.clear_bool(i, type)
			names = editTheme.get_enum_list(type)
			for i in names:
				editTheme.clear_enum(i, type)
			names = editTheme.get_float_list(type)
			for i in names:
				editTheme.clear_float(i, type)
			names = editTheme.get_sound_list(type)
			for i in names:
				editTheme.clear_sound(i, type)

enum { POPUP_ADD = 0, POPUP_CLASS_ADD, POPUP_REMOVE, POPUP_CLASS_REMOVE, POPUP_CREATE_EMPTY, POPUP_CREATE_EDITOR_EMPTY, POPUP_IMPORT_EDITOR_THEME }
func _theme_menu_id_pressed(p_id):
	var baseTheme
	match p_id:
		POPUP_ADD:
			nameLabel.show()
			nameHBC.show()
			typeSelectLabel.show()
			typeSelectBtn.show()
			myAddDelDialog.window_title = "Add Item"
			myAddDelDialog.get_ok().text = "Add"
			myAddDelDialog.popup_centered(Vector2(490, 85))
			baseTheme = MyTheme.new()
			baseTheme.copy_default_theme()
		POPUP_CLASS_ADD:
			nameLabel.hide()
			nameHBC.hide()
			typeSelectLabel.hide()
			typeSelectBtn.hide()
			myAddDelDialog.window_title = "Add All Items"
			myAddDelDialog.get_ok().text = "Add All"
			myAddDelDialog.popup_centered(Vector2(240, 85))
			baseTheme = MyTheme.new()
			baseTheme.copy_default_theme()
		POPUP_REMOVE:
			nameLabel.show()
			nameHBC.show()
			typeSelectLabel.show()
			typeSelectBtn.show()
			myAddDelDialog.window_title = "Remove Item"
			myAddDelDialog.get_ok().text = "Remove"
			myAddDelDialog.popup_centered(Vector2(490, 85))
			baseTheme = editTheme
		POPUP_CLASS_REMOVE:
			nameLabel.hide()
			nameHBC.hide()
			typeSelectLabel.hide()
			typeSelectBtn.hide()
			myAddDelDialog.window_title = "Remove All Items"
			myAddDelDialog.get_ok().text = "Remove All"
			myAddDelDialog.popup_centered(Vector2(240, 85))
			baseTheme = editTheme
		POPUP_CREATE_EMPTY, POPUP_CREATE_EDITOR_EMPTY, POPUP_IMPORT_EDITOR_THEME:
			if p_id != POPUP_CREATE_EMPTY:
				baseTheme = get_editor_interface().get_base_control().theme
			else:
				baseTheme = MyTheme.new()
				baseTheme.copy_default_theme()
			
			editTheme.copy_theme(baseTheme)
			return
	popupMode = p_id
	var popup = typeMenu.get_popup()
	popup.clear()
	var typeNames = Array(baseTheme.get_type_list("?"))
	if p_id == POPUP_ADD || p_id == POPUP_CLASS_ADD:
		var editTypeNames = editTheme.get_type_list("?")
		for i in editTypeNames:
			if not i in typeNames:
				typeNames.append(i)
	
	typeNames.sort()
	for i in typeNames:
		popup.add_item(i)

func handles(p_object):
	if p_object is MyTheme:
		return true
	return false

func edit(p_object):
	editTheme = p_object
	rootContainer.theme = editTheme

func make_visible(p_visible):
	if themeVBC == null:
		return
	if p_visible:
		tempThemeMenuSignal = themeMenuPopup.get_signal_connection_list("id_pressed")
		for i in tempThemeMenuSignal:
			themeMenuPopup.disconnect(i["signal"], i["target"], i["method"])
		themeMenuPopup.connect("id_pressed", self, "_theme_menu_id_pressed")
		themeToolBtn.show()
		make_bottom_panel_item_visible(themeVBC)
	else:
		if themeMenuPopup.is_connected("id_pressed", self, "_theme_menu_id_pressed"):
			themeMenuPopup.disconnect("id_pressed", self, "_theme_menu_id_pressed")
		if tempThemeMenuSignal:
			for i in tempThemeMenuSignal:
				themeMenuPopup.connect(i["signal"], i["target"], i["method"])
			tempThemeMenuSignal = null
		rootContainer.theme = null
		if themeVBC.visible:
			hide_bottom_panel()
		themeToolBtn.hide()
	
	
