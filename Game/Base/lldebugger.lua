
local ____modules = {}
local ____moduleCache = {}
local ____originalRequire = require
local function require(file)
    if ____moduleCache[file] then
        return ____moduleCache[file]
    end
    if ____modules[file] then
        ____moduleCache[file] = ____modules[file]()
        return ____moduleCache[file]
    else
        if ____originalRequire then
            return ____originalRequire(file)
        else
            error("module '" .. file .. "' not found")
        end
    end
end
____modules = {
["path"] = function() local ____exports = {}
____exports.Path = {}
local Path = ____exports.Path
do
    Path.separator = (function()
        local config = _G.package.config
        if config then
            local sep = config:match("^[^\n]+")
            if sep then
                return sep
            end
        end
        return "/"
    end)()
    local cwd
    function Path.getCwd()
        if not cwd then
            local p = io.popen(((Path.separator == "\\") and "cd") or "pwd")
            if p then
                cwd = p:read("*a"):match("^%s*(.-)%s*$")
            end
            cwd = cwd or ""
        end
        return cwd
    end
    function Path.dirName(path)
        local dir = path:match(
            ((("^(.-)" .. tostring(Path.separator)) .. "+[^") .. tostring(Path.separator)) .. "]+$"
        )
        return dir or ""
    end
    function Path.splitDrive(path)
        local drive, pathPart = path:match("^[@=]?([a-zA-Z]:)[\\/](.*)")
        if drive then
            drive = tostring(
                drive:upper()
            ) .. tostring(Path.separator)
        else
            drive, pathPart = path:match("^[@=]?([\\/]*)(.*)")
        end
        return assert(drive), assert(pathPart)
    end
    local formattedPathCache = {}
    function Path.format(path)
        local formattedPath = formattedPathCache[path]
        if not formattedPath then
            local drive, pathOnly = Path.splitDrive(path)
            local pathParts = {}
            for part in assert(pathOnly):gmatch("[^\\/]+") do
                if part ~= "." then
                    if ((part == "..") and (#pathParts > 0)) and (pathParts[#pathParts] ~= "..") then
                        table.remove(pathParts)
                    else
                        table.insert(pathParts, part)
                    end
                end
            end
            formattedPath = tostring(drive) .. tostring(
                table.concat(pathParts, Path.separator)
            )
            formattedPathCache[path] = formattedPath
        end
        return formattedPath
    end
    function Path.isAbsolute(path)
        local drive = Path.splitDrive(path)
        return #drive > 0
    end
    function Path.getAbsolute(path)
        if Path.isAbsolute(path) then
            return Path.format(path)
        end
        return Path.format(
            (tostring(
                Path.getCwd()
            ) .. tostring(Path.separator)) .. tostring(path)
        )
    end
end
return ____exports
end,
["breakpoint"] = function() local ____exports = {}
local ____path = require("path")
local Path = ____path.Path
____exports.Breakpoint = {}
local Breakpoint = ____exports.Breakpoint
do
    local current = {}
    function Breakpoint.get(file, line)
        file = Path.format(file)
        for _, breakpoint in ipairs(current) do
            if (breakpoint.file == file) and (breakpoint.line == line) then
                return breakpoint
            end
        end
        return nil
    end
    function Breakpoint.getAll()
        return current
    end
    function Breakpoint.add(file, line, condition)
        table.insert(
            current,
            {
                file = Path.format(file),
                line = line,
                enabled = true,
                condition = condition
            }
        )
    end
    function Breakpoint.remove(file, line)
        file = Path.format(file)
        for i, breakpoint in ipairs(current) do
            if (breakpoint.file == file) and (breakpoint.line == line) then
                table.remove(current, i)
                break
            end
        end
    end
    function Breakpoint.clear()
        current = {}
    end
end
return ____exports
end,
["sourcemap"] = function() local ____exports = {}
local ____path = require("path")
local Path = ____path.Path
____exports.SourceMap = {}
local SourceMap = ____exports.SourceMap
do
    local cache = {}
    local base64Lookup = {A = 0, B = 1, C = 2, D = 3, E = 4, F = 5, G = 6, H = 7, I = 8, J = 9, K = 10, L = 11, M = 12, N = 13, O = 14, P = 15, Q = 16, R = 17, S = 18, T = 19, U = 20, V = 21, W = 22, X = 23, Y = 24, Z = 25, a = 26, b = 27, c = 28, d = 29, e = 30, f = 31, g = 32, h = 33, i = 34, j = 35, k = 36, l = 37, m = 38, n = 39, o = 40, p = 41, q = 42, r = 43, s = 44, t = 45, u = 46, v = 47, w = 48, x = 49, y = 50, z = 51, ["0"] = 52, ["1"] = 53, ["2"] = 54, ["3"] = 55, ["4"] = 56, ["5"] = 57, ["6"] = 58, ["7"] = 59, ["8"] = 60, ["9"] = 61, ["+"] = 62, ["/"] = 63, ["="] = 0}
    local function base64Decode(input)
        local results = {}
        local bits = {}
        for c in input:gmatch(".") do
            local sextet = assert(base64Lookup[c])
            for i = 1, 6 do
                local bit = (sextet % 2) ~= 0
                table.insert(bits, i, bit)
                sextet = math.floor(sextet / 2)
            end
            if #bits >= 8 then
                local value = 0
                for i = 7, 0, -1 do
                    local bit = table.remove(bits)
                    if bit then
                        value = value + (2 ^ i)
                    end
                end
                table.insert(
                    results,
                    string.char(value)
                )
            end
        end
        return table.concat(results)
    end
    local function decodeBase64VLQ(input)
        local values = {}
        local bits = {}
        for c in input:gmatch(".") do
            local sextet = assert(base64Lookup[c])
            for _ = 1, 5 do
                local bit = (sextet % 2) ~= 0
                table.insert(bits, bit)
                sextet = math.floor(sextet / 2)
            end
            local continueBit = (sextet % 2) ~= 0
            if not continueBit then
                local value = 0
                for i = 1, #bits - 1 do
                    if bits[i + 1] then
                        value = value + (2 ^ (i - 1))
                    end
                end
                if bits[1] then
                    value = -value
                end
                table.insert(values, value)
                bits = {}
            end
        end
        return values
    end
    local function build(data, mapDir)
        local sources = data:match("\"sources\"%s*:%s*(%b[])")
        local mappings = data:match("\"mappings\"%s*:%s*\"([^\"]+)\"")
        local sourceRoot = data:match("\"sourceRoot\"%s*:%s*\"([^\"]+)\"")
        if (not mappings) or (not sources) then
            return nil
        end
        local sourceMap = {sources = {}}
        if (sourceRoot == nil) or (#sourceRoot == 0) then
            sourceRoot = "."
        end
        for source in sources:gmatch("\"([^\"]+)\"") do
            local sourcePath = (((tostring(mapDir) .. tostring(Path.separator)) .. tostring(sourceRoot)) .. tostring(Path.separator)) .. tostring(source)
            table.insert(
                sourceMap.sources,
                Path.getAbsolute(sourcePath)
            )
        end
        local line = 1
        local sourceIndex = 0
        local sourceLine = 1
        local sourceColumn = 1
        for mapping, separator in mappings:gmatch("([^;,]*)([;,]?)") do
            if #mapping > 0 then
                local colOffset, sourceOffset, sourceLineOffset, sourceColOffset = unpack(
                    decodeBase64VLQ(mapping)
                )
                sourceIndex = sourceIndex + (sourceOffset or 0)
                sourceLine = sourceLine + (sourceLineOffset or 0)
                sourceColumn = sourceColumn + (sourceColOffset or 0)
                local lineMapping = sourceMap[line]
                if ((not lineMapping) or (sourceLine < lineMapping.sourceLine)) or ((sourceLine == lineMapping.sourceLine) and (sourceColumn < lineMapping.sourceColumn)) then
                    sourceMap[line] = {sourceIndex = sourceIndex, sourceLine = sourceLine, sourceColumn = sourceColumn}
                end
            end
            if separator == ";" then
                line = line + 1
            end
        end
        return sourceMap
    end
    function SourceMap.get(file)
        if file == "[C]" then
            return nil
        end
        local sourceMap = cache[file]
        if sourceMap == nil then
            sourceMap = false
            local mapDir = Path.dirName(file)
            local mapFile = tostring(file) .. ".map"
            local f = io.open(mapFile)
            if f then
                local data = f:read("*a")
                f:close()
                sourceMap = build(data, mapDir) or false
            else
                f = io.open(file)
                if f then
                    local data = f:read("*a")
                    f:close()
                    local encodedMap = data:match("--# sourceMappingURL=data:application/json;base64,([A-Za-z0-9+/=]+)%s*$")
                    if encodedMap then
                        local map = base64Decode(encodedMap)
                        sourceMap = build(map, mapDir) or false
                    end
                end
            end
            cache[file] = sourceMap
        end
        return sourceMap or nil
    end
end
return ____exports
end,
["format"] = function() local ____exports = {}
____exports.Format = {}
local Format = ____exports.Format
do
    Format.arrayTag = {}
    function Format.makeExplicitArray(arr)
        if arr == nil then
            arr = {}
        end
        arr[Format.arrayTag] = true
        return arr
    end
    local indentStr = "  "
    local escapes = {["\n"] = "\\n", ["\r"] = "\\r", ["\""] = "\\\"", ["\\"] = "\\\\", ["\b"] = "\\b", ["\f"] = "\\f", ["\t"] = "\\t"}
    local escapesPattern = ""
    for e in pairs(escapes) do
        escapesPattern = tostring(escapesPattern) .. tostring(e)
    end
    escapesPattern = ("[" .. tostring(escapesPattern)) .. "]"
    local function escape(str)
        local escaped = str:gsub(escapesPattern, escapes)
        return escaped
    end
    local function isArray(val)
        if val[Format.arrayTag] then
            return true
        end
        local len = #val
        if len == 0 then
            return false
        end
        for k in pairs(val) do
            if (type(k) ~= "number") or (k > len) then
                return false
            end
        end
        return true
    end
    function Format.asJson(val, indent, tables)
        if indent == nil then
            indent = 0
        end
        tables = tables or ({})
        local valType = type(val)
        if (valType == "table") and (not tables[val]) then
            tables[val] = true
            if isArray(val) then
                local arrayVals = {}
                for _, arrayVal in ipairs(val) do
                    local valStr = Format.asJson(arrayVal, indent + 1, tables)
                    table.insert(
                        arrayVals,
                        ("\n" .. tostring(
                            indentStr:rep(indent + 1)
                        )) .. tostring(valStr)
                    )
                end
                return ((("[" .. tostring(
                    table.concat(arrayVals, ",")
                )) .. "\n") .. tostring(
                    indentStr:rep(indent)
                )) .. "]"
            else
                local kvps = {}
                for k, v in pairs(val) do
                    local valStr = Format.asJson(v, indent + 1, tables)
                    table.insert(
                        kvps,
                        (((("\n" .. tostring(
                            indentStr:rep(indent + 1)
                        )) .. "\"") .. tostring(
                            escape(
                                tostring(k)
                            )
                        )) .. "\": ") .. tostring(valStr)
                    )
                end
                return ((#kvps > 0) and (((("{" .. tostring(
                    table.concat(kvps, ",")
                )) .. "\n") .. tostring(
                    indentStr:rep(indent)
                )) .. "}")) or "{}"
            end
        elseif (valType == "number") or (valType == "boolean") then
            return tostring(val)
        else
            return ("\"" .. tostring(
                escape(
                    tostring(val)
                )
            )) .. "\""
        end
    end
