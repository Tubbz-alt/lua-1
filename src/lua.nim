#*****************************************************************************
# *                                                                            *
# *  File:        lua.pas                                                      *
# *  Authors:     TeCGraf           (C headers + actual Lua libraries)         *
# *               Lavergne Thomas   (original translation to Pascal)           *
# *               Bram Kuijvenhoven (update to Lua 5.1.1 for FreePascal)       *
# *  Description: Basic Lua library                                            *
# *                                                                            *
# *****************************************************************************
#
#** $Id: lua.h,v 1.175 2003/03/18 12:31:39 roberto Exp $
#** Lua - An Extensible Extension Language
#** TeCGraf: Computer Graphics Technology Group, PUC-Rio, Brazil
#** http://www.lua.org   mailto:info@lua.org
#** See Copyright Notice at the end of this file
#
#
#** Updated to Lua 5.1.1 by Bram Kuijvenhoven (bram at kuijvenhoven dot net),
#**   Hexis BV (http://www.hexis.nl), the Netherlands
#** Notes:
#**    - Only tested with FPC (FreePascal Compiler)
#**    - Using LuaBinaries styled DLL/SO names, which include version names
#**    - LUA_YIELD was suffixed by '_' for avoiding name collision
#
#
#** Translated to pascal by Lavergne Thomas
#** Notes :
#**    - Pointers type was prefixed with 'P'
#**    - lua_upvalueindex constant was transformed to function
#**    - Some compatibility function was isolated because with it you must have
#**      lualib.
#**    - LUA_VERSION was suffixed by '_' for avoiding name collision.
#** Bug reports :
#**    - thomas.lavergne@laposte.net
#**   In french or in english
#

when defined(useLuajit):
  when defined(MACOSX):
    const
      NAME* = "libluajit.dylib"
      LIB_NAME* = "libluajit.dylib"
  elif defined(UNIX):
    const
      NAME* = "libluajit.so(|.0)"
      LIB_NAME* = "libluajit.so(|.0)"
  else:
    const
      NAME* = "luajit.dll"
      LIB_NAME* = "luajit.dll"
else:
  when defined(MACOSX):
    const
      NAME* = "liblua(|5.1|5.0).dylib"
      LIB_NAME* = "liblua(|5.1|5.0).dylib"
  elif defined(UNIX):
    const
      NAME* = "liblua(|5.1|5.0).so(|.0)"
      LIB_NAME* = "liblua(|5.1|5.0).so(|.0)"
  else:
    const 
      NAME* = "lua(|5.1|5.0).dll"
      LIB_NAME* = "lua(|5.1|5.0).dll"

const 
  VERSION* = "Lua 5.1"
  RELEASE* = "Lua 5.1.1"
  VERSION_NUM* = 501
  COPYRIGHT* = "Copyright (C) 1994-2006 Lua.org, PUC-Rio"
  AUTHORS* = "R. Ierusalimschy, L. H. de Figueiredo & W. Celes"
  # option for multiple returns in `lua_pcall' and `lua_call' 
  MULTRET* = - 1              #
                              #** pseudo-indices
                              #
  REGISTRYINDEX* = - 10000
  ENVIRONINDEX* = - 10001
  GLOBALSINDEX* = - 10002

proc upvalueindex*(I: cint): cint
const                         # thread status; 0 is OK 
  constYIELD* = 1
  ERRRUN* = 2
  ERRSYNTAX* = 3
  ERRMEM* = 4
  ERRERR* = 5

type 
  PState* = Pointer
  CFunction* = proc (L: PState): cint{.cdecl.}

#
#** functions that read/write blocks when loading/dumping Lua chunks
#

type 
  Reader* = proc (L: PState, ud: Pointer, sz: ptr cint): cstring{.cdecl.}
  Writer* = proc (L: PState, p: Pointer, sz: cint, ud: Pointer): cint{.cdecl.}
  Alloc* = proc (ud, theptr: Pointer, osize, nsize: cint){.cdecl.}

const 
  TNONE* = - 1
  TNIL* = 0
  TBOOLEAN* = 1
  TLIGHTUSERDATA* = 2
  TNUMBER* = 3
  TSTRING* = 4
  TTABLE* = 5
  TFUNCTION* = 6
  TUSERDATA* = 7
  TTHREAD* = 8                # minimum Lua stack available to a C function 
  MINSTACK* = 20

