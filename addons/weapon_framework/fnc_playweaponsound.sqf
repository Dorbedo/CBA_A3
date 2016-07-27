#include "script_component.hpp"
params ["_unit","_sound","_Sound_Location"];


if (isnil "_sound" || _sound == "") exitwith {}; // No sound set, don't play anything.
if (isNil "_unit") exitwith {false}; //Rarely happens that _unit stops existing

_rhand = _unit selectionPosition _Sound_Location;
_posStart = _unit modeltoworld _rhand;
_obj = "#particlesource" createVehicleLocal _posStart;
_obj attachto [_unit,_rhand];
_obj say3d _sound;
sleep 10;
deleteVehicle _obj;