end
return ____exports
end,
["thread"] = function() local ____exports = {}
____exports.mainThreadName = "main thread"
function ____exports.isThread(val)
    return type(val) == "thread"
end
____exports.mainThread = (function()
    local LUA_RIDX_MAINTHREAD = 1
    local registryMainThread = debug.getregistry()[LUA_RIDX_MAINTHREAD]
    return (____exports.isThread(registryMainThread) and registryMainThread) or ____exports.mainThreadName
end)()
return ____exports
end,
["send"] = function() local ____exports = {}
local ____format = require("format")
local Format = ____format.Format
local ____thread = require("thread")
local mainThread = ____thread.mainThread
local mainThreadName = ____thread.mainThreadName
____exports.Send = {}
local Send = ____exports.Send
do
    local function getPrintableValue(value)
        local valueType = type(value)
        if valueType == "string" then
            return ("\"" .. tostring(value)) .. "\""
        elseif ((valueType == "number") or (valueType == "boolean")) or (valueType == "nil") then
            return tostring(value)
        else
            return ("[" .. tostring(value)) .. "]"
        end
    end
    local function isElementKey(tbl, key)
        return ((type(key) == "number") and (key >= 1)) and (key <= #tbl)
    end
    local function buildVariable(name, value)
        local dbgVar = {
            type = type(value),
            name = name,
            value = getPrintableValue(value)
        }
        if type(value) == "table" then
            dbgVar.length = #value
        end
        return dbgVar
    end
    local function send(message)
        io.write(
            Format.asJson(message)
        )
    end
    function Send.error(err)
        local dbgError = {tag = "$luaDebug", type = "error", error = err}
        send(dbgError)
    end
    function Send.debugBreak(message, breakType, threadId)
        local dbgBreak = {tag = "$luaDebug", type = "debugBreak", message = message, breakType = breakType, threadId = threadId}
        send(dbgBreak)
    end
    function Send.result(value)
        local dbgVal = {
            type = type(value),
            value = getPrintableValue(value)
        }
        local dbgResult = {tag = "$luaDebug", type = "result", result = dbgVal}
        send(dbgResult)
    end
    function Send.frames(frameList)
        local dbgStack = {tag = "$luaDebug", type = "stack", frames = frameList}
        send(dbgStack)
    end
    function Send.threads(threadIds, activeThread)
        local dbgThreads = {tag = "$luaDebug", type = "threads", threads = {}}
        for thread, threadId in pairs(threadIds) do
            if (thread == mainThread) or (coroutine.status(thread) ~= "dead") then
                local dbgThread = {
                    name = ((thread == mainThread) and mainThreadName) or tostring(thread),
                    id = threadId,
                    active = (thread == activeThread) or nil
                }
                table.insert(dbgThreads.threads, dbgThread)
            end
        end
        send(dbgThreads)
    end
    function Send.locals(locs)
        local dbgVariables = {
            tag = "$luaDebug",
            type = "variables",
            variables = Format.makeExplicitArray()
        }
        for name, info in pairs(locs) do
            local dbgVar = buildVariable(name, info.val)
            table.insert(dbgVariables.variables, dbgVar)
        end
        send(dbgVariables)
    end
    function Send.vars(varsObj)
        local dbgVariables = {
            tag = "$luaDebug",
            type = "variables",
            variables = Format.makeExplicitArray()
        }
        for name, info in pairs(varsObj) do
            local dbgVar = buildVariable(name, info.val)
            table.insert(dbgVariables.variables, dbgVar)
        end
        send(dbgVariables)
    end
    function Send.props(tbl, kind, first, count)
        local dbgProperties = {
            tag = "$luaDebug",
            type = "properties",
            properties = Format.makeExplicitArray()
        }
        if kind == "indexed" then
            first = first or 1
            local last = (count and ((first + count) - 1)) or ((first + #tbl) - 1)
            for i = first, last do
                local val = tbl[i]
                local name = getPrintableValue(i)
                local dbgVar = buildVariable(name, val)
                table.insert(dbgProperties.properties, dbgVar)
            end
        else
            for key, val in pairs(tbl) do
                if (kind ~= "named") or (not isElementKey(tbl, key)) then
                    local name = getPrintableValue(key)
                    local dbgVar = buildVariable(name, val)
                    table.insert(dbgProperties.properties, dbgVar)
                end
            end
            local meta = getmetatable(tbl)
            if meta then
                dbgProperties.metatable = {
                    type = type(meta),
                    value = getPrintableValue(meta)
                }
            end
            local len = #tbl
            if (len > 0) or ((#dbgProperties.properties == 0) and (not dbgProperties.metatable)) then
                dbgProperties.length = len
            end
        end
        send(dbgProperties)
    end
    function Send.breakpoints(breaks)
        local dbgBreakpoints = {
            tag = "$luaDebug",
            type = "breakpoints",
            breakpoints = Format.makeExplicitArray(breaks)
        }
        send(dbgBreakpoints)
    end
    function Send.help(...)
        local helpStrs = {...}
        local nameLength = 0
        for _, nameAndDesc in ipairs(helpStrs) do
            nameLength = math.max(nameLength, #nameAndDesc[2])
        end
        local builtStrs = {}
        for _, nameAndDesc in ipairs(helpStrs) do
            local name, desc = unpack(nameAndDesc)
            table.insert(
                builtStrs,
                ((tostring(name) .. tostring(
                    string.rep(" ", (nameLength - #name) + 1)
                )) .. ": ") .. tostring(desc)
            )
        end
        io.write(
            tostring(
                table.concat(builtStrs, "\n")
            ) .. "\n"
        )
    end
end
return ____exports
end,
["debugger"] = function() local ____exports = {}
local ____path = require("path")
local Path = ____path.Path
local ____sourcemap = require("sourcemap")
local SourceMap = ____sourcemap.SourceMap
local ____send = require("send")
local Send = ____send.Send
local ____breakpoint = require("breakpoint")
local Breakpoint = ____breakpoint.Breakpoint
local ____thread = require("thread")
local mainThread = ____thread.mainThread
local mainThreadName = ____thread.mainThreadName
local isThread = ____thread.isThread
____exports.Debugger = {}
local Debugger = ____exports.Debugger
do
    local prompt = ""
    local debuggerName = "lldebugger.lua"
    local builtinFunctionPrefix = "[builtin:"
    local skipBreakInNextTraceback = false
    local hookStack = {}
    local threadIds = setmetatable({}, {__mode = "k"})
    local mainThreadId = 1
    threadIds[mainThread] = mainThreadId
    local nextThreadId = mainThreadId + 1
    local function loadCode(code, env)
        if setfenv then
            local f, e = loadstring(code, code)
            if f and env then
                setfenv(f, env)
            end
            return unpack({f, e})
        else
            return load(code, code, "t", env)
        end
    end
    local function backtrace(stack, frameIndex)
        local frames = {}
        for i = 0, #stack - 1 do
            local info = stack[i + 1]
            local frame = {
                source = (info.source and Path.format(info.source)) or "?",
                line = (info.currentline and assert(
                    tonumber(info.currentline)
                )) or -1
            }
            if info.source and info.currentline then
                local sourceMap = SourceMap.get(frame.source)
                if sourceMap then
                    local lineMapping = sourceMap[frame.line]
                    if lineMapping then
                        frame.mappedLocation = {
                            source = assert(sourceMap.sources[lineMapping.sourceIndex + 1]),
                            line = lineMapping.sourceLine,
                            column = lineMapping.sourceColumn
                        }
                    end
                end
            end
            if info.name then
                frame.func = info.name
            end
            if i == frameIndex then
                frame.active = true
            end
            table.insert(frames, frame)
        end
        Send.frames(frames)
    end
    local function getLocals(level, thread)
        local locs = {}
        if isThread(thread) then
            if not debug.getinfo(thread, level, "l") then
                return locs
            end
        elseif not debug.getinfo(level, "l") then
            return locs
        end
        if (coroutine.running() ~= nil) and (not isThread(thread)) then
            return locs
        end
        local name
        local val
        local index = 1
        while true do
            if isThread(thread) then
                name, val = debug.getlocal(thread, level, index)
            else
                name, val = debug.getlocal(level, index)
            end
            if not name then
                break
            end
            local invalidChar = name:match("[^a-zA-Z0-9_]")
            if not invalidChar then
                locs[name] = {
                    val = val,
                    index = index,
                    type = type(val)
                }
            end
            index = index + 1
        end
        index = -1
        while true do
            if isThread(thread) then
                name, val = debug.getlocal(thread, level, index)
            else
                name, val = debug.getlocal(level, index)
            end
            if not name then
                break
            end
            name = name:gsub("[^a-zA-Z0-9_]+", "_")
            local key = (tostring(name) .. "_") .. tostring(-index)
            while locs[key] do
                key = tostring(key) .. "_"
            end
            locs[key] = {
                val = val,
                index = index,
                type = type(val)
            }
            index = index - 1
        end
        return locs
    end
    local function getUpvalues(info)
        local ups = {}
        if (not info.nups) or (not info.func) then
            return ups
        end
        for index = 1, info.nups do
            local name, val = debug.getupvalue(info.func, index)
            ups[assert(name)] = {
                val = val,
                index = index,
                type = type(val)
            }
        end
        return ups
    end
    local function getGlobals()
        local globs = {}
        for key, val in pairs(_G) do
            local name = tostring(key)
            globs[name] = {
                val = val,
                type = type(val)
            }
        end
        return globs
    end
    local function execute(statement, thread, frame, frameOffset, info)
        local activeThread = coroutine.running()
        if activeThread and (not isThread(thread)) then
            return false, "unable to access main thread while running in a coroutine"
        end
        local level = ((thread == (activeThread or mainThread)) and ((frame + frameOffset) + 1)) or frame
        local locs = getLocals(level + 1, thread)
        local ups = getUpvalues(info)
        local env = setmetatable(
            {},
            {
                __index = function(self, name)
                    local variable = locs[name] or ups[name]
                    if variable ~= nil then
                        return variable.val
                    else
                        return _G[name]
                    end
                end,
                __newindex = function(self, name, val)
                    local variable = locs[name] or ups[name]
                    if variable ~= nil then
                        variable.type = type(val)
                        variable.val = val
                    else
                        _G[name] = val
                    end
                end
            }
        )
        local func, err = loadCode(statement, env)
        if not func then
            return false, err
        end
        local success, result = pcall(func)
        if success then
            for _, loc in pairs(locs) do
                if isThread(thread) then
                    debug.setlocal(thread, level, loc.index, loc.val)
                else
                    debug.setlocal(level, loc.index, loc.val)
                end
            end
            for _, up in pairs(ups) do
                debug.setupvalue(
                    assert(info.func),
                    up.index,
                    up.val
                )
            end
        end
        return success, result
    end
    local function getInput()
        if #prompt > 0 then
            io.write(prompt)
        end
        local inp = io.read("*l")
        return inp
    end
    local function getStack(threadOrOffset)
        local thread
        local i = 1
        if isThread(threadOrOffset) then
            thread = threadOrOffset
        else
            i = i + threadOrOffset
        end
        local stack = {}
        while true do
            local stackInfo
            if thread then
                stackInfo = debug.getinfo(thread, i, "nSluf")
            else
                stackInfo = debug.getinfo(i, "nSluf")
            end
            if not stackInfo then
                break
            end
            table.insert(stack, stackInfo)
            i = i + 1
        end
        return stack
    end
    local breakAtDepth = -1
    local breakInThread
    local function debugBreak(activeThread, stackOffset)
        stackOffset = stackOffset + 1
        local activeStack = getStack(stackOffset)
        local activeThreadFrameOffset = stackOffset
        local inactiveThreadFrameOffset = 0
        breakAtDepth = -1
        breakInThread = nil
        local frameOffset = activeThreadFrameOffset
        local frame = 0
        local currentThread = activeThread
        local currentStack = activeStack
        local info = assert(currentStack[frame + 1])
        while true do
            local inp = getInput()
            if (not inp) or (inp == "quit") then
                os.exit(0)
            elseif (inp == "cont") or (inp == "continue") then
                break
            elseif inp == "help" then
                Send.help({"help", "show available commands"}, {"cont|continue", "continue execution"}, {"quit", "stop program and debugger"}, {"step", "step to next line"}, {"stepin", "step in to current line"}, {"stepout", "step out to calling line"}, {"stack", "show current stack trace"}, {"frame n", "set active stack frame"}, {"locals", "show all local variables available in current context"}, {"ups", "show all upvalue variables available in the current context"}, {"globals", "show all global variables in current environment"}, {"props indexed [start] [count]", "show array elements of a table"}, {"props named|all", "show properties of a table"}, {"eval", "evaluate an expression in the current context"}, {"exec", "execute a statement in the current context"}, {"break set file.ext:n [cond]", "set a breakpoint"}, {"break del|delete file.ext:n", "delete a breakpoint"}, {"break en|enable file.ext:n", "enable a breakpoint"}, {"break dis|disable file.ext:n", "disable a breakpoint"}, {"break list", "show all breakpoints"}, {"break clear", "delete all breakpoints"}, {"threads", "list active thread ids"}, {"thread n", "set current thread by id"})
            elseif inp == "threads" then
                Send.threads(threadIds, activeThread)
            elseif inp:sub(1, 6) == "thread" then
                local newThreadIdStr = inp:match("^thread%s+(%d+)$")
                if newThreadIdStr ~= nil then
                    local newThreadId = assert(
                        tonumber(newThreadIdStr)
                    )
                    local newThread
                    for thread, threadId in pairs(threadIds) do
                        if threadId == newThreadId then
                            newThread = thread
                            break
                        end
                    end
                    if newThread ~= nil then
                        if newThread == activeThread then
                            currentStack = activeStack
                        elseif newThread == mainThreadName then
                            currentStack = {{name = "unable to access main thread while running in a coroutine", source = ""}}
                        else
                            currentStack = getStack(newThread)
                            if #currentStack == 0 then
                                table.insert(currentStack, {name = "thread has not been started", source = ""})
                            end
                        end
                        currentThread = newThread
                        frame = 0
                        frameOffset = ((currentThread == activeThread) and activeThreadFrameOffset) or inactiveThreadFrameOffset
                        info = assert(currentStack[frame + 1])
                        backtrace(currentStack, frame)
                    else
                        Send.error("Bad thread id")
                    end
                else
                    Send.error("Bad thread id")
                end
            elseif inp == "step" then
                breakAtDepth = #activeStack
                breakInThread = activeThread
                break
            elseif inp == "stepin" then
                breakAtDepth = math.huge
                breakInThread = nil
                break
            elseif inp == "stepout" then
                breakAtDepth = #activeStack - 1
                breakInThread = activeThread
                break
            elseif inp == "stack" then
                backtrace(currentStack, frame)
            elseif inp:sub(1, 5) == "frame" then
                local newFrameStr = inp:match("^frame%s+(%d+)$")
                if newFrameStr ~= nil then
                    local newFrame = assert(
                        tonumber(newFrameStr)
                    )
                    if ((newFrame ~= nil) and (newFrame > 0)) and (newFrame <= #currentStack) then
                        frame = newFrame - 1
                        info = assert(currentStack[frame + 1])
                        backtrace(currentStack, frame)
                    else
                        Send.error("Bad frame")
                    end
                else
                    Send.error("Bad frame")
                end
            elseif inp == "locals" then
                local locs = getLocals((frame + frameOffset) + 1, currentThread)
                Send.vars(locs)
            elseif inp == "ups" then
                local ups = getUpvalues(info)
                Send.vars(ups)
            elseif inp == "globals" then
                local globs = getGlobals()
                Send.vars(globs)
            elseif inp:sub(1, 5) == "break" then
                local cmd = inp:match("^break%s+([a-z]+)")
                local file
                local line
                local breakpoint
                if ((((((cmd == "set") or (cmd == "del")) or (cmd == "delete")) or (cmd == "dis")) or (cmd == "disable")) or (cmd == "en")) or (cmd == "enable") then
                    local lineStr
                    file, lineStr = inp:match("^break%s+[a-z]+%s+(.-):(%d+)")
                    if (file ~= nil) and (lineStr ~= nil) then
                        line = assert(
                            tonumber(lineStr)
                        )
                        breakpoint = Breakpoint.get(file, line)
                    end
                end
                if cmd == "set" then
                    if (file ~= nil) and (line ~= nil) then
                        local condition = inp:match("^break%s+[a-z]+%s+.-:%d+%s+(.+)")
                        Breakpoint.add(file, line, condition)
                        breakpoint = assert(
                            Breakpoint.get(file, line)
                        )
                        Send.breakpoints({breakpoint})
                    else
                        Send.error("Bad breakpoint")
                    end
                elseif (cmd == "del") or (cmd == "delete") then
                    if (file ~= nil) and (line ~= nil) then
                        Breakpoint.remove(file, line)
                        Send.result(nil)
                    else
                        Send.error("Bad breakpoint")
                    end
                elseif (cmd == "dis") or (cmd == "disable") then
                    if breakpoint ~= nil then
                        breakpoint.enabled = false
                        Send.breakpoints({breakpoint})
                    else
                        Send.error("Bad breakpoint")
                    end
                elseif (cmd == "en") or (cmd == "enable") then
                    if breakpoint ~= nil then
                        breakpoint.enabled = true
                        Send.breakpoints({breakpoint})
                    else
                        Send.error("Bad breakpoint")
                    end
                elseif cmd == "clear" then
                    Breakpoint.clear()
                    Send.breakpoints(
                        Breakpoint.getAll()
                    )
                elseif cmd == "list" then
                    Send.breakpoints(
                        Breakpoint.getAll()
                    )
                else
                    Send.error("Bad breakpoint command")
                end
            elseif inp:sub(1, 4) == "eval" then
                local expression = inp:match("^eval%s+(.+)$")
                if not expression then
                    Send.error("Bad expression")
                else
                    local s, r = execute(
                        "return " .. tostring(expression),
                        currentThread,
                        frame,
                        frameOffset,
                        info
                    )
                    if s then
                        Send.result(r)
                    else
                        Send.error(r)
                    end
                end
            elseif inp:sub(1, 5) == "props" then
                local expression, kind, first, count = inp:match("^props%s+(.-)%s*([a-z]+)%s*(%d*)%s*(%d*)$")
                if not expression then
                    Send.error("Bad expression")
                elseif ((kind ~= "all") and (kind ~= "named")) and (kind ~= "indexed") then
                    Send.error(
                        "Bad kind: " .. (("'" .. tostring(kind)) .. "'")
                    )
                else
                    local s, r = execute(
                        "return " .. tostring(expression),
                        currentThread,
                        frame,
                        frameOffset,
                        info
                    )
                    if s then
                        if type(r) == "table" then
                            Send.props(
                                r,
                                kind,
                                tonumber(first),
                                tonumber(count)
                            )
                        else
                            Send.error(
                                ("Expression \"" .. tostring(expression)) .. "\" is not a table"
                            )
                        end
                    else
                        Send.error(r)
                    end
                end
            elseif inp:sub(1, 4) == "exec" then
                local statement = inp:match("^exec%s+(.+)$")
                if not statement then
                    Send.error("Bad statement")
                else
                    local s, r = execute(statement, currentThread, frame, frameOffset, info)
                    if s then
                        Send.result(r)
                    else
                        Send.error(r)
                    end
                end
            else
                Send.error("Bad command")
            end
        end
    end
    local function comparePaths(a, b)
        local aLen = #a
        local bLen = #b
        if aLen == bLen then
            return a == b
        elseif aLen < bLen then
            return (tostring(Path.separator) .. tostring(a)) == b:sub(-(aLen + 1))
        else
            return (tostring(Path.separator) .. tostring(b)) == a:sub(-(bLen + 1))
        end
    end
    local function checkBreakpoint(breakpoint, file, line, sourceMap)
        if (breakpoint.line == line) and comparePaths(breakpoint.file, file) then
            return true
        end
        if sourceMap then
            local lineMapping = sourceMap[line]
            if lineMapping and (lineMapping.sourceLine == breakpoint.line) then
                local sourceMapFile = sourceMap.sources[lineMapping.sourceIndex + 1]
                if sourceMapFile then
                    return comparePaths(breakpoint.file, sourceMapFile)
                end
            end
        end
        return false
    end
    local function debugHook(event, line)
        local stackOffset = 2
        local topFrame = debug.getinfo(stackOffset, "nSluf")
        if ((not topFrame) or (not topFrame.source)) or (topFrame.source:sub(-#debuggerName) == debuggerName) then
            return
        end
        if topFrame.short_src and (topFrame.short_src:sub(1, #builtinFunctionPrefix) == builtinFunctionPrefix) then
            return
        end
        local activeThread = coroutine.running() or mainThread
        if breakAtDepth >= 0 then
            local stepBreak
            if not breakInThread then
                stepBreak = true
            elseif activeThread == breakInThread then
                stepBreak = #getStack(stackOffset) <= breakAtDepth
            else
                stepBreak = (breakInThread ~= mainThread) and (coroutine.status(breakInThread) == "dead")
            end
            if stepBreak then
                Send.debugBreak(
                    "step",
                    "step",
                    assert(threadIds[activeThread])
                )
                debugBreak(activeThread, stackOffset)
                return
            end
        end
        local breakpoints = Breakpoint.getAll()
        if (not topFrame.currentline) or (#breakpoints == 0) then
            return
        end
        local source = Path.format(
            assert(topFrame.source)
        )
        local sourceMap = SourceMap.get(source)
        for ____, breakpoint in ipairs(breakpoints) do
            if breakpoint.enabled and checkBreakpoint(breakpoint, source, topFrame.currentline, sourceMap) then
                if breakpoint.condition then
                    local condition = "return " .. tostring(breakpoint.condition)
                    local success, result = execute(condition, activeThread, 0, stackOffset, topFrame)
                    if success and result then
                        local conditionDisplay = ((("\"" .. tostring(breakpoint.condition)) .. "\" = \"") .. tostring(result)) .. "\""
                        Send.debugBreak(
                            (((("breakpoint hit: \"" .. tostring(breakpoint.file)) .. ":") .. tostring(breakpoint.line)) .. "\", ") .. tostring(conditionDisplay),
                            "breakpoint",
                            assert(threadIds[activeThread])
                        )
                        debugBreak(activeThread, stackOffset)
                        break
                    end
                else
                    Send.debugBreak(
                        ((("breakpoint hit: \"" .. tostring(breakpoint.file)) .. ":") .. tostring(breakpoint.line)) .. "\"",
                        "breakpoint",
                        assert(threadIds[activeThread])
                    )
                    debugBreak(activeThread, stackOffset)
                    break
                end
            end
        end
    end
    local function mapSource(indent, file, lineStr, remainder)
        local sourceMap = SourceMap.get(file)
        if sourceMap then
            local line = assert(
                tonumber(lineStr)
            )
            local lineMapping = sourceMap[line]
            if lineMapping then
                local sourceFile = sourceMap.sources[lineMapping.sourceIndex + 1]
                local sourceLine = lineMapping.sourceLine
                local sourceColumn = lineMapping.sourceColumn
                return ((((((tostring(indent) .. tostring(sourceFile)) .. ":") .. tostring(sourceLine)) .. ":") .. tostring(sourceColumn)) .. ":") .. tostring(remainder)
            end
        end
        return ((((tostring(indent) .. tostring(file)) .. ":") .. tostring(lineStr)) .. ":") .. tostring(remainder)
    end
    local function mapSources(str)
        str = str:gsub("(%s*)([^\r\n]+):(%d+):([^\r\n]+)", mapSource)
        return str
    end
    local luaCoroutineCreate
    luaCoroutineCreate = coroutine.create
    local function debuggerCoroutineCreate(f)
        local thread = luaCoroutineCreate(f)
        threadIds[thread] = nextThreadId
        nextThreadId = nextThreadId + 1
        local hook = debug.gethook()
        if hook == debugHook then
            debug.sethook(thread, debugHook, "l")
        end
        return thread
    end
    local luaCoroutineWrap
    luaCoroutineWrap = coroutine.wrap
    local function debuggerCoroutineWrap(f)
        local thread = debuggerCoroutineCreate(f)
        local resumer
        resumer = function(...)
            local results = {
                coroutine.resume(thread, ...)
            }
            if not results[1] then
                error(results[2], 0)
            end
            return unpack(results, 2)
        end
        return resumer
    end
    local luaDebugTraceback = debug.traceback
    local function debuggerTraceback(threadOrMessage, messageOrLevel, level)
        local trace = luaDebugTraceback(threadOrMessage, messageOrLevel, level)
        if trace then
            trace = mapSources(trace)
        end
        if skipBreakInNextTraceback then
            skipBreakInNextTraceback = false
        else
            local thread = ((isThread(threadOrMessage) and threadOrMessage) or coroutine.running()) or mainThread
            Send.debugBreak(
                trace or "error",
                "error",
                assert(threadIds[thread])
            )
            debugBreak(thread, 3)
        end
        return trace
    end
    local luaError
    luaError = error
    local function debuggerError(message, level)
        message = mapSources(message)
        local thread = coroutine.running() or mainThread
        Send.debugBreak(
            message,
            "error",
            assert(threadIds[thread])
        )
        debugBreak(thread, 2)
        skipBreakInNextTraceback = true
        return luaError(message, level)
    end
    local luaAssert = assert
    local function debuggerAssert(v, ...)
        local args = {...}
        if not v then
            local message = ((args[1] ~= nil) and mapSources(
                tostring(args[1])
            )) or "assertion failed"
            local thread = coroutine.running() or mainThread
            Send.debugBreak(
                message,
                "error",
                assert(threadIds[thread])
            )
            debugBreak(thread, 2)
            skipBreakInNextTraceback = true
            return luaError(message)
        end
        return v, ...
    end
    local function setErrorHandler()
        local hookType = hookStack[#hookStack]
        if hookType == "global" then
            _G.error = debuggerError
            _G.assert = debuggerAssert
            debug.traceback = debuggerTraceback
        else
            _G.error = luaError
            _G.assert = luaAssert
            debug.traceback = luaDebugTraceback
        end
    end
    function Debugger.clearHook()
        while #hookStack > 0 do
            table.remove(hookStack)
        end
        setErrorHandler()
        coroutine.create = luaCoroutineCreate
        coroutine.wrap = luaCoroutineWrap
        debug.sethook()
        for thread in pairs(threadIds) do
            if isThread(thread) and (coroutine.status(thread) ~= "dead") then
                debug.sethook(thread)
            end
        end
    end
    function Debugger.pushHook(hookType)
        table.insert(hookStack, hookType)
        setErrorHandler()
        if #hookStack > 1 then
            return
        end
        coroutine.create = debuggerCoroutineCreate
        coroutine.wrap = debuggerCoroutineWrap
        debug.sethook(debugHook, "l")
        for thread in pairs(threadIds) do
            if isThread(thread) and (coroutine.status(thread) ~= "dead") then
                debug.sethook(thread, debugHook, "l")
            end
        end
    end
    function Debugger.popHook()
        table.remove(hookStack)
        if #hookStack == 0 then
            Debugger.clearHook()
        else
            setErrorHandler()
        end
    end
    function Debugger.triggerBreak()
        breakAtDepth = math.huge
    end
    function Debugger.debugGlobal(breakImmediately)
        ____exports.Debugger.pushHook("global")
        if breakImmediately then
            ____exports.Debugger.triggerBreak()
        end
    end
    local function onError(err)
        local msg = mapSources(
            tostring(err)
        )
        local thread = coroutine.running() or mainThread
        Send.debugBreak(
            msg,
            "error",
            assert(threadIds[thread])
        )
        debugBreak(thread, 2)
    end
    function Debugger.debugFunction(func, breakImmediately, args)
        ____exports.Debugger.pushHook("function")
        if breakImmediately then
            ____exports.Debugger.triggerBreak()
        end
        local success, results = xpcall(
            function() return {
                func(
                    unpack(args)
                )
            } end,
            onError
        )
        ____exports.Debugger.popHook()
        if success then
            return unpack(results)
        end
    end
end
return ____exports
end,
["lldebugger"] = function() local ____exports = {}
local ____debugger = require("debugger")
local Debugger = ____debugger.Debugger
_G.unpack = _G.unpack or table.unpack
io.stdout:setvbuf("no")
io.stderr:setvbuf("no")
function ____exports.start(breakImmediately)
    breakImmediately = breakImmediately or (os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1")
    Debugger.debugGlobal(breakImmediately)
end
function ____exports.finish()
    Debugger.popHook()
end
function ____exports.stop()
    Debugger.clearHook()
end
function ____exports.runFile(filePath, breakImmediately, ...)
    local args = {...}
    if type(filePath) ~= "string" then
        error(
            ("expected string as first argument to runFile, but got '" .. tostring(
                type(filePath)
            )) .. "'",
            0
        )
    end
    if (breakImmediately ~= nil) and (type(breakImmediately) ~= "boolean") then
        error(
            ("expected boolean as second argument to runFile, but got '" .. tostring(
                type(breakImmediately)
            )) .. "'",
            0
        )
    end
    local func = assert(
        loadfile(filePath)
    )
    return Debugger.debugFunction(func, breakImmediately, args)
end
function ____exports.call(func, breakImmediately, ...)
    local args = {...}
    if type(func) ~= "function" then
        error(
            ("expected string as first argument to debugFile, but got '" .. tostring(
                type(func)
            )) .. "'",
            0
        )
    end
    if (breakImmediately ~= nil) and (type(breakImmediately) ~= "boolean") then
        error(
            ("expected boolean as second argument to debugFunction, but got '" .. tostring(
                type(breakImmediately)
            )) .. "'",
            0
        )
    end
    return Debugger.debugFunction(func, breakImmediately, args)
end
function ____exports.requestBreak()
    Debugger.triggerBreak()
end
return ____exports
end,
}
return require("lldebugger")