type                          # Type of Numbers in Lua 
  Number* = float
  Integer* = cint

{.pragma: ilua, importc: "lua_$1".}

{.push callConv: cdecl, dynlib: LibName.}
#{.push importc: "lua_$1".}

proc newstate*(f: Alloc, ud: Pointer): PState {.ilua.}

proc close*(L: PState){.ilua.}
proc newthread*(L: PState): PState{.ilua.}
proc atpanic*(L: PState, panicf: CFunction): CFunction{.ilua.}

proc gettop*(L: PState): cint{.ilua.}
proc settop*(L: PState, idx: cint){.ilua.}
proc pushvalue*(L: PState, Idx: cint){.ilua.}
proc remove*(L: PState, idx: cint){.ilua.}
proc insert*(L: PState, idx: cint){.ilua.}
proc replace*(L: PState, idx: cint){.ilua.}
proc checkstack*(L: PState, sz: cint): cint{.ilua.}
proc xmove*(`from`, `to`: PState, n: cint){.ilua.}
proc isnumber*(L: PState, idx: cint): cint{.ilua.}
proc isstring*(L: PState, idx: cint): cint{.ilua.}
proc iscfunction*(L: PState, idx: cint): cint{.ilua.}
proc isuserdata*(L: PState, idx: cint): cint{.ilua.}
proc luatype*(L: PState, idx: cint): cint{.importc: "lua_type".}
proc typename*(L: PState, tp: cint): cstring{.ilua.}
proc equal*(L: PState, idx1, idx2: cint): cint{.ilua.}
proc rawequal*(L: PState, idx1, idx2: cint): cint{.ilua.}
proc lessthan*(L: PState, idx1, idx2: cint): cint{.ilua.}
proc tonumber*(L: PState, idx: cint): Number{.ilua.}
proc tointeger*(L: PState, idx: cint): Integer{.ilua.}
proc toboolean*(L: PState, idx: cint): cint{.ilua.}
proc tolstring*(L: PState, idx: cint, length: ptr cint): cstring{.ilua.}
proc objlen*(L: PState, idx: cint): cint{.ilua.}
proc tocfunction*(L: PState, idx: cint): CFunction{.ilua.}
proc touserdata*(L: PState, idx: cint): Pointer{.ilua.}
proc tothread*(L: PState, idx: cint): PState{.ilua.}
proc topointer*(L: PState, idx: cint): Pointer{.ilua.}
proc pushnil*(L: PState){.ilua.}
proc pushnumber*(L: PState, n: Number){.ilua.}
proc pushinteger*(L: PState, n: Integer){.ilua.}
proc pushlstring*(L: PState, s: cstring, len: cint){.ilua.}
proc pushstring*(L: PState, s: cstring){.ilua.}
proc pushvfstring*(L: PState, fmt: cstring, argp: Pointer): cstring{.ilua.}
proc pushfstring*(L: PState, fmt: cstring): cstring{.varargs,ilua.}
proc pushcclosure*(L: PState, fn: CFunction, n: cint){.ilua.}
proc pushboolean*(L: PState, b: cint){.ilua.}
proc pushlightuserdata*(L: PState, p: Pointer){.ilua.}
proc pushthread*(L: PState){.ilua.}
proc gettable*(L: PState, idx: cint){.ilua.}
proc getfield*(L: Pstate, idx: cint, k: cstring){.ilua.}
proc rawget*(L: PState, idx: cint){.ilua.}
proc rawgeti*(L: PState, idx, n: cint){.ilua.}
proc createtable*(L: PState, narr, nrec: cint){.ilua.}
proc newuserdata*(L: PState, sz: cint): Pointer{.ilua.}
proc getmetatable*(L: PState, objindex: cint): cint{.ilua.}
proc getfenv*(L: PState, idx: cint){.ilua.}
proc settable*(L: PState, idx: cint){.ilua.}
proc setfield*(L: PState, idx: cint, k: cstring){.ilua.}
proc rawset*(L: PState, idx: cint){.ilua.}
proc rawseti*(L: PState, idx, n: cint){.ilua.}
proc setmetatable*(L: PState, objindex: cint): cint{.ilua.}
proc setfenv*(L: PState, idx: cint): cint{.ilua.}
proc call*(L: PState, nargs, nresults: cint){.ilua.}
proc pcall*(L: PState, nargs, nresults, errf: cint): cint{.ilua.}
proc cpcall*(L: PState, func: CFunction, ud: Pointer): cint{.ilua.}
proc load*(L: PState, reader: Reader, dt: Pointer, chunkname: cstring): cint{.ilua.}
proc dump*(L: PState, writer: Writer, data: Pointer): cint{.ilua.}
proc luayield*(L: PState, nresults: cint): cint{.importc: "lua_yield".}
proc resume*(L: PState, narg: cint): cint{.ilua.}
proc status*(L: PState): cint{.ilua.}
proc gc*(L: PState, what, data: cint): cint{.ilua.}
proc error*(L: PState): cint{.ilua.}
proc next*(L: PState, idx: cint): cint{.ilua.}
proc concat*(L: PState, n: cint){.ilua.}
proc getallocf*(L: PState, ud: ptr Pointer): Alloc{.ilua.}
proc setallocf*(L: PState, f: Alloc, ud: Pointer){.ilua.}
{.pop.}

