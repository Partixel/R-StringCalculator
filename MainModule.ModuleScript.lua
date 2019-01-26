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

local LuaMathFuncs = {
	
	round = function ( Num, DecimalsPoints )
	
		local Mult = 10 ^ ( DecimalsPoints or 0 )
		
		return math.floor( Num * Mult + 0.5 ) / Mult
	
	end,
	
	truncate = function ( Num, DecimalsPoints )
	
		local Mult = 10 ^ ( DecimalsPoints or 0 )
		
		local FloorOrCeil = Num < 0 and math.ceil or math.floor
	
		return FloorOrCeil( Num * Mult ) / Mult
	
	end,

	approach = function ( Num, Target, Inc )
	
		Inc = math.abs( Inc )
	
		if ( Num < Target ) then
	
			return math.min( Num + Inc, Target )
	
		elseif ( Num > Target ) then
	
			return math.max( Num - Inc, Target )
	
		end
	
		return Target
	
	end
	
}

function MapArgs( Nums, Args )
	
	for a = 1, #Nums do
		
		if type( Nums[ a ] ) == "table" then
			
			Nums[ a ] = MapArgs( Nums[ a ], Args )
			
		elseif Args[ Nums[ a ] ] then
			
			Nums[ a ] = Args[ Nums[ a ] ]
			
		end
		
	end
	
	return Nums
	
end

