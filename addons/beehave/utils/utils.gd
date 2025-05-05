@tool


static func get_plugin() -> EditorPlugin:
	var tree: SceneTree = Engine.get_main_loop()
	return tree.get_root().get_child(0).get_node_or_null("BeehavePlugin")


static func get_editor_scale() -> float:
	var plugin := get_plugin()
	if plugin:
		return plugin.get_editor_interface().get_editor_scale()
	return 1.0


static func get_frames() -> RefCounted:
	var plugin := get_plugin()
	if plugin:
		return plugin.frames
	push_error("Can't find Beehave Plugin")
	return null

## Takes a float time value and formats it as a string with optional custom decimal delimiter[br]
## Trims trailing zeros from the decimal part and omits delimiter if no decimals remain[br]
##[br]
## Args:[br]
##     time (float): The time value to format[br]
##     delimiter (String): The character to use as decimal separator (default: ",")[br]
##[br]
## Returns:[br]
##     String: Formatted time string with 3 decimal places maximum, trailing zeros removed[br]
##[br]
## [b]Example:[/b]
##[codeblock]
##     format_time(12.340) -> "12,34"
##     format_time(12.000) -> "12"
##     format_time(12.340, ".") -> "12.34"
##[/codeblock]
static func format_time(time: float, delimiter := ",") -> String:
	# Format with 3 decimals, replace '.' with the chosen delimiter
	var formatted = String.num(time, 3).replace(".", delimiter)

	var parts = formatted.split(delimiter)
	if parts.size() != 2:
		return formatted  # Edge case (unlikely with 3 decimals)

	var left = parts[0]
	var right = parts[1]

	# Trim trailing zeros from the decimal part
	while right.ends_with("0"):
		right = right.substr(0, right.length() - 1)

	# Rebuild the string with the chosen delimiter (or omit if no decimals left)
	return "%s%s%s" % [left, delimiter, right] if not right.is_empty() else left