#
#** Garbage-collection functions and options
#

const 
  GCSTOP* = 0
  GCRESTART* = 1
  GCCOLLECT* = 2
  GCCOUNT* = 3
  GCCOUNTB* = 4
  GCSTEP* = 5
  GCSETPAUSE* = 6
  GCSETSTEPMUL* = 7

#
#** ===============================================================
#** some useful macros
#** ===============================================================
#

proc pop*(L: PState, n: cint)
proc newtable*(L: Pstate)
proc register*(L: PState, n: cstring, f: CFunction)
proc pushcfunction*(L: PState, f: CFunction)
proc strlen*(L: Pstate, i: cint): cint
proc isfunction*(L: PState, n: cint): bool
proc istable*(L: PState, n: cint): bool
proc islightuserdata*(L: PState, n: cint): bool
proc isnil*(L: PState, n: cint): bool
proc isboolean*(L: PState, n: cint): bool
proc isthread*(L: PState, n: cint): bool
proc isnone*(L: PState, n: cint): bool
proc isnoneornil*(L: PState, n: cint): bool
proc pushliteral*(L: PState, s: cstring)
proc setglobal*(L: PState, s: cstring)
proc getglobal*(L: PState, s: cstring)
proc tostring*(L: PState, i: cint): cstring
#
#** compatibility macros and functions
#

proc getregistry*(L: PState)
proc getgccount*(L: PState): cint
type 
  Chunkreader* = Reader
  Chunkwriter* = Writer

#
#** ======================================================================
#** Debug API
#** ======================================================================
#

const 
  HOOKCALL* = 0
  HOOKRET* = 1
  HOOKLINE* = 2
  HOOKCOUNT* = 3
  HOOKTAILRET* = 4

const 
  MASKCALL* = 1 shl Ord(HOOKCALL)
  MASKRET* = 1 shl Ord(HOOKRET)
  MASKLINE* = 1 shl Ord(HOOKLINE)
  MASKCOUNT* = 1 shl Ord(HOOKCOUNT)

const 
  IDSIZE* = 60

type 
  TDebug*{.final.} = object    # activation record 
    event*: cint
    name*: cstring            # (n) 
    namewhat*: cstring        # (n) `global', `local', `field', `method' 
    what*: cstring            # (S) `Lua', `C', `main', `tail'
    source*: cstring          # (S) 
    currentline*: cint         # (l) 
    nups*: cint                # (u) number of upvalues 
    linedefined*: cint         # (S) 
    lastlinedefined*: cint     # (S) 
    short_src*: array[0.. <IDSIZE, Char] # (S) \ 
                               # private part 
    i_ci*: cint                # active function 
  
  PDebug* = ptr TDebug
  Hook* = proc (L: PState, ar: PDebug){.cdecl.}

#
#** ======================================================================
#** Debug API
#** ======================================================================
#

{.push callConv: cdecl, dynlib: lua.LIB_NAME.}

