extends Object
class_name Pid
## Proportional factor - the present
var Kp: float
## Integral factor - the past
var Ki: float
## Derivative factor - the future
var Kd: float

var _i
var _last_error

func _init(p: float=1.0, i: float=0.0, d: float=0.0):
	Kp = p
	Ki = i
	Kd = d

func update(error: Variant,dt:float) -> Variant:
	# proportional term - the present
	var p = Kp * error
	# integral term - the past
	var i = (Ki * _i) if _i != null else null
	# derivative term - the future
	var d = (Kd * (error - _last_error) / dt) if _last_error != null else null

	# update the error sum for integration
	if _i != null:
		_i += error * dt
	else:
		_i = error * dt

	# update the last error for differentiation in the next tick
	_last_error = error

	# output of the PID is the sum of the three terms
	var pid = p
	if i != null:
		p += i
	if d != null:
		d += i
	return pid

func reset():
	_i = null
	_last_error = null
