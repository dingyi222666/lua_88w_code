local function foreachTab(dslTable, file)
    for _, v in pairs(dslTable) do
        local valueType = type(v)

        if valueType == "string" then
            file:write(v)
            file:write("\n")
        else if valueType == "table" then
                foreachTab(v, file)
            end
        end
    end
end

local function create(dslTable)
    local file = io.open("out.cpp", "w+")

    foreachTab(dslTable, file)

    file:close()
end

local function cppHead()
    return {
        "#include <iostream>",
        "using namespace std;",
        "",
    }
end

local function map(fun, tab)
    for k, v in pairs(tab) do
        tab[k] = fun(v, k)
    end
    return setmetatable(tab, { __index = tab })
end

local function range(start_, end_, step)
    step = step or 1
    local result = {}
    for i = start_, end_, step do
        table.insert(result, i)
    end

    return result
end

local function space(size)
    return (" "):rep(size)
end

local function mainFunction(tab)
    return {
        "int main()",
        "{",
        space(4) .. "cout << \"请给出一个不多于五位数的正整数\";",
        space(4) .. "int x;",
        space(4) .. "cin >> x;",
        "",
        "",
        tab,
        "}"
    }
end

local digitTemp = {"个","十","百","千","万"}

local function cppPrint(message)
    return "cout << \""..message.."\" << endl;"
end

local function printNumberInfo(i)
    local result = {}
    local str = tostring(i)
    local reversed = str:reverse()
    table.insert(result,space(6)..cppPrint("是"..#str.."位数"))

    for i=1,#str do
        table.insert(result,space(6)..cppPrint(
            digitTemp[i].."位数是:"..str:sub(i,i)))
    end

    table.insert(result,space(6)..cppPrint("倒过来是"..reversed))

    return result

end

local function case(i)
    return {
        space(4).."case "..i.." :",
        printNumberInfo(i),
        space(6).."break;"
    }
end

local function switch(rangeTable)
    return {
        space(4).."switch(x) {",
        map(case,rangeTable),
        space(4).."};"
    }
end

create {
    cppHead(),
    mainFunction(
        switch(
            range(1,99999)
        )
    )
}