proc getstack*(L: PState, level: cint, ar: PDebug): cint{.ilua.}
proc getinfo*(L: PState, what: cstring, ar: PDebug): cint{.ilua.}
proc getlocal*(L: PState, ar: PDebug, n: cint): cstring{.ilua.}
proc setlocal*(L: PState, ar: PDebug, n: cint): cstring{.ilua.}
proc getupvalue*(L: PState, funcindex: cint, n: cint): cstring{.ilua.}
proc setupvalue*(L: PState, funcindex: cint, n: cint): cstring{.ilua.}
proc sethook*(L: PState, func: Hook, mask: cint, count: cint): cint{.ilua.}
proc gethook*(L: PState): Hook{.ilua.}
proc gethookmask*(L: PState): cint{.ilua.}
proc gethookcount*(L: PState): cint{.ilua.}

{.pop.}

# implementation

proc upvalueindex(I: cint): cint = 
  Result = GLOBALSINDEX - i

proc pop(L: PState, n: cint) = 
  settop(L, - n - 1)

proc newtable(L: PState) = 
  createtable(L, 0, 0)

proc register(L: PState, n: cstring, f: CFunction) = 
  pushcfunction(L, f)
  setglobal(L, n)

proc pushcfunction(L: PState, f: CFunction) = 
  pushcclosure(L, f, 0)

proc strlen(L: PState, i: cint): cint = 
  Result = objlen(L, i)

proc isfunction(L: PState, n: cint): bool = 
  Result = luatype(L, n) == TFUNCTION

proc istable(L: PState, n: cint): bool = 
  Result = luatype(L, n) == TTABLE

proc islightuserdata(L: PState, n: cint): bool = 
  Result = luatype(L, n) == TLIGHTUSERDATA

proc isnil(L: PState, n: cint): bool = 
  Result = luatype(L, n) == TNIL

proc isboolean(L: PState, n: cint): bool = 
  Result = luatype(L, n) == TBOOLEAN

proc isthread(L: PState, n: cint): bool = 
  Result = luatype(L, n) == TTHREAD

proc isnone(L: PState, n: cint): bool = 
  Result = luatype(L, n) == TNONE

proc isnoneornil(L: PState, n: cint): bool = 
  Result = luatype(L, n) <= 0

proc pushliteral(L: PState, s: cstring) = 
  pushlstring(L, s, s.len.cint)

proc setglobal(L: PState, s: cstring) = 
  setfield(L, GLOBALSINDEX, s)

proc getglobal(L: PState, s: cstring) = 
  getfield(L, GLOBALSINDEX, s)

proc tostring(L: PState, i: cint): cstring = 
  Result = tolstring(L, i, nil)

proc getregistry(L: PState) = 
  pushvalue(L, REGISTRYINDEX)

proc getgccount(L: PState): cint = 
  Result = gc(L, GCCOUNT, 0)


## -- lualib
#*****************************************************************************
# *                                                                            *
# *  File:        lualib.pas                                                   *
# *  Authors:     TeCGraf           (C headers + actual Lua libraries)         *
# *               Lavergne Thomas   (original translation to Pascal)           *
# *               Bram Kuijvenhoven (update to Lua 5.1.1 for FreePascal)       *
# *  Description: Standard Lua libraries                                       *
# *                                                                            *
# *****************************************************************************
#
#** $Id: lualib.h,v 1.28 2003/03/18 12:24:26 roberto Exp $
#** Lua standard libraries
#** See Copyright Notice in lua.h
#
#
#** Translated to pascal by Lavergne Thomas
#** Bug reports :
#**    - thomas.lavergne@laposte.net
#**   In french or in english
#

const 
  COLIBNAME* = "coroutine"
  TABLIBNAME* = "table"
  IOLIBNAME* = "io"
  OSLIBNAME* = "os"
  STRLINAME* = "string"
  MATHLIBNAME* = "math"
  DBLIBNAME* = "debug"
  LOADLIBNAME* = "package"

{.pragma: ilualib, importc: "lua$1".}

{.push callConv: cdecl, dynlib: lua.LIB_NAME.}
proc open_base*(L: PState): cint{.ilualib.}
proc open_table*(L: PState): cint{.ilualib.}
proc open_io*(L: PState): cint{.ilualib.}
proc open_string*(L: PState): cint{.ilualib.}
proc open_math*(L: PState): cint{.ilualib.}
proc open_debug*(L: PState): cint{.ilualib.}
proc open_package*(L: PState): cint{.ilualib.}
proc openlibs*(L: PState){.importc: "luaL_openlibs".}
{.pop.}

proc baselibopen*(L: PState): Bool = 
  open_base(L) != 0'i32

