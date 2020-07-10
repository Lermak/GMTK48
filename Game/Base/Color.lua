--[[
Copyright (c) 2010-2013 Matthias Richter
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
Except as contained in this notice, the name(s) of the above copyright holders
shall not be used in advertising or otherwise to promote the sale, use or
other dealings in this Software without prior written authorization.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
]]--

local assert = assert
local sqrt, cos, sin, atan2 = math.sqrt, math.cos, math.sin, math.atan2

local color = {}
color.__index = color

local hasffi, ffi = pcall(require, "ffi")
local jitenabled = jit and jit.status() or false

local new
local iscolor

if false then
	ffi.cdef "struct hump_color { unsigned char r,g,b,a; };"

	new = ffi.typeof("struct hump_color")
	
	function iscolor(v)
		return ffi.istype(new, v)
	end
else
	function new(r,g,b,a)
		return setmetatable({r = r or 0, g = g or 0, b = b or 0, a = a or 255}, color)
	end
	
	function iscolor(v)
		return getmetatable(v) == color
	end
end

local zero = new(0,0)

function color:setRGB(color)
  self.r = color.r
  self.g = color.g
  self.b = color.b
end

function color:clone()
	return new(self.r, self.g, self.b, self.a)
end

function color:unpack()
	return self.r, self.g, self.b, self.a
end

function color:__tostring()
	return "("..tonumber(self.r)..","..tonumber(self.g)..","..tonumber(self.b)..","..tonumber(self.a)..")"
end

if false then
	ffi.metatype(new, color)
end

-- the module
return setmetatable({new = new, iscolor = iscolor, zero = zero},
{__call = function(_, ...) return new(...) end})