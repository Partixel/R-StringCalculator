return function(Group)
	local Calc = require(script.Parent:Clone())
	
	local OriginalCalc = require(game.ServerStorage.StringCalculator.MainModule:Clone())
	
	local function Test(InFix)
		return Calc(InFix)
	end
	
	local BasicTests = Group:AddGroup{
		Name = "Basics",
		Async = true,
	}
	BasicTests:AddTest{
		Name = "Number",
		Function = Test,
		Args = {"5"},
		ExpectedResult = function(self, Result)
			return Result == OriginalCalc(self.Args[1]), "Expected " .. OriginalCalc(self.Args[1]) .. "\nGot " .. Result
		end,
		FailMsg = "Expected %Expected%",
		Async = true,
	}
	BasicTests:AddTest{
		Name = "Double digits",
		Function = Test,
		Args = {"15"},
		ExpectedResult = function(self, Result)
			return Result == OriginalCalc(self.Args[1]), "Expected " .. OriginalCalc(self.Args[1]) .. "\nGot " .. Result
		end,
		FailMsg = "Expected %Expected%",
		Async = true,
	}
	BasicTests:AddTest{
		Name = "Decimal",
		Function = Test,
		Args = {"15.5"},
		ExpectedResult = function(self, Result)
			return Result == OriginalCalc(self.Args[1]), "Expected " .. OriginalCalc(self.Args[1]) .. "\nGot " .. Result
		end,
		FailMsg = "Expected %Expected%",
		Async = true,
	}
	BasicTests:AddTest{
		Name = "Negative",
		Function = Test,
		Args = {"-15.5"},
		ExpectedResult = function(self, Result)
			return Result == OriginalCalc(self.Args[1]), "Expected " .. OriginalCalc(self.Args[1]) .. "\nGot " .. Result
		end,
		FailMsg = "Expected %Expected%",
		Async = true,
	}
	BasicTests:AddTest{
		Name = "Plus",
		Function = Test,
		Args = {"2+3"},
		ExpectedResult = function(self, Result)
			return Result == OriginalCalc(self.Args[1]), "Expected " .. OriginalCalc(self.Args[1]) .. "\nGot " .. Result
		end,
		FailMsg = "Expected %Expected%",
		Async = true,
	}
	BasicTests:AddTest{
		Name = "Minus",
		Function = Test,
		Args = {"2-3"},
		ExpectedResult = function(self, Result)
			return Result == OriginalCalc(self.Args[1]), "Expected " .. OriginalCalc(self.Args[1]) .. "\nGot " .. Result
		end,
		FailMsg = "Expected %Expected%",
		Async = true,
	}
	BasicTests:AddTest{
		Name = "Multiply",
		Function = Test,
		Args = {"2*3"},
		ExpectedResult = function(self, Result)
			return Result == OriginalCalc(self.Args[1]), "Expected " .. OriginalCalc(self.Args[1]) .. "\nGot " .. Result
		end,
		FailMsg = "Expected %Expected%",
		Async = true,
	}
	BasicTests:AddTest{
		Name = "Divide",
		Function = Test,
		Args = {"2/3"},
		ExpectedResult = function(self, Result)
			return Result == OriginalCalc(self.Args[1]), "Expected " .. OriginalCalc(self.Args[1]) .. "\nGot " .. Result
		end,
		FailMsg = "Expected %Expected%",
		Async = true,
	}
	BasicTests:AddTest{
		Name = "Modulus",
		Function = Test,
		Args = {"2%3"},
		ExpectedResult = function(self, Result)
			return Result == OriginalCalc(self.Args[1]), "Expected " .. OriginalCalc(self.Args[1]) .. "\nGot " .. Result
		end,
		FailMsg = "Expected %Expected%",
		Async = true,
	}
	BasicTests:AddTest{
		Name = "Exponent",
		Function = Test,
		Args = {"2^3"},
		ExpectedResult = function(self, Result)
			return Result == OriginalCalc(self.Args[1]), "Expected " .. OriginalCalc(self.Args[1]) .. "\nGot " .. Result
		end,
		FailMsg = "Expected %Expected%",
		Async = true,
	}
	BasicTests:AddTest{
		Name = "Factorial",
		Function = Test,
		Args = {"3!"},
		ExpectedResult = function(self, Result)
			return Result == OriginalCalc(self.Args[1]), "Expected " .. OriginalCalc(self.Args[1]) .. "\nGot " .. Result
		end,
		FailMsg = "Expected %Expected%",
		Async = true,
	}
	
	local NegativeTests = Group:AddGroup{
		Name = "Negatives",
		Async = true,
	}
	NegativeTests:AddTest{
		Name = "Negative Number at Start",
		Function = Test,
		Args = {"-2+5"},
		ExpectedResult = function(self, Result)
			return Result == OriginalCalc(self.Args[1]), "Expected " .. OriginalCalc(self.Args[1]) .. "\nGot " .. Result
		end,
		FailMsg = "Expected %Expected%",
		Async = true,
	}
	NegativeTests:AddTest{
		Name = "Negative Number after Bracket",
		Function = Test,
		Args = {"2+(-3+3)"},
		ExpectedResult = function(self, Result)
			return Result == OriginalCalc(self.Args[1]), "Expected " .. OriginalCalc(self.Args[1]) .. "\nGot " .. Result
		end,
		FailMsg = "Expected %Expected%",
		Async = true,
	}
	NegativeTests:AddTest{
		Name = "Negative Number after Operator",
		Function = Test,
		Args = {"2+-2"},
		ExpectedResult = function(self, Result)
			return Result == OriginalCalc(self.Args[1]), "Expected " .. OriginalCalc(self.Args[1]) .. "\nGot " .. Result
		end,
		FailMsg = "Expected %Expected%",
		Async = true,
	}
	
	local OrderTests = Group:AddGroup{
		Name = "Order",
		Async = true,
	}
	OrderTests:AddTest{
		Name = "Exponent Order",
		Function = Test,
		Args = {"2^2^3"},
		ExpectedResult = function(self, Result)
			return Result == OriginalCalc(self.Args[1]), "Expected " .. OriginalCalc(self.Args[1]) .. "\nGot " .. Result
		end,
		FailMsg = "Expected %Expected%",
		Async = true,
	}
	OrderTests:AddTest{
		Name = "Unary Order",
		Function = Test,
		Args = {"-2^2"},
		ExpectedResult = function(self, Result)
			return Result == OriginalCalc(self.Args[1]), "Expected " .. OriginalCalc(self.Args[1]) .. "\nGot " .. Result
		end,
		FailMsg = "Expected %Expected%",
		Async = true,
	}
	OrderTests:AddTest{
		Name = "Basic Order",
		Function = Test,
		Args = {"1+2-3*4+8/4"},
		ExpectedResult = function(self, Result)
			return Result == OriginalCalc(self.Args[1]), "Expected " .. OriginalCalc(self.Args[1]) .. "\nGot " .. Result
		end,
		FailMsg = "Expected %Expected%",
		Async = true,
	}
	OrderTests:AddTest{
		Name = "Equal Priority Order",
		Function = Test,
		Args = {"2+3-2"},
		ExpectedResult = function(self, Result)
			return Result == OriginalCalc(self.Args[1]), "Expected " .. OriginalCalc(self.Args[1]) .. "\nGot " .. Result
		end,
		FailMsg = "Expected %Expected%",
		Async = true,
	}
	OrderTests:AddTest{
		Name = "Factorial Order",
		Function = Test,
		Args = {"2-3!+3"},
		ExpectedResult = function(self, Result)
			return Result == OriginalCalc(self.Args[1]), "Expected " .. OriginalCalc(self.Args[1]) .. "\nGot " .. Result
		end,
		FailMsg = "Expected %Expected%",
		Async = true,
	}
	OrderTests:AddTest{
		Name = "Factorial and Exponent Order",
		Function = Test,
		Args = {"2-3!^2"},
		ExpectedResult = function(self, Result)
			return Result == OriginalCalc(self.Args[1]), "Expected " .. OriginalCalc(self.Args[1]) .. "\nGot " .. Result
		end,
		FailMsg = "Expected %Expected%",
		Async = true,
	}
	OrderTests:AddTest{
		Name = "Factorial and Brackets Order",
		Function = Test,
		Args = {"(3+2)!^2"},
		ExpectedResult = function(self, Result)
			return Result == OriginalCalc(self.Args[1]), "Expected " .. OriginalCalc(self.Args[1]) .. "\nGot " .. Result
		end,
		FailMsg = "Expected %Expected%",
		Async = true,
	}
	OrderTests:AddTest{
		Name = "Factorial and Brackets Order 2",
		Function = Test,
		Args = {"(3+2!)^2"},
		ExpectedResult = function(self, Result)
			return Result == OriginalCalc(self.Args[1]), "Expected " .. OriginalCalc(self.Args[1]) .. "\nGot " .. Result
		end,
		FailMsg = "Expected %Expected%",
		Async = true,
	}
	
	local FunctionTests = Group:AddGroup{
		Name = "Functions",
		Async = true,
	}
	FunctionTests:AddTest{
		Name = "Clamp Low",
		Function = Test,
		Args = {"clamp(2*2, 5+1, 10*(3+2))"},
		ExpectedResult = function(self, Result)
			return Result == OriginalCalc(self.Args[1]), "Expected " .. OriginalCalc(self.Args[1]) .. "\nGot " .. Result
		end,
		FailMsg = "Expected %Expected%",
		Async = true,
	}
	FunctionTests:AddTest{
		Name = "Clamp High",
		Function = Test,
		Args = {"clamp(26*2, 5+1, 10*(3+2))"},
		ExpectedResult = function(self, Result)
			return Result == OriginalCalc(self.Args[1]), "Expected " .. OriginalCalc(self.Args[1]) .. "\nGot " .. Result
		end,
		FailMsg = "Expected %Expected%",
		Async = true,
	}
	FunctionTests:AddTest{
		Name = "No Clamp",
		Function = Test,
		Args = {"clamp(3*2, 5+1, 10*(3+2))"},
		ExpectedResult = function(self, Result)
			return Result == OriginalCalc(self.Args[1]), "Expected " .. OriginalCalc(self.Args[1]) .. "\nGot " .. Result
		end,
		FailMsg = "Expected %Expected%",
		Async = true,
	}
	FunctionTests:AddTest{
		Name = "Random",
		Function = Test,
		Args = {"random(1, 5)"},
		ExpectedResult = function(self, Result)
			return type(Result) == "number" and Result >= 1 and Result <= 5, "Expected random number between 1 and 5\nGot " .. Result
		end,
		FailMsg = "Expected %Expected%",
		Async = true,
	}
	FunctionTests:AddTest{
		Name = "Local",
		Function = Test,
		Args = {"x(a,b)=a*b; x(2, 3*22)"},
		ExpectedResult = function(self, Result)
			return Result == OriginalCalc(self.Args[1]), "Expected " .. OriginalCalc(self.Args[1]) .. "\nGot " .. Result
		end,
		FailMsg = "Expected %Expected%",
		Async = true,
	}
	FunctionTests:AddTest{
		Name = "Lua",
		Function = Test,
		Args = {"truncate(5.555, 2)"},
		ExpectedResult = function(self, Result)
			return Result == OriginalCalc(self.Args[1]), "Expected " .. OriginalCalc(self.Args[1]) .. "\nGot " .. Result
		end,
		FailMsg = "Expected %Expected%",
		Async = true,
	}
	
	
	local ErrorTests = Group:AddGroup{
		Name = "Errors",
		Async = true,
	}
	ErrorTests:AddTest{
		Name = "Unclosed bracket",
		Function = Test,
		Args = {"3+(3*5"},
		ExpectedError = function(self, Error, Trace)
			local ExpectedError = "Unclosed bracket  - (3*5"
			if Error:reverse():sub(1, #ExpectedError):reverse() ~= ExpectedError then
				return false, "Incorrect error message - "  .. Error .. "\n" .. Trace
			end
		end,
		FailMsg = "Didn't error when calculating a formula that had an unclosed bracket",
		Async = true,
	}
	ErrorTests:AddTest{
		Name = "Unknown variable",
		Function = Test,
		Args = {"3+a"},
		ExpectedError = function(self, Error, Trace)
			local ExpectedError = "Unknown variable(s)/function(s) - a"
			if Error:reverse():sub(1, #ExpectedError):reverse() ~= ExpectedError then
				return false, "Incorrect error message - "  .. Error .. "\n" .. Trace
			end
		end,
		FailMsg = "Didn't error when calculating a formula that had an unknown variable",
		Async = true,
	}
	ErrorTests:AddTest{
		Name = "Unknown function",
		Function = Test,
		Args = {"3+a(5)"},
		ExpectedError = function(self, Error, Trace)
			local ExpectedError = "Unknown variable(s)/function(s) - a"
			if Error:reverse():sub(1, #ExpectedError):reverse() ~= ExpectedError then
				return false, "Incorrect error message - "  .. Error .. "\n" .. Trace
			end
		end,
		FailMsg = "Didn't error when calculating a formula that had an unknown variable",
		Async = true,
	}
	ErrorTests:AddTest{
		Name = "Invalid operator",
		Function = Test,
		Args = {"22$3"},
		ExpectedError = function(self, Error, Trace)
			local ExpectedError = "Invalid operator(s) - $"
			if Error:reverse():sub(1, #ExpectedError):reverse() ~= ExpectedError then
				return false, "Incorrect error message - "  .. Error .. "\n" .. Trace
			end
		end,
		FailMsg = "Didn't error when calculating a formula that had an invalid operator",
		Async = true,
	}
	ErrorTests:AddTest{
		Name = "No operator between numbers",
		Function = Test,
		Args = {"(5)2"},
		ExpectedError = function(self, Error, Trace)
			local ExpectedError = "No operators between numbers - 5 2"
			if Error:reverse():sub(1, #ExpectedError):reverse() ~= ExpectedError then
				return false, "Incorrect error message - "  .. Error .. "\n" .. Trace
			end
		end,
		FailMsg = "Didn't error when calculating a formula that had no operator between two numbers",
		Async = true,
	}
	ErrorTests:AddTest{
		Name = "Unused arguments",
		Function = Test,
		Args = {"(5, 2)"},
		ExpectedError = function(self, Error, Trace)
			local ExpectedError = "No operators between numbers - 5 2"
			if Error:reverse():sub(1, #ExpectedError):reverse() ~= ExpectedError then
				return false, "Incorrect error message - "  .. Error .. "\n" .. Trace
			end
		end,
		FailMsg = "Didn't error when calculating a formula that had two unused arguments",
		Async = true,
	}
	ErrorTests:AddTest{
		Name = "Error in local variable",
		Function = Test,
		Args = {"a=(5+2;a"},
		ExpectedError = function(self, Error, Trace)
			local ExpectedError = [[Local variable a could not be calculated
Unclosed bracket  - (5+2]]
			if Error:reverse():sub(1, #ExpectedError):reverse() ~= ExpectedError then
				return false, "Incorrect error message - "  .. Error .. "\n" .. Trace
			end
		end,
		FailMsg = "Didn't error when calculating a formula that had an error when interpreting a local variable",
		Async = true,
	}
	ErrorTests:AddTest{
		Name = "Incorrect local variable/function",
		Function = Test,
		Args = {"5+2;"},
		ExpectedError = function(self, Error, Trace)
			local ExpectedError = "Invalid local function/variable - 5+2"
			if Error:reverse():sub(1, #ExpectedError):reverse() ~= ExpectedError then
				return false, "Incorrect error message - "  .. Error .. "\n" .. Trace
			end
		end,
		FailMsg = "Didn't error when calculating a formula that had an invalid variable/function",
		Async = true,
	}
	
	Group:AddTest{
		Name = "Complex",
		Function = Test,
		Args = {"((1001+(9/3.5)-5!/(3*4.3333-5))^2+55.2)%2+((1001+(9/3.5)-5!/(3*4.3333-5))^2+55.2)%3"},
		ExpectedResult = function(self, Result)
			return Result == OriginalCalc(self.Args[1]), "Expected " .. OriginalCalc(self.Args[1]) .. "\nGot " .. Result
		end,
		FailMsg = "Expected %Expected%",
		Async = true,
	}
end