proc tablibopen*(L: PState): Bool = 
  open_table(L) != 0'i32

proc iolibopen*(L: PState): Bool = 
  open_io(L) != 0'i32

proc strlibopen*(L: PState): Bool = 
  open_string(L) != 0'i32

proc mathlibopen*(L: PState): Bool = 
  open_math(L) != 0'i32

proc dblibopen*(L: PState): Bool = 
  open_debug(L) != 0'i32



## -- lauxlib
#*****************************************************************************
# *                                                                            *
# *  File:        lauxlib.pas                                                  *
# *  Authors:     TeCGraf           (C headers + actual Lua libraries)         *
# *               Lavergne Thomas   (original translation to Pascal)           *
# *               Bram Kuijvenhoven (update to Lua 5.1.1 for FreePascal)       *
# *  Description: Lua auxiliary library                                        *
# *                                                                            *
# *****************************************************************************
#
#** $Id: lauxlib.h,v 1.59 2003/03/18 12:25:32 roberto Exp $
#** Auxiliary functions for building Lua libraries
#** See Copyright Notice in lua.h
#
#
#** Translated to pascal by Lavergne Thomas
#** Notes :
#**    - Pointers type was prefixed with 'P'
#** Bug reports :
#**    - thomas.lavergne@laposte.net
#**   In french or in english
#

proc pushstring*(L: PState, s: string)
  # compatibilty macros
proc getn*(L: PState, n: cint): cint
  # calls lua_objlen
proc setn*(L: PState, t, n: cint)
  # does nothing!
type 
  Treg*{.final.} = object 
    name*: cstring
    func*: CFunction

  Preg* = ptr Treg


{.push callConv: cdecl, dynlib: lua.LIB_NAME.}
{.push importc: "luaL_$1".}

proc openlib*(L: PState, libname: cstring, lr: Preg, nup: cint)
proc register*(L: PState, libname: cstring, lr: Preg)

proc getmetafield*(L: PState, obj: cint, e: cstring): cint
proc callmeta*(L: PState, obj: cint, e: cstring): cint
proc typerror*(L: PState, narg: cint, tname: cstring): cint
proc argerror*(L: PState, numarg: cint, extramsg: cstring): cint
proc checklstring*(L: PState, numArg: cint, len: ptr int): cstring
proc optlstring*(L: PState, numArg: cint, def: cstring, len: ptr cint): cstring
proc checknumber*(L: PState, numArg: cint): Number
proc optnumber*(L: PState, nArg: cint, def: Number): Number
proc checkinteger*(L: PState, numArg: cint): Integer
proc optinteger*(L: PState, nArg: cint, def: Integer): Integer
proc checkstack*(L: PState, sz: cint, msg: cstring)
proc checktype*(L: PState, narg, t: cint)

proc checkany*(L: PState, narg: cint)
proc newmetatable*(L: PState, tname: cstring): cint

proc checkudata*(L: PState, ud: cint, tname: cstring): Pointer
proc where*(L: PState, lvl: cint)
proc error*(L: PState, fmt: cstring): cint{.varargs.}
proc checkoption*(L: PState, narg: cint, def: cstring, lst: cstringArray): cint

proc unref*(L: PState, t, theref: cint)
proc loadfile*(L: PState, filename: cstring): cint
proc loadbuffer*(L: PState, buff: cstring, size: cint, name: cstring): cint
proc loadstring*(L: PState, s: cstring): cint
proc newstate*(): PState

{.pop.}
proc reference*(L: PState, t: cint): cint{.importc: "luaL_ref".}

{.pop.}

proc open*(): PState
  # compatibility; moved from unit lua to lauxlib because it needs luaL_newstate
  #
  #** ===============================================================
  #** some useful macros
  #** ===============================================================
  #
proc argcheck*(L: PState, cond: bool, numarg: cint, extramsg: cstring)
proc checkstring*(L: PState, n: cint): cstring
proc optstring*(L: PState, n: cint, d: cstring): cstring
proc checkint*(L: PState, n: cint): cint
proc checklong*(L: PState, n: cint): clong
proc optint*(L: PState, n: cint, d: float64): cint
proc optlong*(L: PState, n: cint, d: float64): clong
proc dofile*(L: PState, filename: cstring): cint
proc dostring*(L: PState, str: cstring): cint
proc getmetatable*(L: PState, tname: cstring)
  # not translated:
  # #define luaL_opt(L,f,n,d)  (lua_isnoneornil(L,(n)) ? (d) : f(L,(n)))
  #
  #** =======================================================
  #** Generic Buffer manipulation
  #** =======================================================
  #
