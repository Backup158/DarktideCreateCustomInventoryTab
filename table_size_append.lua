local table = {
  "tomato",
  "tomatoo",
  "tomatooo",
}

local function print_table (given_table)
  print("Size: "..tostring(#given_table)) 
  for key, value in pairs(given_table) do
    print("    "..tostring(key).." : "..tostring(value))
  end
  print("-----------------------------")
end

-- #####################################
-- Execution
-- #####################################
print("Initial Table")
print_table(table)

print("Inserting at +2 manually")
table[5] = "tomatooooo"
print_table(table)

print("Inserting at +2 based on size")
table[#table+2] = "tomat2"
print_table(table)
print("So it looks like size is based on just the contiguous keys\n")

print("Inserting at +1 based on size")
table[#table+1] = "tomatoooo"
print_table(table)
print("Since there was already one at 5, adding at 4 connects it to the rest of the chain\n")