/* ----------------------------------------------------------------------------
Function: CBA_fnc_vectCross

Description:
   Returns the cross product vector of two vectors.

   Vectors must both be three dimensional.

   DEPRECATED - Please use <vectorCrossProduct at https://community.bistudio.com/wiki/vectorCrossProduct>

Parameters:
    _u the first vector.
    _v the second vector.

Returns:
    The cross product (vector) of the two vectors.

Examples:
    (begin example)

    (end)

Author:
    Vigilante, courtesy by -=ACE=- of Simcentric,
---------------------------------------------------------------------------- */

#include "script_component.hpp"
SCRIPT(vectCross2D);

params ["_u","_v"];
_u vectorCrossProduct _v;