const                         # note: this is just arbitrary, as it related to the BUFSIZ defined in stdio.h ...
  BUFFERSIZE* = 4096

type 
  Buffer*{.final.} = object 
    p*: cstring               # current position in buffer 
    lvl*: cint                 # number of strings in the stack (level) 
    L*: PState
    buffer*: array[0..BUFFERSIZE - 1, Char] # warning: see note above about LUAL_BUFFERSIZE
  
  PBuffer* = ptr Buffer

proc addchar*(B: PBuffer, c: Char)
  # warning: see note above about LUAL_BUFFERSIZE
  # compatibility only (alias for luaL_addchar) 
proc putchar*(B: PBuffer, c: Char)
  # warning: see note above about LUAL_BUFFERSIZE
proc addsize*(B: PBuffer, n: cint)

{.push callConv: cdecl, dynlib: lua.LIB_NAME, importc: "luaL_$1".}
proc buffinit*(L: PState, B: PBuffer)
proc prepbuffer*(B: PBuffer): cstring
proc addlstring*(B: PBuffer, s: cstring, L: cint)
proc addstring*(B: PBuffer, s: cstring)
proc addvalue*(B: PBuffer)
proc pushresult*(B: PBuffer)
proc gsub*(L: PState, s, p, r: cstring): cstring
proc findtable*(L: PState, idx: cint, fname: cstring, szhint: cint): cstring
  # compatibility with ref system 
  # pre-defined references 
{.pop.}

const 
  NOREF* = - 2
  REFNIL* = - 1

proc unref*(L: PState, theref: cint)
proc getref*(L: PState, theref: cint)
  #
  #** Compatibility macros and functions
  #
# implementation

proc pushstring(L: PState, s: string) = 
  pushlstring(L, cstring(s), s.len.cint)

proc getn(L: PState, n: cint): cint = 
  Result = objlen(L, n)

proc setn(L: PState, t, n: cint) = 
  # does nothing as this operation is deprecated
  nil

proc open(): PState = 
  Result = newstate()

proc dofile(L: PState, filename: cstring): cint = 
  Result = loadfile(L, filename)
  if Result == 0: Result = pcall(L, 0, MULTRET, 0)
  
proc dostring(L: PState, str: cstring): cint = 
  Result = loadstring(L, str)
  if Result == 0: Result = pcall(L, 0, MULTRET, 0)
  
proc getmetatable(L: PState, tname: cstring) = 
  getfield(L, REGISTRYINDEX, tname)

proc argcheck(L: PState, cond: bool, numarg: cint, extramsg: cstring) = 
  if not cond: 
    discard argerror(L, numarg, extramsg)

proc checkstring(L: PState, n: cint): cstring = 
  Result = checklstring(L, n, nil)

proc optstring(L: PState, n: cint, d: cstring): cstring = 
  Result = optlstring(L, n, d, nil)

proc checkint(L: PState, n: cint): cint = 
  Result = cint(checknumber(L, n))

proc checklong(L: PState, n: cint): clong = 
  Result = int32(ToInt(checknumber(L, n)))

proc optint(L: PState, n: cint, d: float64): cint = 
  Result = optnumber(L, n, d).cint

proc optlong(L: PState, n: cint, d: float64): clong = 
  Result = int32(ToInt(optnumber(L, n, d)))

proc addchar(B: PBuffer, c: Char) = 
  if cast[int](addr((B.p))) < (cast[int](addr((B.buffer[0]))) + BUFFERSIZE): 
    discard prepbuffer(B)
  B.p[1] = c
  B.p = cast[cstring](cast[int](B.p) + 1)

proc putchar(B: PBuffer, c: Char) = 
  addchar(B, c)

proc addsize(B: PBuffer, n: cint) = 
  B.p = cast[cstring](cast[int](B.p) + n)

proc unref(L: PState, theref: cint) = 
  unref(L, REGISTRYINDEX, theref)

proc getref(L: PState, theref: cint) = 
  rawgeti(L, REGISTRYINDEX, theref)


