-- Splits a string on a certain pattern
local function Split( String, Pattern )
	
	local Result = { }
	
	local From = 1
	
	local delim_from, delim_to = String:find( Pattern, From  )
	
	while delim_from do
		
		Result[ #Result + 1 ] = String:sub( From , delim_from - 1 )
		
		From  = delim_to + 1
		
		delim_from, delim_to = String:find( Pattern, From  )
		
	end
	
	Result[ #Result + 1 ] = String:sub( From  )
	
	return Result
	
end

-- Table of characters to escape for use in string.gsub
local Pattern_Escape = {
	
	["("] = "%(",
	
	[")"] = "%)",
	
	["."] = "%.",
	
	["%"] = "%%",
	
	["+"] = "%+",
	
	["-"] = "%-",
	
	["*"] = "%*",
	
	["?"] = "%?",
	
	["["] = "%[",
	
	["]"] = "%]",
	
	["^"] = "%^",
	
	["$"] = "%$",
	
	["\0"] = "%z"
	
}

-- Makes a string safe for use in string.gsub
local function PatternSafe( Str )
	
	return Str:gsub( ".", Pattern_Escape )
	
end

local min, max, abs, floor, ceil = math.min, math.max, math.abs, math.floor, math.ceil
-- Pre-made math functions for use in equations
local LuaMathFuncs = {
	
	Round = function ( Num, DecimalsPoints )
	
		local Mult = 10 ^ ( DecimalsPoints or 0 )
		
		return floor( Num * Mult + 0.5 ) / Mult
	
	end,
	
	Truncate = function ( Num, DecimalsPoints )
	
		local Mult = 10 ^ ( DecimalsPoints or 0 )
		
		local FloorOrCeil = Num < 0 and ceil or floor
	
		return FloorOrCeil( Num * Mult ) / Mult
	
	end,

	Approach = function ( Num, Target, Inc )
	
		Inc = abs( Inc )
	
		if ( Num < Target ) then
	
			return min( Num + Inc, Target )
	
		elseif ( Num > Target ) then
	
			return max( Num - Inc, Target )
	
		end
	
		return Target
	
	end
	
}

local oldTonumber = tonumber

local Huge, Zero = tostring( math.huge ), tostring( 0 / 0 )
-- Allows 0/0 and math.huge and such to work
local tonumber = function ( String )
	
	if String == Huge then
		
		return math.huge
		
	elseif String == Zero then
		
		return 0/0
		
	end
	
	return oldTonumber( String )
	
end
-- The following are ran in order, such that * runs before /
local Operators = {
	-- Calculates brackets and user/math/pre-made functions
	{ "%w*%b()", "(%w*)(%b())", function ( LocalVars, LocalFuncs, Func, Args )
		
		Args = Args:sub( 2, -2 )
		-- If Func is "", it's just a bracket to calculate
		if Func == "" then
			
			return Calculate( Args, true, LocalVars, LocalFuncs )
			
		end
		
		local Func, Args = LocalFuncs[ Func ] or LuaMathFuncs[ Func ] or math[ Func ], Split( Args, "%," )
		
		for a = 1, #Args do
			
			Args[ a ] = Calculate( Args[ a ], true, LocalVars, LocalFuncs )
			
		end
		
		if type( Func ) == "table" then
			
			local LocalFunc = Func[ 1 ]
			
			for a = 2, #Func do
				
				if not Args[ a - 1 ] then break end
				
				LocalFunc = LocalFunc:gsub( PatternSafe( Func[ a ] ), Args[ a - 1 ] )
				
			end
			
			return Calculate( LocalFunc, true, LocalVars, LocalFuncs )
			
		elseif type( Func ) == "function" then
			
			return Func( unpack( Args ) )
			
		end
		
	end },
	-- Handles number!
	{ "%!", "(%w*%.*%w*)%!", function ( LocalVars, LocalFuncs, x )
		
		local x = tonumber( x )
		
		if x then
			
			local Total = 1
			
			while x > 0 do
				
				Total = Total * x
				
				x = x - 1
				
			end
			
			return Total
			
		end
		
	end },
	-- Handles number^number
	{ "%^", "([-]?%w*%.*%w*)%^([-]?%w*%.*%w*)", function ( LocalVars, LocalFuncs, x, y )
		
		local x, y = tonumber( x ), tonumber( y )
		
		if x and y then return x ^ y end
		
	end },
	-- Handles number%number
	{ "%%", "([-]?%w*%.*%w*)%%([-]?%w*%.*%w*)", function ( LocalVars, LocalFuncs, x, y )
		
		local x, y = tonumber( x ), tonumber( y )
		
		if x and y then return x % y end
		
	end },
	-- Handles number*number
	{ "%*", "([-]?%w*%.*%w*)%*([-]?%w*%.*%w*)", function ( LocalVars, LocalFuncs, x, y )
		
		local x, y = tonumber( x ), tonumber( y )
		
		if x and y then return x * y end
		
	end },
	-- Handles number/number
	{ "%/", "([-]?%w*%.*%w*)%/([-]?%w*%.*%w*)", function ( LocalVars, LocalFuncs, x, y )
		
		local x, y = tonumber( x ), tonumber( y )
		
		if x and y then return x / y end
		
	end },
	-- Handles number+number
	{ "%+", "([-]?%w*%.*%w*)%+([-]?%w*%.*%w*)", function ( LocalVars, LocalFuncs, x, y )
		
		local x, y = tonumber( x ), tonumber( y )
		
		if x and y then return x + y end
		
	end },
	-- Handles number-number
	{ "%-", "([-]?%w*%.*%w*)%-([-]?%w*%.*%w*)", function ( LocalVars, LocalFuncs, x, y )
		
		local x, y = tonumber( x ), tonumber( y )
		
		if x and y then return x - y end
		
	end }
	
}
-- Formula is the string to interpret
-- Recursion is a bool, true means it's called itself and will not check for user variables / functions being defined, don't set this yourself
-- LocalVars is a table of user defined variables ( "a=1" ) in the form [ Name ] = Value
-- LocalFuncs is a table of user defined functions ( "a(x,y)=x*y" ) in the form [ Name ( "a" ) ] = { Function ( The function as a string such that "a(x,y)=x*y" is "x*y" ), Arguments...( The arguments required for the function as a table of strings such that "a(x,y)=x*y" is "x", "y" } :. "a(x,y)=x*y" is [ a ] = { "x*y", "x", "y" }
function Calculate( Formula, Recursion, LocalVars, LocalFuncs )
	
	local Num = tonumber( Formula )
	
	if Num then return Num end
	
	local LocalVars, LocalFuncs = LocalVars or { }, LocalFuncs or { }
	
	-- Handle Local Variables / Functions
	if Recursion == nil then
		
		-- Get rid of any whitespace
		Formula = Formula:gsub( "%s+", "" )
		-- Check if the user is defining any variables or functions
		if Formula:find("%;") then
			-- Split the string into variables/functions and the actual expression
            local LastSplit = Formula:reverse( ):find( ";" )
			
			local Locals
			
            Formula, Locals = Formula:sub( -LastSplit + 1 ), Split( Formula:sub( 1, -LastSplit - 1 ), "%;" )
			-- Iterates through the user defined variables / functions and interpret them
			for a = 1, #Locals do
				
				local Name, Value = Locals[ a ]:match( "(.+)=(.+)" )
				
				if not Name then error( "Invalid local function/variable - " .. Locals[ a ] ) end
				
				local FuncName, Args = Name:match( "(%a+)(%b())" )
				
				if FuncName then
					
					Args = Split( Args:sub( 2, -2 ), "%," )
					
					LocalFuncs[ FuncName ] = { Value, unpack( Args ) }
					
				else
					
					LocalVars[ Name ] = Calculate( Value, true, LocalVars, LocalFuncs )
					
				end
				
			end
			
		end
		
	end
	-- Replaces any characters that match a user variable or math variable
	Formula = Formula:gsub( "(%w+)(.?)", function ( Var, Next )
		
		if Next ~= "(" and ( LocalVars[ Var ] or type( math[ Var ] ) == "number" ) then
			
			return ( LocalVars[ Var ] or math[ Var ] ) .. Next
			
		end
		
	end )
	-- Handles operators
	for a = 1, #Operators do
		
		if Formula:find( Operators[ a ][ 1 ] ) then
			
			for Word in Formula:gmatch( Operators[ a ][ 1 ] ) do
				
				Formula = Formula:gsub( Operators[ a ][ 2 ], function ( ... )
					
					local Ret = Operators[ a ][ 3 ]( LocalVars, LocalFuncs, ... )
					
					return Ret
					
				end, 1 )
				
			end
			
		end
		
	end
	
	return tonumber( Formula ) or error( "Invalid formula - " .. Formula )
	
end

return Calculate