function ToNumber( Nums, LocalFuncs )
	
	local a = 1
	
	while a <= #Nums do
		
		if type( Nums[ a ] ) == "table" then
			
			local Prev = Nums[ a - 1 ]
			
			if Prev then
				
				if type( Prev ) == "number" then
					
					Nums[ a - 1 ] = Nums[ a - 1 ] * ToNumber( Nums[ a ], LocalFuncs )
					
					table.remove( Nums, a )
					
				elseif type( Prev ) == "function" or LocalFuncs[ Prev ] then
					
					local Args = { { } }
					
					for b = 1, #Nums[ a ] do
						
						if Nums[ a ][ b ] == "," then
							
							Args[ #Args ] = ToNumber( Args[ #Args ] )
							
							Args[ #Args + 1 ] = { }
							
						else
							
							Args[ #Args ][ #Args[ #Args ] + 1 ] = Nums[ a ][ b ]
							
						end
						
					end
					
					Args[ #Args ] = ToNumber( Args[ #Args ], LocalFuncs )
					
					if type( Prev ) == "function" then
						
						Nums[ a - 1 ] = Prev( unpack( Args ) )
						
					else
						
						local MappedArgs = { }
						
						for a = 1, #LocalFuncs[ Prev ][ 2 ] do
							
							MappedArgs[ LocalFuncs[ Prev ][ 2 ][ a ] ] = Args[ a ]
							
						end
						
						local Func = MapArgs( LocalFuncs[ Prev ][ 1 ], MappedArgs )
						
						Nums[ a - 1 ] = ToNumber( Func, LocalFuncs )
						
					end
					
					table.remove( Nums, a )
					
				else
					
					Nums[ a ] = ToNumber( Nums[ a ], LocalFuncs )
					
					a = a + 1
					
				end
				
			else
				
				Nums[ a ] = ToNumber( Nums[ a ], LocalFuncs )
				
				a = a + 1
				
			end
			
		else
			
			a = a + 1
			
		end
		
	end
	
	a = 1
	
	while a <= #Nums do
		
		if Nums[ a ] == "!" then
			
			local x = Nums[ a - 1 ]
			
			local Total = 1
			
			while x > 0 do
				
				Total = Total * x
				
				x = x - 1
				
			end
			
			Nums[ a - 1 ] = Total
			
			table.remove( Nums, a )
			
		else
			
			a = a + 1
			
		end
		
	end
	
	a = 1
	
	while a <= #Nums do
		
		if Nums[ a ] == "^" then
			
			Nums[ a - 1 ] = Nums[ a - 1 ] ^ Nums[ a + 1 ]
			
			table.remove( Nums, a )
			
			table.remove( Nums, a )
			
		else
			
			a = a + 1
			
		end
		
	end
	
	a = 1
	
	while a <= #Nums do
		
		if Nums[ a ] == "%" then
			
			Nums[ a - 1 ] = Nums[ a - 1 ] % Nums[ a + 1 ]
			
			table.remove( Nums, a )
			
			table.remove( Nums, a )
			
		else
			
			a = a + 1
			
		end
		
	end
	
	a = 1
	
	while a <= #Nums do
		
		if Nums[ a ] == "*" then
			
			Nums[ a - 1 ] = Nums[ a - 1 ] * Nums[ a + 1 ]
			
			table.remove( Nums, a )
			
			table.remove( Nums, a )
			
		elseif Nums[ a ] == "/" then
			
			Nums[ a - 1 ] = Nums[ a - 1 ] / Nums[ a + 1 ]
			
			table.remove( Nums, a )
			
			table.remove( Nums, a )
			
		else
			
			a = a + 1
			
		end
		
	end
	
	a = 1
	
	while a <= #Nums do
		
		if Nums[ a ] == "+" then
			
			Nums[ a - 1 ] = Nums[ a - 1 ] + Nums[ a + 1 ]
			
			table.remove( Nums, a )
			
			table.remove( Nums, a )
			
		elseif Nums[ a ] == "-" then
			
			Nums[ a - 1 ] = Nums[ a - 1 ] - Nums[ a + 1 ]
			
			table.remove( Nums, a )
			
			table.remove( Nums, a )
			
		elseif a ~= 1 and Nums[ a ] < 0 then
			
			Nums[ a - 1 ] = Nums[ a - 1 ] + Nums[ a ]
			
			table.remove( Nums, a )
			
		else
			
			a = a + 1
			
		end
		
	end
	
	return Nums[ 1 ]
	
end

function Interpret( Formula, LocalVars )
	
	local Ins = { { } }
	
	local Var
	
	for M1, M2 in string.gmatch( Formula, "(-?%d*%.?%d*)(%D?)" ) do
		
		if Var then
			
			Var = Var .. M1
			
		elseif M1 ~= "" then
			
			Ins[ #Ins ][ #Ins[ #Ins ] + 1 ] = tonumber( M1 )
			
		end
		
		if M2 == "(" then
			
			if Var then
				
				Ins[ #Ins ][ #Ins[ #Ins ] + 1 ] = LocalVars[ Var ] or math[ Var ] or LuaMathFuncs[ Var ] or Var
				
				Var = nil
				
			end
			
			local In = { }
			
			Ins[ #Ins ][ #Ins[ #Ins ] + 1 ] = In
			
			Ins[ #Ins + 1 ] = In
			
		elseif M2 == ")" then
			
			if Var then
				
				Ins[ #Ins ][ #Ins[ #Ins ] + 1 ] = LocalVars[ Var ] or math[ Var ] or LuaMathFuncs[ Var ] or Var
				
				Var = nil
				
			end
			
			Ins[ #Ins ] = nil
			
		elseif M2:find("%W") then
			
			if Var then
				
				Ins[ #Ins ][ #Ins[ #Ins ] + 1 ] = LocalVars[ Var ] or math[ Var ] or LuaMathFuncs[ Var ] or Var
				
				Var = nil
				
			end
			
			Ins[ #Ins ][ #Ins[ #Ins ] + 1 ] = M2
			
		elseif M2 ~= "" then
			
			Var = Var and ( Var .. M2 ) or M2
			
		end
		
	end
	
	if Var then
		
		Ins[ #Ins ][ #Ins[ #Ins ] + 1 ] = LocalVars[ Var ] or math[ Var ] or LuaMathFuncs[ Var ] or Var
		
	end
	
	return Ins[ 1 ]
	
end

return function ( Formula, LocalVars, LocalFuncs )
	
	Formula = Formula:gsub( "%s+", "" )
	
	if tonumber( Formula ) then return tonumber( Formula ) end
	
	local LocalVars, LocalFuncs = LocalVars or { }, LocalFuncs or { }
	
	if Formula:find("%;") then
		-- Split the string into variables/functions and the actual expression
        local LastSplit = Formula:reverse( ):find( ";" )
		
		local Locals
		
        Formula, Locals = Formula:sub( -LastSplit + 1 ), Split( Formula:sub( 1, -LastSplit - 1 ), "%;" )
		-- Iterates through the user defined variables / functions and interpret them
		for a = 1, #Locals do
			
			local Name, Value = Locals[ a ]:match( "(.+)=(.+)" )
			
			if not Name then error( "Invalid local function/variable - " .. Locals[ a ] ) end
			
			local FuncName, Args = Name:match( "(%w+)(%b())" )
			
			if FuncName then
				
				Args = Split( Args:sub( 2, -2 ), "%," )
				
				LocalFuncs[ FuncName ] = { Interpret( Value, LocalVars ), Args }
				
			else
				
				LocalVars[ Name ] = ToNumber( Interpret( Value, LocalVars ), LocalFuncs )
				
			end
			
		end
		
	end
	
	local Result = ToNumber( Interpret( Formula, LocalVars ), LocalFuncs )
	
	return type( Result ) == "number" and Result or error( "Invalid formula - " .. Formula )
	
end