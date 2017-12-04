/* ----------------------------------------------------------------------------
Function: CBA_fnc_fleximenu_add

Description:
    adds an Option to the flexiMenu

Parameters:
    0: the target of the flexiMenu. It can be "player" or classname(s) of the cursortarget, where the menu can be opened on <STRING/ARRAY>
    1: DIK_KEYS <ARRAY>
    2: the priority of the action <SCALAR>
    3: MenuSource the code to be executed on selection <STRING>
    4: hide the menu on death of the player <BOOLEAN>

Returns:
    a list of all fleximenus <ARRAY>

Examples:
    (begin example)
        ["player",[],-3,"_this call TFAR_fnc_swRadioMenu",true] call cba_fnc_fleximenu_add;
    (end)

Author:
    Dr. Eyeball
---------------------------------------------------------------------------- */
//#define DEBUG_MODE_FULL
#include "\x\cba\addons\ui\script_component.hpp"

TRACE_1("",_this);

private ["_msg", "_exit", "_list", "_key"];
// _this = ["player", [DIK_LSHIFT], -3, ["mission\weapon_menuDef.sqf", ["main"]]]
// Note: calling script may require this file for dik codes: #include "\x\cba\addons\ui_helper\script_dikCodes.hpp"

_msg = "FLEXIMENU: Unknown Error in fnc_add.sqf"; //Initialize
_key = [];

// validate params
_msg = format ["Error: invalid params. %1 (%2)", _this, __FILE__];

if (isNil "_msg") then  {_msg = "FLEXIMENU: Unknown Error in fnc_add.sqf"};
if (isNil QUOTE(GVAR(typeMenuSources))) exitWith {diag_log "Error: TypeMenuSources invalid"};
if (typeName _this != typeName []) exitWith {diag_log _msg};
if (count _this < 4 || {count _this > 5}) exitWith {diag_log "Error: Too few or too many arguments"};
if !(toLower typeName (_this select _flexiMenu_typeMenuSources_ID_type) in [toLower typeName "", toLower typeName []]) exitWith {diag_log _msg};
if (typeName (_this select _flexiMenu_typeMenuSources_ID_DIKCodes) != typeName []) exitWith {diag_log _msg};
if (typeName (_this select _flexiMenu_typeMenuSources_ID_priority) != typeName 2) exitWith {diag_log _msg};
if !(typeName (_this select _flexiMenu_typeMenuSources_ID_menuSource) in [typeName [], typeName ""]) exitWith {diag_log _msg};

// common bug: invalid DIK code (type any) when missing #include "dikCodes.h"
//TODO: still not detecting nil?
// if (({isNil "_x"} count (_this select _flexiMenu_typeMenuSources_ID_DIKCodes)) > 0) exitWith {diag_log _msg};

if (count _this == 4) then {_this pushBack true};

// convert any single key items (eg: DIK_A) into a key array [key, [shift, ctrl, alt]]
if (count (_this select _flexiMenu_typeMenuSources_ID_DIKCodes) != 0) then {
    for "_i" from 0 to (count (_this select _flexiMenu_typeMenuSources_ID_DIKCodes) - 1) do {
        _key = (_this select _flexiMenu_typeMenuSources_ID_DIKCodes) select _i;
        // if not an already an array (eg: simple DIK integer)
        if (typeName _key != typeName []) then {
            _key = [_key, [false, false, false]];
            (_this select _flexiMenu_typeMenuSources_ID_DIKCodes) set [_i, _key];
        };
    };
};

TRACE_2("",_key,_flexiMenu_typeMenuSources_ID_DIKCodes);

// Check for duplicate record and then warn and ignore.
if (count (_this select _flexiMenu_typeMenuSources_ID_DIKCodes) != 0) then {
    if (({str _x == str _this} count (_this select _flexiMenu_typeMenuSources_ID_DIKCodes)) > 0) exitWith {
        diag_log format ["Warning: duplicate record, ignoring. %1 (%2)", _this, __FILE__];
    };
};

GVAR(typeMenuSources) pushBack _this;
[GVAR(typeMenuSources), _flexiMenu_typeMenuSources_ID_priority] call CBA_fnc_sortNestedArray;

// reverse the order of sorting, so highest priority is at the top
_list = [];
for "_e" from (count GVAR(typeMenuSources) - 1) to 0 step -1 do {
    _list pushBack (GVAR(typeMenuSources) select _e);
};

GVAR(typeMenuSources) = _list;
