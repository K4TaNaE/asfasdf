if not game:IsLoaded() then
  game.Loaded:Wait()
end
task.wait() 
print("Due to optimization color output is disabled.")
local getupvalue = getupvalue or debug.getupvalue 
local getgenv = getgenv or (syn and syn.getgenv) or function() return _G end
local request = request or (syn and syn.request) or http_request or http and http.request
local makefolder = makefolder or (syn and syn.makefolder)
local isfile = isfile or (syn and syn.isfile)
local writefile = writefile or (syn and syn.writefile)
local getcustomasset = getcustomasset or (syn and syn.getcustomasset)
local LocalPlayer = game:GetService("Players").LocalPlayer
local gethui = gethui or get_hui or (syn and syn.gethui) or function(...) return LocalPlayer.PlayerGui end
local HttpService = game:GetService("HttpService")
local bool_folder, res_folder = pcall(makefolder, "Arcanic")
_G.asset = nil
if bool_folder then
	local bool_file, res_file = pcall(isfile, "Arcanic/arcsrcplate.png")
	if bool_file then
		if res_file then
			local bool_asset, res_asset = pcall(getcustomasset, "Arcanic/arcsrcplate.png")
				if bool_asset then
					_G.asset = res_asset
				else
					print("getcustomasset function is not supported by executor.")
				end
		else
			local bool_wfile, res_wfile = pcall(writefile, "Arcanic/arcsrcplate.png", game:HttpGet("https://i.imageupload.app/6e3c4149ad8bfdfb4eee.png"))
			if bool_wfile then
				local bool_asset, res_asset = pcall(getcustomasset, "Arcanic/arcsrcplate.png")
				if bool_asset then
					_G.asset = res_asset
				else
					print("getcustomasset function is not supported by executor.")
				end
			else
				print("writefile function is not supported by executor.")
			end
		end
	else
		print("isfile function is not supported by executor.")
	end
else 
	print("makefolder function is not supported by executor.")
end
local RunService = game:GetService("RunService")
local NetworkClient = game:GetService("NetworkClient")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local Stats = game:GetService("Stats")
local API = ReplicatedStorage.API
local loader = require(ReplicatedStorage:WaitForChild("Fsys")).load
local UIManager = loader("UIManager")
local ClientData = loader("ClientData")
local InventoryDB = loader("InventoryDB")
local PetEntityManager = loader("PetEntityManager")
local InteriorsM = loader("InteriorsM")
local HouseClient = loader("HouseClient")
local PetActions = loader("PetActions")
local StateManagerClient = loader("StateManagerClient")
local AilmentsDB = require(ReplicatedStorage.new.modules.Ailments.AilmentsDB)
local LiveOpsTime = loader("LiveOpsTime")
local StateDB = {
  total_fullgrowned = {},
}
local actual_pet = {
  unique = false,
  remote = false,
  model = false,
  wrapper = false,
  is_egg = false,
}
local farmed = {
  money = 0,
  pets_fullgrown = 0,
  ailments = 0,
  potions = 0,
  friendship_levels = 0,
  event_currency = 0,
  baby_ailments = 0,
  eggs_hatched = 0,
}
local Cooldown = {
  init_autofarm = 0,
  init_baby_autofarm = 0,
  init_lurebox_farm = 0,
  watchdog = 0,
  webhook_send_delay = 3600
}
formatted_pet = {
  ["camping"] = "🏕️ Task [camping] detected for:",
  ["hungry"] = "🍔 Task [hungry] detected for:",
  ["thirsty"] = "🍼 Task [thirsty] detected for:",
  ["sick"] = "💊 Task [sick] detected for:",
  ["bored"] = "🛝 Task [bored] detected for:",
  ["salon"] = "✂️ Task [salon] detected for:",
  ["play"] = "🏓 Task [play] detected for:",
  ["toilet"] = "🚽 Task [toilet] detected for:",
  ["beach_party"] = "🏖️ Task [beach-party] detected for:",
  ["ride"] = "🏎️ Task [ride] detected for:",
  ["dirty"] = "🚿 Task [dirty] detected for:",
  ["walk"] = "🥾 Task [walk] detected for:",
  ["school"] = "🏫 Task [school] detected for:",
  ["sleepy"] = "🛏️ Task [sleepy] detected for:",
  ["mystery"] = "❓ Task [mystery] detected for:",
  ["pizza_party"] = "🍕 Task [pizza-party] detected for:",
  ["pet_me"] = "🫳 Task [pet-me] detected for:"
}
formatted_baby = {
  ["camping"] = "🏕️ Task [camping] detected for baby!",
  ["hungry"] = "🍔 Task [hungry] detected for baby!",
  ["thirsty"] = "🍼 Task [thirsty] detected for baby!",
  ["sick"] = "💊 Task [sick] detected for baby!",
  ["bored"] = "🛝 Task [bored] detected for baby!",
  ["salon"] = "✂️ Task [salon] detected for baby!", 
  ["beach_party"] = "🏖️ Task [beach-party] detected for baby!",
  ["dirty"] = "🚿 Task [dirty] detected for baby!",
  ["school"] = "🏫 Task [school] detected for baby!",
  ["sleepy"] = "🛏️ Task [sleepy] detected for baby!",
  ["pizza_party"] = "🍕 Task [pizza-party] detected for baby!",
}
local Rarities = {
  [1] = "common",
  [2] = "uncommon",
  [3] = "rare",
  [4] = "ultra_rare",
  [5] = "legendary",
}
Recycler_values = {
  base_values = {
	legendary = 900,
	ultra_rare = 300,
	common = 100,
	uncommon = 125,
	rare = 150,
  },
  age_multipliers = {
	[1] = 0.9,
	[2] = 1,
	[3] = 1.5,
	[4] = 2,
	[5] = 3,
	[6] = 5,
  },
  property_bonuses = {
	rideable = 150,
	flyable = 300
  },
  extremely_rare_chase_pet = "pet_recycler_2025_giant_panda",
  eggs_to_exclude = {
	retired_egg = true
  },
  non_tradeable_multiplier = 0.5,
  max_pets_to_show = 10,
}
local parts = {
  ["main"] = {0,100,0},
  ["_camp"] = {-25, 30, -1054},
  ["_playground"] = {-387, 31, -1750},
  ["_beach"] = {-670, 37, -1413},
}
local furn = {}
_G.potionfarm = false
_G.InternalConfig = {}
CONNECTIONS = {}
_G.Looping = {}
CLEANUP_INSTANCES = {}
_G.HeadCashed = nil
_G.mystery = false
local function init_part(name, xyz) 
  if game.Workspace:FindFirstChild(name) then return end
  local main = Instance.new("Part")
  main.Size = Vector3.new(150, 1, 150)
  main.Position = Vector3.new(table.unpack(xyz))
  main.Anchored = true
  main.Name = name
  main.Parent = workspace
  local gui = Instance.new("SurfaceGui")
  gui.Face = Enum.NormalId.Top
  gui.Parent = main
  local img = Instance.new("ImageLabel")
  img.Size = UDim2.new(1, 0, 1, 0)
  img.BackgroundTransparency=  1
  img.Image = _G.asset
  img.Parent = gui
end
local function safeInvoke(api, ...)
  local args = { ... }
  local ok, res = pcall(function() return API[api]:InvokeServer(table.unpack(args)) end)
  return ok, res
end
local function safeFire(api, ...)
  local args = { ... }
  local ok = pcall(function() API[api]:FireServer(table.unpack(args)) end)
  return ok	
end
local function equiped() 
  return ClientData.get("pet_char_wrappers")[1]
end
local function addConnection(name, conn) 
  CONNECTIONS[name] = conn 
  return conn 
end
local function gotopart(name) 
  local part = game.Workspace:FindFirstChild(name)
  if not part then
  	init_part(name, parts[name])
  	LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(part.Position + Vector3.new(0, 5, 0))
  	return
  end
  if actual_pet.unique and actual_pet.wrapper and equiped() then
  	PetActions.pick_up(actual_pet.wrapper)
  	LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(part.Position + Vector3.new(0, 5, 0))
  	task.wait(0.3)
  	if actual_pet.model then
  	  safeFire("AdoptAPI/EjectBaby", actual_pet.model)
  	end
  	return true
  end
  LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(part.Position + Vector3.new(0, 5, 0))
end
local function get_current_location()
  return InteriorsM.get_current_location()["destination_id"]
end 	
local function emulate_location(dest, house_owner, subdest)	
  safeFire("LocationAPI/SetLocation", dest, house_owner or LocalPlayer, subdest)
end
local function get_equiped_model() 
  local model
  for _, v in ipairs(workspace.Pets:GetChildren()) do
  	local entity = PetEntityManager.get_pet_entity(v)
  	if entity and entity.session_memory and entity.session_memory.meta.owned_by_local_player then
  	  model = v
  	  break
  	end
  end
  return model
end
local function cur_unique()
  local w = ClientData.get("pet_char_wrappers")[1]
  return w and w.pet_unique
end
local function get_owned_pets()
  local inv = ClientData.get("inventory")
  local pets = inv and inv.pets
  if not pets then return {} end
  local result = {}
  for unique,v in pairs(pets) do
    local info = InventoryDB.pets[v.id]
	if info then
	  result[unique] = {
	  remote = v.id,
	  age = v.properties.age,
	  friendship = v.properties.friendship_level,
	  name = info.name,
	  rarity = info.rarity,
	  neon = v.properties.neon or false,
	  mega_neon = v.properties.mega_neon or false,
	  rideable = v.properties.rideable or false,
	  flyable = v.properties.flyable or false
	  }
	end
  end
  return result
end
local function get_owned_eggs()
  local inv = ClientData.get("inventory")
  local pets = inv and inv.pets
  if not pets then return {} end
  local result = {}
  for unique,v in pairs(pets) do 
	local info = InventoryDB.pets[v.id]
	if (info.name:lower()):match("egg") then
	  result[unique] = true
	end
  end
  return result
end
local function init_furniture() 
  if get_current_location() ~= "housing" then
  	InteriorsM.enter("housing", "MainDoor", { house_owner = LocalPlayer })
  	task.wait(.8)
  end
  local furniture = {}
  local filter = {
  	bed = true,
  	crib = true,
  	shower = true,
  	toilet = true,
  	tub = true,
  	litter = true,
  	potty = true,
  	lures2023normallure = true
  }
  for _, v in ipairs(game.Workspace.HouseInteriors.furniture:GetDescendants()) do
  	if v:IsA("Model") then
  	  local name = v.Name:lower()
  	  for key in pairs(filter) do
  	  	if name:find(key) then
  	  	  local part = v:FindFirstChild("UseBlocks")
      	  	if part then
  	  	  	part = part:FindFirstChildWhichIsA("Part")
      	  	  if part then
  	  	  	  furniture[name] = part
  	  	  	end
  	  	  end
  	  	end
  	  end
  	end
  end
  for k,v in pairs(ClientData.get("house_interior")['furniture']) do
  	local id = v.id:lower():gsub("_", "")
  	local part = furniture[id]
  	if part then
  	  if id:find("bed") or id:find("crib") then 
  	  	furn.bed = {
  	  	  id=v.id,
  	  	  unique=k,
  	  	  usepart=part.Name,
  	  	}
  	  elseif id:find("shower") or id:find("bathtub") or id:find("tub") then
  	  	furn.bath = {
  	  	  id=v.id,
  	  	  unique=k,
  	  	  usepart=part.Name,
  	  	}
  	  elseif id:find("litter") or id:find("potty") or id:find("toilet") then
  	  	furn.toilet = {
  	  	  id=v.id,
  	  	  unique=k,
  	  	  usepart=part.Name,
  	  	}
  	  elseif id:find("lures2023normallure") then
  	  	furn.lurebox = {
  	  	  id=v.id,
  	  	  unique=k,
  	  	  usepart=part.name,
  	  	}
  	  end
  	end
  	if furn.bed and furn.bath and furn.toilet and furn.lurebox then break end
  end
  if not furn.bed then
  	safeInvoke("HousingAPI/BuyFurnitures",
  	  {
  	  	{
  	  	  kind = "basicbed",
  	  	  properties = {
  	  	    cframe = CFrame.new(11.89990234375, 0, -27.10009765625, 1, -3.8213709303294e-15, 8.7422776573476e-08, 3.8213709303294e-15, 1, 0, -8.7422776573476e-08, 0, 1)
  	  	  }
  	  	}
  	  }
  	)
  	if not furn.bath then
  	  safeInvoke("HousingAPI/BuyFurnitures",
  	  	{
  	  	  {
  	  	  	kind = "cheap_pet_bathtub",
  	  	  	properties = {
  	  	  	  cframe = CFrame.new(31.300048828125, 0, -3.5, 1, -3.8213709303294e-15, 8.7422776573476e-08, 3.8213709303294e-15, 1, 0, -8.7422776573476e-08, 0, 1)
  	  	  	}
  	  	  }
  	  	}
  	  )
  	end
  	if not furn.toilet then
  	  safeInvoke("HousingAPI/BuyFurnitures",
  	  	{
  	  	  {
  	  	  	kind = "ailments_refresh_2024_litter_box",
  	  	  	properties = {
  	  	  	  cframe = CFrame.new(3.199951171875, 0, -24.2998046875, 1, -3.8213709303294e-15, 8.7422776573476e-08, 3.8213709303294e-15, 1, 0, -8.7422776573476e-08, 0, 1)
  	  	  	}
  	  	  }
  	  	}
  	  )
  	end
  	furn.bed = {
  	  id="basicbed",
  	  usepart="Seat1",
  	}
  	furn.bath = {
  	  id="cheap_pet_bathtub",
  	  usepart="UseBlock",
  	}
  	furn.toilet = {
  	  id="ailments_refresh_2024_litter_box",
  	  usepart="Seat1",
  	}	
  	furn.lurebox = {
  	  id="lures_2033_normal_lure",
  	  usepart="UseBlock",
  	}
  	task.wait(.8)
  	for k,v in pairs(ClientData.get("house_interior")['furniture']) do
  	  if not furn.bed.unique and v.id == "basicbed" then
  	  	furn.bed.unique = k
  	  end
  	  if not furn.bath.unique and v.id == "cheap_pet_bathtub" then
  	  	furn.bath.unique = k
  	  end
  	  if not furn.toilet.unique and v.id == "ailments_refresh_2024_litter_box" then
  	  	furn.toilet.unique = k
  	  end
  	  if not furn.lurebox.unique and v.id == "lures_2033_normal_lure" then
  	  	furn.lurebox.unique = k
  	  end
  	end	
  end
  print("🪑 Furniture init done!")
  gotopart("main")
end
local function get_equiped_pet_ailments() 
  local ailments = {}
  if actual_pet.unique then
  	local path = ClientData.get("ailments_manager")["ailments"][actual_pet.unique]
  	if not path then return {} end
  	for k,_ in pairs(path) do
  	  ailments[k] = true
  	end
  end
  return ailments 
end
local function has_ailment(ailment) 
  local ail = ClientData.get("ailments_manager")["ailments"][actual_pet.unique]
  return ail and ail[ailment] ~= nil
end
local function has_ailment_baby(ailment) 
  local ail = ClientData.get("ailments_manager")["baby_ailments"]
  return ail and ail[ailment] ~= nil
end	
local function get_baby_ailments() 
  local ailments = {}
  for k, _ in pairs(ClientData.get("ailments_manager")["baby_ailments"]) do
    ailments[k] = true
  end 
  return ailments 
end
local function inv_get_category_unique(category, remote)
  local inv = ClientData.get("inventory")
  local cat = inv and inv[category]
  if not cat then return nil end
  for unique, v in pairs(cat) do
  	if v.id == remote then
  	  return unique
  	end
  end
end
local function check_pet_owned(remote)
  local inv = ClientData.get("inventory")
  local pets = inv and inv.pets
  if not pets then return false end
  if pets[inv_get_category_unique("pets", remote)] then
  	return true
  end
  return false
end   
local function count_of_product(category, remote)
  local inv = ClientData.get("inventory")
  local cat = inv and inv[category]
  if not cat then return 0 end
  local count = 0
  for _, v in pairs(cat) do
  	if v.id == remote then
  	  count += 1
  	end
  end
  return count
end
local function count(t)
  local n = 0
  for _ in pairs(t) do
  	n +=1 
  end
  return n
end
local function Avatar()
  local success, response = pcall(function()
  	return request({
  	  Url = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds="
  		.. LocalPlayer.UserId
  		.. "&size=420x420&format=Png&isCircular=false",
  	  Method = "GET",
  	})
  end)
  if not success or not response or not response.Body then
  	warn("[-] Failed to fetch avatar.")
  	return
  end
  local decoded
  pcall(function()
  	decoded = HttpService:JSONDecode(response.Body)
  end)
  _G.HeadCashed = decoded.data[1].imageUrl
end
local function webhook(title, description)
  local url = _G.InternalConfig.DiscordWebhookURL
  if not url then return end
  if not _G.HeadCashed then
  	Avatar()
  end
  local payload = {
  	content = nil,
  	embeds = {
  	  {
  	  	title = "`              "..title.."              `",				
  	  	description = description,
  	  	color = 0,
  	  	author = {
  	  	  name = LocalPlayer.Name,
  	  	  url = "https://discord.gg/E8BVmZWnHs",
  	  	  icon_url = _G.HeadCashed or "https://i.imageupload.app/936d8d1617445f2a3fbd.png"
  	  	},
  	  	footer = {
  	      text = os.date("%d.%m.%Y") .. " " .. os.date("%H:%M:%S")
  	  	}
  	  }
  	},
  	username = "Arcanic",
  	avatar_url = "https://i.imageupload.app/936d8d1617445f2a3fbd.png",
  	attachments = {}
  }
  pcall(function()
  	request({
  	  Url = url,
  	  Method = "POST",
  	  Headers = { ["Content-Type"] = "application/json" },
  	  Body = HttpService:JSONEncode(payload)
  	})
  end)
end
local function update_gui(label, val) 
  task.spawn(function()
  	local hui = gethui()
  	local overlay = hui:FindFirstChild("StatsOverlay")
  	if not overlay then print("overlay", overlay) return end
  	local frame = overlay:FindFirstChild("StatsFrame")
  	if not frame then print("frame", frame) return end
  	local lbl = frame:FindFirstChild(label)
  	if not lbl then print("lbl", lbl) return end
  	local prefix = lbl.Text:match("^[^:]+") or lbl.Name
  	if prefix then
  	  lbl.Text = prefix .. ": " .. val
  	end		
  end)
end  
local function pet_update()
  local wrapper = ClientData.get("pet_char_wrappers")[1]
  local deadline = os.clock() + 2.5
  while not wrapper and deadline > os.clock() do
	task.wait(.2)
  end
  if deadline < os.clock() then
	print("⚙️ Could not find pet model")
	return 
  end
  local unique = wrapper.pet_unique
  local remote = wrapper.pet_id
  local pet_info = InventoryDB.pets[remote]
  local name = pet_info and pet_info.name
  actual_pet.unique = unique 
  actual_pet.remote = remote
  actual_pet.model = get_equiped_model() 
  actual_pet.wrapper = wrapper
  actual_pet.is_egg = (name:lower()):match("egg") ~= nil
end
local function __baby_callbak() 
  farmed.baby_ailments += 1 
  update_gui("baby_needs", farmed.baby_ailments)
end
local function enstat(age, friendship, money, ailment, baby_has_ailment)  
  local deadline = os.clock() + 5
  if money then 
	while money == ClientData.get("money") and os.clock() < deadline do
	  task.wait(.1)
	end
	farmed.money += ClientData.get("money") - money
	update_gui("bucks", farmed.money)
  else
	task.wait(.8)
  end
  if deadline < os.clock() then
	print("Went beyond the deadline")
	return
  end
  if baby_has_ailment and ClientData.get("team") == "Babies" and not has_ailment_baby(ailment) then
  	__baby_callbak()
  end
  if actual_pet.is_egg then
	task.wait(2)
  	if not get_owned_eggs()[actual_pet.unique] then
  	  farmed.eggs_hatched += 1 
  	  farmed.ailments += 1
  	  update_gui("eggs", farmed.eggs_hatched)
  	  update_gui("pet_needs", farmed.ailments)
  	  if not _G.flag_if_no_one_to_farm then 
  	  	actual_pet.unique = false 
  	  else
  	  	pet_update()
  	  	task.wait(.3)
  	  end
  	else
  	  farmed.ailments +=1
  	  update_gui("pet_needs", farmed.ailments)
  	end
  	return
  end
  if age < 6 and ClientData.get("pet_char_wrappers")[1].pet_progression.age == 6 then
    farmed.pets_fullgrown += 1
    update_gui("fullgrown", farmed.pets_fullgrown)
    StateDB.total_fullgrowned[actual_pet.unique] = true
    if not _G.InternalConfig.AutoFarmFilter.PotionFarm then
  	  if not _G.flag_if_no_one_to_farm then
  	    actual_pet.unique = false
  	  end
    end
  end
  if friendship < ClientData.get("inventory").pets[actual_pet.unique].properties.friendship_level then
    farmed.friendship_levels += 1
    farmed.potions += 1
    update_gui("friendship", farmed.friendship_levels)
    update_gui("potions", farmed.potions)
  end
  farmed.ailments += 1
  update_gui("pet_needs", farmed.ailments)
end
local function __pet_callback(age, friendship, ailment) 
  if not _G.InternalConfig.FarmPriority then
  	farmed.ailments += 1
  	update_gui("pet_needs", farmed.ailments) 
  else
  	enstat(age, friendship, nil, ailment)
  end
end
local function enstat_baby(money, ailment, pet_has_ailment, petData) 
  local deadline = os.clock() + 5
  while money == ClientData.get("money") and os.clock() < deadline do
  	task.wait(.1)
  end
  if deadline < os.clock() then
	print("Went beyond the deadline")
	return
  end
  farmed.money += ClientData.get("money") - money 
  farmed.baby_ailments += 1
  if pet_has_ailment and equiped() and not has_ailment(ailment) then
  	__pet_callback(petData[1], petData[2], ailment)
  end
  update_gui("bucks", farmed.money)
  update_gui("baby_needs", farmed.baby_ailments)
end
local pet_ailments = { 
  ["camping"] = function()
    local pet = ClientData.get("pet_char_wrappers")[1]
	local cdata = ClientData.get("inventory").pets[actual_pet.unique]
	local friendship = cdata.properties.friendship_level
	local money = ClientData.get("money")
	local age = pet.pet_progression.age
	local baby_has_ailment = has_ailment_baby("camping")
	gotopart("_camp")
    emulate_location("MainMap", LocalPlayer, "Default")  
	local deadline = os.clock() + 60
	repeat 
      task.wait(1)
    until not has_ailment("camping") or os.clock() > deadline  
	if os.clock() > deadline then 
	  print(string.format("🟥 Task camping for %s - Out of limits!", actual_pet.remote)) 
	  return
    end        
	gotopart("main")
    print(string.format("🟩 Task camping for %s - done!", actual_pet.remote)) 
	enstat(age, friendship, money, "camping", baby_has_ailment)
 end,
 ["hungry"] = function() 
	local pet = ClientData.get("pet_char_wrappers")[1]
	local cdata = ClientData.get("inventory").pets[actual_pet.unique]
	local friendship = cdata.properties.friendship_level
	local money = ClientData.get("money")
	local age = pet.pet_progression.age
	if count_of_product("food", "apple") == 0 then
	  if money == 0 then 
		print("⚠️ No money to buy food!") 
		return
	  end
	  if money > 20 then
		safeInvoke("ShopAPI/BuyItem",
		  "food",
		  "apple",
		  {
		 	buy_count = 20
		  }
		)
	  else
		safeInvoke("ShopAPI/BuyItem",
		  "food",
		  "apple",
		  {
		 	buy_count = money / 2
		  }
		)
	  end
	end
	local deadline = os.clock() + 10
	local money = ClientData.get("money")
	safeInvoke("PetObjectAPI/CreatePetObject",
	  "__Enum_PetObjectCreatorType_2",
	  {
		additional_consume_uniques={},
		pet_unique = actual_pet.unique,
		unique_id = inv_get_category_unique("food", "apple")
	  }
	)
	repeat 
	  task.wait(1)
	until not has_ailment("hungry") or os.clock() > deadline
	if os.clock() > deadline then 
	  print(string.format("🟥 Task hungry for %s - Out of limits!", actual_pet.remote)) 
	  return		
	end        
	print(string.format("🟩 Task hungry for %s - done!", actual_pet.remote)) 
	enstat(age, friendship, money, "hungry")  
  end,
  ["thirsty"] = function() 
	local pet = ClientData.get("pet_char_wrappers")[1]
	local cdata = ClientData.get("inventory").pets[actual_pet.unique]
	local friendship = cdata.properties.friendship_level
	local money = ClientData.get("money")
	local age = pet.pet_progression.age
	if count_of_product("food", "water") == 0 then
	  if money == 0 then 
		print("⚠️ No money to buy food.") 
		return
	  end
	  if money > 20 then
		safeInvoke("ShopAPI/BuyItem",
	   	  "food",
		  "water",
		  {
		 	buy_count = 20
		  }
		)
	  else 
		safeInvoke("ShopAPI/BuyItem",
		  "food",
		  "water",
		  {
		 	buy_count = money / 2
		  }
		)
	  end
	end
	local deadline = os.clock() + 10
	local money = ClientData.get("money")
	safeInvoke("PetObjectAPI/CreatePetObject",
	  "__Enum_PetObjectCreatorType_2",
	  {
		additional_consume_uniques={},
		pet_unique = actual_pet.unique,
		unique_id = inv_get_category_unique("food", "water")
	  }
	)
	repeat 
 	  task.wait(1)
	until not has_ailment("thirsty") or os.clock() > deadline
	if os.clock() > deadline then 
	  print(string.format("🟥 Task thirsty for %s - Out of limits!", actual_pet.remote)) 
	  return		
	end            	
	print(string.format("🟩 Task thirsty for %s - done!", actual_pet.remote)) 
	enstat(age, friendship, money, "thirsty")  
  end,
  ["sick"] = function() 
	local pet = ClientData.get("pet_char_wrappers")[1]
	local cdata = ClientData.get("inventory").pets[actual_pet.unique]
	local friendship = cdata.properties.friendship_level
	local money = ClientData.get("money")
	local age = pet.pet_progression.age
	local baby_has_ailment = has_ailment_baby("sick")
	emulate_location("Hospital")
	safeInvoke("HousingAPI/ActivateInteriorFurniture",
	  "f-14",
	  "UseBlock",
	  "Yes",
	  LocalPlayer.Character
	)
	task.wait(.85)
	print(string.format("🟩 Task sick for %s - done!", actual_pet.remote)) 
	enstat(age, friendship, money, "sick", baby_has_ailment)
  end,
  ["bored"] = function() 
	local pet = ClientData.get("pet_char_wrappers")[1]
	local cdata = ClientData.get("inventory").pets[actual_pet.unique]
	local friendship = cdata.properties.friendship_level
	local money = ClientData.get("money")
	local age = pet.pet_progression.age
	local baby_has_ailment = has_ailment_baby("bored")
	gotopart("_playground")
	emulate_location("MainMap", LocalPlayer, "Default")
	local deadline = os.clock() + 60
	repeat 
	  task.wait(1)
	until not has_ailment("bored") or os.clock() > deadline
	if os.clock() > deadline then 
	  print(string.format("🟥 Task bored for %s - Out of limits!", actual_pet.remote)) 
	  return		
	end        
	gotopart("main")
	print(string.format("🟩 Task bored for %s - done!", actual_pet.remote)) 
	enstat(age, friendship, money, "bored", baby_has_ailment)  
  end,
  ["salon"] = function() 
	local pet = ClientData.get("pet_char_wrappers")[1]
	local cdata = ClientData.get("inventory").pets[actual_pet.unique]
	local friendship = cdata.properties.friendship_level
	local money = ClientData.get("money")
	local age = pet.pet_progression.age
	local baby_has_ailment = has_ailment_baby("salon")
	emulate_location("Salon")
	local deadline = os.clock() + 60
	repeat 
	  task.wait(1)
	until not has_ailment("salon") or os.clock() > deadline
	if os.clock() > deadline then 
	  print(string.format("🟥 Task salon for %s - Out of limits!", actual_pet.remote)) 
	  return		
	end        
	print(string.format("🟩 Task salon for %s - done!", actual_pet.remote)) 
	enstat(age, friendship, money, "salon", baby_has_ailment)
  end,
  ["play"] = function() 
	local pet = ClientData.get("pet_char_wrappers")[1]
	local cdata = ClientData.get("inventory").pets[actual_pet.unique]
	local friendship = cdata.properties.friendship_level
	local money = ClientData.get("money")
	local age = pet.pet_progression.age
	safeInvoke("ToolAPI/Equip", inv_get_category_unique("toys", "squeaky_bone_default"), {})
	local deadline = os.clock() + 25
	repeat 
	  safeInvoke("PetObjectAPI/CreatePetObject",
	    "__Enum_PetObjectCreatorType_1",
		{
	  	  reaction_name = "ThrowToyReaction",
		  unique_id = inv_get_category_unique("toys", "squeaky_bone_default")
		}
	  )
	  task.wait(5) 
	until not has_ailment("play") or os.clock() > deadline
	safeInvoke("ToolAPI/Unequip", inv_get_category_unique("toys", "squeaky_bone_default"), {})
	if os.clock() > deadline then 
	  print(string.format("🟥 Task play for %s - Out of limits!", actual_pet.remote)) 
	  return		
	end        
	print(string.format("🟩 Task play for %s - done!", actual_pet.remote)) 
	enstat(age, friendship, money, "play") 
  end,
  ["toilet"] = function() 
	local pet = ClientData.get("pet_char_wrappers")[1]
	local cdata = ClientData.get("inventory").pets[actual_pet.unique]
	local friendship = cdata.properties.friendship_level
	local money = ClientData.get("money")
	local age = pet.pet_progression.age
	safeInvoke('HousingAPI/ActivateFurniture',
	  LocalPlayer,
	  furn.toilet.unique,
	  furn.toilet.usepart,
	  {
		cframe = CFrame.new(LocalPlayer.Character.HumanoidRootPart.CFrame.Position)
	  },
	  actual_pet.model
	)
	local deadline = os.clock() + 15
	repeat 
	  task.wait(1)
	until not has_ailment("toilet") or os.clock() > deadline
	if os.clock() > deadline then 
	  print(string.format("🟥 Task toilet for %s - Out of limits!", actual_pet.remote)) 
	  actual_pet.model = get_equiped_model()
	  return		
	end        
	print(string.format("🟩 Task toilet for %s - done!", actual_pet.remote)) 
	enstat(age, friendship, money, "toilet")
  end,
  ["beach_party"] = function() 
	local pet = ClientData.get("pet_char_wrappers")[1]
	local cdata = ClientData.get("inventory").pets[actual_pet.unique]
	local friendship = cdata.properties.friendship_level
	local money = ClientData.get("money")
	local age = pet.pet_progression.age
	local baby_has_ailment = has_ailment_baby("beach_party")
	gotopart("_beach")
	emulate_location("MainMap", LocalPlayer, "Default")
	local deadline = os.clock() + 60
	repeat 
	  task.wait(1)
	until not has_ailment("beach_party") or os.clock() > deadline
	if os.clock() > deadline then 
	  print(string.format("🟥 Task beach-party for %s - Out of limits!", actual_pet.remote)) 
	  return		
	end        
	gotopart("main")
	print(string.format("🟩 Task beach-party for %s - done!", actual_pet.remote)) 
	enstat(age, friendship, money, "beach_party", baby_has_ailment)  
  end,
  ["ride"] = function()
	local pet = ClientData.get("pet_char_wrappers")[1]
	local cdata = ClientData.get("inventory").pets[actual_pet.unique]
	local friendship = cdata.properties.friendship_level
	local money = ClientData.get("money")
	local age = pet.pet_progression.age
	local deadline = os.clock() + 60
	gotopart("main")
	task.wait(.25)
	safeInvoke("ToolAPI/Equip", inv_get_category_unique("strollers", "stroller-default"), {})
	local hrp = LocalPlayer.Character.HumanoidRootPart
	local lockedpos = hrp.Position
	CONNECTIONS.RideLock = addConnection("RideLock", RunService.RenderStepped:Connect(function()
	  hrp.CFrame = CFrame.new(lockedpos) * (hrp.CFrame - hrp.CFrame.Position)
	  LocalPlayer.Character.Humanoid:Move(Vector3.new(0, 0, -.1), false) 
	end))
	while os.clock() < deadline and has_ailment("ride") do
	  task.wait(1)
	end
	CONNECTIONS.RideLock:Disconnect()
	CONNECTIONS.RideLock = nil
	safeInvoke("ToolAPI/Unequip", inv_get_category_unique("strollers", "stroller-default"), {})
	if os.clock() > deadline then 
	  print(string.format("🟥 Task ride for %s - Out of limits!", actual_pet.remote)) 
	  return		
	end        
	print(string.format("🟩 Task ride for %s - done!", actual_pet.remote)) 
	enstat(age, friendship, money, "ride") 
  end,
  ["dirty"] = function() 
	local pet = ClientData.get("pet_char_wrappers")[1]
	local cdata = ClientData.get("inventory").pets[actual_pet.unique]
	local friendship = cdata.properties.friendship_level
	local money = ClientData.get("money")
	local age = pet.pet_progression.age
	safeInvoke('HousingAPI/ActivateFurniture',
	  LocalPlayer,
	  furn.bath.unique,
	  furn.bath.usepart,
	  {
		cframe = CFrame.new(LocalPlayer.Character.HumanoidRootPart.CFrame.Position)
	  },
	  actual_pet.model
	)
	local deadline = os.clock() + 20
	repeat 
	  task.wait(1)
	until not has_ailment("dirty") or os.clock() > deadline
	if os.clock() > deadline then 
	  print(string.format("🟥 Task dirty for %s - Out of limits!", actual_pet.remote)) 
	  actual_pet.model = get_equiped_model()
	  return		
	end        
	print(string.format("🟩 Task dirty for %s - done!", actual_pet.remote)) 
	enstat(age, friendship, money, "dirty")  
  end,
  ["walk"] = function() 
	local pet = ClientData.get("pet_char_wrappers")[1]
	local cdata = ClientData.get("inventory").pets[actual_pet.unique]
	local friendship = cdata.properties.friendship_level
	local money = ClientData.get("money")
	local age = pet.pet_progression.age
	local deadline = os.clock() + 60
	local conn
	gotopart("main")
	task.wait(.25)
	safeFire("AdoptAPI/HoldBaby", actual_pet.model)
	local hrp = LocalPlayer.Character.HumanoidRootPart
	local lockedpos = hrp.Position
	CONNECTIONS.WalkLock = addConnection("WalkLock", RunService.RenderStepped:Connect(function()
	  hrp.CFrame = CFrame.new(lockedpos) * (hrp.CFrame - hrp.CFrame.Position)
	  LocalPlayer.Character.Humanoid:Move(Vector3.new(0, 0, -.1), false)  
	end))
	while os.clock() < deadline and has_ailment("walk") do
	  task.wait(1)
	end
	CONNECTIONS.WalkLock:Disconnect()
	CONNECTIONS.WalkLock = nil
	safeFire("AdoptAPI/EjectBaby", actual_pet.model)
	if os.clock() > deadline then 
	  print(string.format("🟥 Task walk for %s - Out of limits!", actual_pet.remote)) 
	  return		
	end      
	print(string.format("🟩 Task walk for %s - done!", actual_pet.remote)) 
	enstat(age, friendship, money, "walk") 
  end,
  ["school"] = function() 
	local pet = ClientData.get("pet_char_wrappers")[1]
	local cdata = ClientData.get("inventory").pets[actual_pet.unique]
	local friendship = cdata.properties.friendship_level
	local money = ClientData.get("money")
	local age = pet.pet_progression.age
	local baby_has_ailment = has_ailment_baby("school")
	emulate_location("School")
	local deadline = os.clock() + 60
	repeat 
	  task.wait(1)
	until not has_ailment("school") or os.clock() > deadline
	if os.clock() > deadline then 
	  print(string.format("🟥 Task school for %s - Out of limits!", actual_pet.remote)) 
	  return		
	end        
	print(string.format("🟩 Task school for %s - done!", actual_pet.remote)) 
	enstat(age, friendship, money, "school", baby_has_ailment)
  end,
  ["sleepy"] = function()
	local pet = ClientData.get("pet_char_wrappers")[1]
	local cdata = ClientData.get("inventory").pets[actual_pet.unique]
	local friendship = cdata.properties.friendship_level
	local money = ClientData.get("money")
	local age = pet.pet_progression.age
	safeInvoke('HousingAPI/ActivateFurniture',
	  LocalPlayer,
	  furn.bed.unique,
	  furn.bed.usepart,
	  {
	 	cframe = CFrame.new(LocalPlayer.Character.HumanoidRootPart.CFrame.Position)
	  },
	  actual_pet.model
	)
	local deadline = os.clock() + 20
	repeat 
	  task.wait(1)
	until not has_ailment("sleepy") or os.clock() > deadline
	if os.clock() > deadline then 
	  print(string.format("🟥 Task sleepy for %s - Out of limits!", actual_pet.remote)) 
	  actual_pet.model = get_equiped_model()
	  return		
	end        
	print(string.format("🟩 Task sleepy for %s - done!", actual_pet.remote)) 
	enstat(age, friendship, money, "sleepy")  	
  end,
  ["mystery"] = function() 
    _G.mystery = true
	while task.wait(5) and has_ailment("mystery") do 
	  for k,_ in AilmentsDB do
	  safeFire("AilmentsAPI/ChooseMysteryAilment", unpack({
	  	[1] = actual_pet.unique,
	  	[2] = "mystery",
	  	[3] = 1,
	  	[4] = k
	  }))
	  end
	end
	_G.mystery = false
	print(string.format("🟩 Task mystery for %s - done!", actual_pet.remote)) 
  end,
  ["pizza_party"] = function() 
	local pet = ClientData.get("pet_char_wrappers")[1]
	local cdata = ClientData.get("inventory").pets[actual_pet.unique]
	local friendship = cdata.properties.friendship_level
	local money = ClientData.get("money")
	local age = pet.pet_progression.age
	local baby_has_ailment = has_ailment_baby("pizza_party")
	emulate_location("PizzaShop")
	local deadline = os.clock() + 60
	repeat 
	  task.wait(1)
	until not has_ailment("pizza_party") or os.clock() > deadline
	if os.clock() > deadline then 
	  print(string.format("🟥 Task pizza-party for %s - Out of limits!", actual_pet.remote)) 
	  return		
	end       
	print(string.format("🟩 Task pizza-party for %s - done!", actual_pet.remote)) 
	enstat(age, friendship, money, "pizza_party", baby_has_ailment)  
  end,
	["pet_me"] = function()
	local pet = ClientData.get("pet_char_wrappers")[1]
	local cdata = ClientData.get("inventory").pets[actual_pet.unique]
	local friendship = cdata.properties.friendship_level
	local money = ClientData.get("money")
	local age = pet.pet_progression.age
	safeFire("PetAPI/ReplicateActivePerformances", actual_pet.model, { ["FocusPet"] = true })
	task.wait(.15)
	safeFire("AilmentsAPI/ProgressPetMeAilment", actual_pet.unique)
	print(string.format("🟩 Task pet-me for %s - done!", actual_pet.remote)) 
	enstat(age, friendship, money, "pet_me")  
  end,
	-- ["party_zone"] = function() end, -- available on admin abuse
}
baby_ailments = {
  ["camping"] = function() 
	local money = ClientData.get("money")
	gotopart("_camp")
	emulate_location("MainMap", LocalPlayer, "Default")
	local deadline = os.clock() + 60
	local pet_has_ailment = has_ailment("camping")
	local age, friendship
	if pet_has_ailment then
  	  age = ClientData.get("pet_char_wrappers")[1].pet_progression.age
	  friendship = ClientData.get("inventory").pets[actual_pet.unique].properties.friendship_level
	end
 	repeat 
	  task.wait(1)
	until not has_ailment_baby("camping") or os.clock() > deadline
 	if os.clock() > deadline then 
	  print("🟥 Task camping for baby - Out of limits!")
	  return		
	end		
	gotopart("main")
	print("🟩 Task camping for baby - done!")
	enstat_baby(money, "camping", pet_has_ailment, { age, friendship, })
  end,
  ["hungry"] = function() 
	local money = ClientData.get("money")
	if count_of_product("food", "apple") < 3 then
	  if money == 0 then  
		print("⚠️ No money to buy food!") 
		return
	  end
  	  if money > 20 then
		safeInvoke("ShopAPI/BuyItem",
	  	  "food",
		  "apple",
		  {
			buy_count = 30
		  }
		)
	  else
		safeInvoke("ShopAPI/BuyItem",
		  "food",
		  "apple",
		  {
			buy_count = money / 2
		  }
		)
	  end
	end
	local money = ClientData.get("money")
	local deadline = os.clock() + 5
	repeat 
  	  safeFire("ToolAPI/ServerUseTool",
	    inv_get_category_unique("food", "apple"),
		"END"
	  )
	  task.wait(.5)
	until not has_ailment_baby("hungry") or os.clock() > deadline
	if os.clock() > deadline then 
	  print("🟥 Task hungry for baby - Out of limits!")
	  return		
	end	
	print("🟩 Task hungry for baby - done!")
	enstat_baby(money, "hungry")  
  end,
  ["thirsty"] = function() 
	local money = ClientData.get("money")
	if count_of_product("food", "water") == 0 then
	  if money == 0 then 
	  	print("⚠️ No money to buy food!") 
	  	return
	  end			
	  if money > 20 then
	  	safeInvoke("ShopAPI/BuyItem",
	  	  "food",
	  	  "water",
	  	  {
	  		buy_count = 20
	  	  }
	  	)
	  else 
	  	safeInvoke("ShopAPI/BuyItem",
	  	  "food",
	  	  "water",
	  	  {
	  	 	buy_count = money / 2
	  	  }
	  	)
	  end
	end
	local money = ClientData.get("money")
	local deadline = os.clock() + 5
	repeat			
	  safeFire("ToolAPI/ServerUseTool",
	    inv_get_category_unique("food", "water"),
		"END"
	  )
	  task.wait(.5)
	until not has_ailment_baby("thirsty") or os.clock() > deadline  
	if os.clock() > deadline then 
	  print("🟥 Task thirsty for baby - Out of limits!")
	  return		
	end		
	print("🟩 Task thirsty for baby - done!")
	enstat_baby(money, "thirsty")  
  end,
  ["sick"] = function() 
	local money = ClientData.get("money")
	local pet_has_ailment = has_ailment("sick")
	local age, friendship
	if pet_has_ailment then
	  age = ClientData.get("pet_char_wrappers")[1].pet_progression.age
	  friendship = ClientData.get("inventory").pets[actual_pet.unique].properties.friendship_level
	end
	emulate_location("Hospital")
	safeInvoke("HousingAPI/ActivateInteriorFurniture",
	  "f-14",
	  "UseBlock",
	  "Yes",
	  LocalPlayer.Character
	)
	task.wait(.85)
	print("🟩 Task sick for baby - done!")
	enstat_baby(money, "sick", pet_has_ailment, { age, friendship, }) 
  end,
  ["bored"] = function() 
	local money = ClientData.get("money")
	local pet_has_ailment = has_ailment("bored")
	local age, friendship
	if pet_has_ailment then
	  age = ClientData.get("pet_char_wrappers")[1].pet_progression.age
	  friendship = ClientData.get("inventory").pets[actual_pet.unique].properties.friendship_level
	end
	gotopart("_playground")
	emulate_location("MainMap", LocalPlayer, "Default")
	local deadline = os.clock() + 60
	repeat 
	  task.wait(1)
	until not has_ailment_baby("bored") or os.clock() > deadline
	if os.clock() > deadline then 
	  print("🟥 Task bored for baby - Out of limits!")
	  return		
	end		
	gotopart("main")
	print("🟩 Task bored for baby - done!")
	enstat_baby(money, "bored", pet_has_ailment, { age, friendship, })  
  end,
  ["salon"] = function() 
	local money = ClientData.get("money")
	local pet_has_ailment = has_ailment("salon")
	local age, friendship
	if pet_has_ailment then
	  age = ClientData.get("pet_char_wrappers")[1].pet_progression.age
	  friendship = ClientData.get("inventory").pets[actual_pet.unique].properties.friendship_level
	end
	emulate_location("Salon")
	local deadline = os.clock() + 60
	repeat 
	  task.wait(1)
	until not has_ailment_baby("salon") or os.clock() > deadline
	if os.clock() > deadline then 
	  print("🟥 Task salon for baby - Out of limits!")
	  return		
	end		
	print("🟩 Task salon for baby - done!")
	enstat_baby(money, "salon", pet_has_ailment, { age, friendship, }) 
  end,
  ["beach_party"] = function() 
	local money = ClientData.get("money")
	local pet_has_ailment = has_ailment("beach_party")
	local age, friendship
	if pet_has_ailment then
	  age = ClientData.get("pet_char_wrappers")[1].pet_progression.age
	  friendship = ClientData.get("inventory").pets[actual_pet.unique].properties.friendship_level
	end
	gotopart("_beach")
	emulate_location("MainMap", LocalPlayer, "Default")
	local deadline = os.clock() + 60
	repeat 
	  task.wait(1)
	until not has_ailment_baby("beach_party") or os.clock() > deadline
	if os.clock() > deadline then 
	  print("🟥 Task beach-party for baby - Out of limits!")
	  return		
	end		
	gotopart("main")
	print("🟩 Task beach-party for baby - done!")
	enstat_baby(money, "beach_party", pet_has_ailment, { age, friendship, })  
  end,
  ["dirty"] = function() 
	local money = ClientData.get("money")
	task.spawn(function() 
	  safeInvoke('HousingAPI/ActivateFurniture',
	  	LocalPlayer,
	  	furn.bath.unique,
	  	furn.bath.usepart,
	  	{
	  	  cframe = CFrame.new(LocalPlayer.Character.HumanoidRootPart.CFrame.Position)
	  	},
	  	LocalPlayer.Character
	  )
	end)
	local deadline = os.clock() + 20
	repeat 
	  task.wait(1)
	until not has_ailment_baby("dirty") or os.clock() > deadline
	StateManagerClient.exit_seat_states()
	if os.clock() > deadline then 
	  print("🟥 Task dirty for baby - Out of limits!")
	  return		
	end		
	print("🟩 Task dirty for baby - done!")
	enstat_baby(money, "dirty")  
  end,
  ["school"] = function() 
	local money = ClientData.get("money")
	local pet_has_ailment = has_ailment("school")
	local age, friendship
	if pet_has_ailment then
	  age = ClientData.get("pet_char_wrappers")[1].pet_progression.age
	  friendship = ClientData.get("inventory").pets[actual_pet.unique].properties.friendship_level
	end
	emulate_location("School")
	local deadline = os.clock() + 60
	repeat 
	  task.wait(1)
	until not has_ailment_baby("school") or os.clock() > deadline
	if os.clock() > deadline then 
	  print("🟥 Task school for baby - Out of limits!")
	  return		
	end		
	print("🟩 Task school for baby - done!")
	enstat_baby(money, "school", pet_has_ailment, { age, friendship, })  
  end,
  ["sleepy"] = function() 
	local money = ClientData.get("money")
	task.spawn(function() 
	  safeInvoke('HousingAPI/ActivateFurniture',
	  	LocalPlayer,
	  	furn.bed.unique,
	  	furn.bed.usepart,
	  	{
	  	  cframe = CFrame.new(LocalPlayer.Character.HumanoidRootPart.CFrame.Position)
	  	},
	  	LocalPlayer.Character
	  )
	end)
	local deadline = os.clock() + 20
	repeat 
	  task.wait(1)
	until not has_ailment_baby("sleepy") or os.clock() > deadline
	StateManagerClient.exit_seat_states()
	if os.clock() > deadline then 
	  print("🟥 Task sleepy for baby - Out of limits!")
	  return		
	end		
	print("🟩 Task sleepy for baby - done!")
	enstat_baby(money, "sleepy")  
  end,
  ["pizza_party"] = function() 
	local money = ClientData.get("money")
	local pet_has_ailment = has_ailment("pizza_party")
	local age, friendship
	if pet_has_ailment then
	  age = ClientData.get("pet_char_wrappers")[1].pet_progression.age
	  friendship = ClientData.get("inventory").pets[actual_pet.unique].properties.friendship_level
	end
	emulate_location("PizzaShop")
	local deadline = os.clock() + 60
	repeat 
	  task.wait(1)
	until not has_ailment_baby("pizza_party") or os.clock() > deadline
	if os.clock() > deadline then 
	  print("🟥 Task pizza-party for baby - Out of limits!")
	  return		
	end		
	print("🟩 Task pizza-party for baby - done!")
	enstat_baby(money, "pizza_party", pet_has_ailment, { age, friendship, })  
  end,
}
local function house_check() 
  if get_current_location() ~= "housing" then
  	print("🏠 Not in house, redirecting..")
  	InteriorsM.enter("housing", "MainDoor", { house_owner = LocalPlayer })
  	task.wait(.6)
  	gotopart("main")
  	return
  end
  print(string.format("🏠 House: %s", HouseClient.get_current_house_type() or "Type not detected, but in house."))
end
local function init_autofarm() 
  print("⚙️ Running pet check.")
  if count(ClientData.get("inventory").pets) < 1 then
  	Cooldown.init_autofarm = 50 
  	return
  end
  local flag = false
  local kitty_exist = check_pet_owned("2d_kitty")
  local kitty_unique = inv_get_category_unique("pets", "2d_kitty")
  if kitty_exist and kitty_unique ~= actual_pet.unique then
  	safeInvoke("ToolAPI/Equip",
  	  kitty_unique,
  	  {
  	  	use_sound_delay = true,
  	  	equip_as_last = false
  	  }
  	)
  	print("🐱 Found and equiped 2D-kitty.")
  	flag = true
  	_G.flag_if_no_one_to_farm = false
  	task.wait(1)
  	pet_update()
  	task.wait(.2)
  end
  if not kitty_exist then
	if (actual_pet.unique and not equiped()) or (actual_pet.unique and actual_pet.unique ~= cur_unique()) then
	  safeInvoke("ToolAPI/Equip",
	    actual_pet.unique, 
	    {
	      use_sound_delay = true,
	      equip_as_last = false
	    }
	  )	 
	  print(string.format("🐶 Pet has been changed. Switching back to: %s", actual_pet.remote or "not pet detected."))
	end
  end
  task.wait(1)
  if not equiped() or cur_unique() ~= actual_pet.unique then
  	actual_pet.unique = false
	if _G.flag_if_no_one_to_farm then
  	  print("⚙️ Opposite farm disabled.")
	end
	_G.flag_if_no_one_to_farm = false
	_G.random_farm = false
	_G.potionfarm = false
  end 
  if not actual_pet.unique or (_G.flag_if_no_one_to_farm and not _G.potionfarm) then
	local owned_pets = get_owned_pets()
  	if _G.InternalConfig.FarmPriority == "pets" then	
  	  local found = false
  	  for _,r in ipairs(Rarities) do
  	    for k,v in pairs(owned_pets) do
  	      if v.remote ~= "practice_dog" and v.rarity == r and v.age < 6 and not _G.InternalConfig.AutoFarmFilter.PetsToExclude[v.remote] and not (v.name:lower()):match("egg") then
  	        safeInvoke("ToolAPI/Equip",
  	          k,
  	          {
  	            use_sound_delay = true,
  	            equip_as_last = false
  	          }
  	        )
  	        flag = true
  	        found = true
  	        _G.flag_if_no_one_to_farm = false
			_G.random_farm = false
  	        break
  	      end
  	    end
  	    if found then break end
  	  end
  	else 
  	  for k,v in pairs(owned_pets) do
  	    if not _G.InternalConfig.AutoFarmFilter.PetsToExclude[v.remote] and (v.name:lower()):match("egg") then
  	      safeInvoke("ToolAPI/Equip",
  	        k,
  	        {
  	          use_sound_delay = true,
  	          equip_as_last = false
  	        }
  	      )
  	      flag = true
  	      _G.flag_if_no_one_to_farm = false
  	      _G.random_farm = false
  	      break
  	    end
  	  end
  	end
  	if not flag then
  	  if _G.InternalConfig.AutoFarmFilter.OppositeFarmEnabled then
  	    if not _G.flag_if_no_one_to_farm then  
  	      print("⚙️ Enabling opposite farm..")
  	      if _G.InternalConfig.FarmPriority == "pets" then
  	      	local found = false
  	      	for _,r in ipairs(Rarities) do
  	      	  for k,v in pairs(owned_pets) do
  	      	  	if v.remote ~= "practice_dog" and v.rarity == r and not _G.InternalConfig.AutoFarmFilter.PetsToExclude[v.remote] and not (v.name:lower()):match("egg") then
  	      	  	  safeInvoke("ToolAPI/Equip",
  	      	  	  	k,
  	      	  	  	{
  	      	  	   	  use_sound_delay = true,
  	      	  	  	  equip_as_last = false
  	      	  	  	}
  	      	  	  )
  	      	  	  flag = true
  	      	  	  found = true
  	      	  	  _G.random_farm = true
  	      	  	  _G.flag_if_no_one_to_farm = true
  	      	  	  if _G.InternalConfig.AutoFarmFilter.PotionFarm then
  	      	  	  	_G.potionfarm = true
  	      	  	  end
  	      	  	  break
  	      	  	end 
  	      	  end
  	      	  if found then break end
  	      	end
  	      	if not found then
  	      	  local found = false
  	      	  for _,r in ipairs(Rarities) do
  	      	  	for k,v in pairs(owned_pets) do
  	      	  	  if v.remote ~= "practice_dog" and v.rarity == r and not _G.InternalConfig.AutoFarmFilter.PetsToExclude[v.remote] then
  	      	  	  	safeInvoke("ToolAPI/Equip",
  	      	  	  	  k,
  	      	  	  	  {
  	      	  	  	  	use_sound_delay = true,
  	      	  	  	  	equip_as_last = false
  	      	  	  	  }
  	      	  	  	)
  	      	  	  	flag = true
  	      	  	  	found = true
  	      	  	  	_G.flag_if_no_one_to_farm = true
  	      	  	  	_G.random_farm = true
  	      	  	  	break
  	      	  	  end
  	      	  	end
  	      	  	if found then break end
  	      	  end
  	      	end
  	      else
  	        local found = false
  	        for _,r in ipairs(Rarities) do
  	          for k,v in pairs(owned_pets) do
  	            if v.remote ~= "practice_dog" and v.rarity == r and not _G.InternalConfig.AutoFarmFilter.PetsToExclude[v.remote]  then
  	              safeInvoke("ToolAPI/Equip",
  	                k,
  	                {
  	                  use_sound_delay = true,
  	                  equip_as_last = false
  	                }
  	              )
  	              flag = true
  	              found = true
  	              _G.flag_if_no_one_to_farm = true
  	              _G.random_farm = true
  	              break
  	            end
  	          end
  	          if found then break end
  	        end
  	      end
  	      if not flag then
  	        local practice_dog = inv_get_category_unique("pets", "practice_dog")
  	        if practice_dog then 
  	          safeInvoke("ToolAPI/Equip",
  	            practice_dog,
  	            {
  	              use_sound_delay = true,
  	              equip_as_last = false
  	            }
  	          )
  	          flag = true
  	          _G.flag_if_no_one_to_farm = true
  	          _G.random_farm = true
  	          task.wait(2)
  	          if cur_unique() ~= practice_dog then
  	            flag = false
  	            _G.random_farm = false
  	            _G.flag_if_no_one_to_farm = false
  	          end
  	        end
  	      end
  	    end
  	  end
    end  
  	if (flag and not equiped()) then
  	  Cooldown.init_autofarm = 5
  	  return
	end
	if not _G.flag_if_no_one_to_farm and _G.random_farm then
  	  print("⚙️ Opposite farm disabled.")
  	  _G.random_farm = false
	end
	if flag then 
	  task.wait(1)
	  pet_update()
	  task.wait(.2)
	  if actual_pet.unique then
		  print("🐨 New pet to farm detected:", actual_pet.remote)
	  end
	end
  end 
  local eqailments = get_equiped_pet_ailments()
  print(string.format("🔎 Detecting tasks for %s..", actual_pet.remote))
  for k,_ in pairs(eqailments) do 
  	if pet_ailments[k] then
  	  house_check()
	  if k == "mystery" then 
  	  	if not _G.mystery then
  	  	  print(formatted_pet["mystery"], actual_pet.remote)
  	  	  task.spawn(pet_ailments[k]) 
  	  	end
  	  	continue
  	  end
  	  print(formatted_pet[k], actual_pet.remote)
  	  pcall(pet_ailments[k])
  	  if CONNECTIONS.WalkLock then CONNECTIONS.WalkLock:Disconnect(); CONNECTIONS.WalkLock = nil end
  	  if CONNECTIONS.RideLock then CONNECTIONS.RideLock:Disconnect(); CONNECTIONS.RideLock = nil end
  	  Cooldown.init_autofarm = 0
  	  return
  	end
  end
  Cooldown.init_autofarm = 15
end
local function init_baby_autofarm() 
  print("⚙️ Running baby check.")
  if ClientData.get("team") ~= "Babies" then
  	safeInvoke("TeamAPI/ChooseTeam",
  	  "Babies",
  	  {
  	  	dont_respawn = true,
  	  	source_for_logging = "avatar_editor"
  	  }
  	)
  end	
  local active_ailments = get_baby_ailments()
  print("🔎 Detecting tasks for baby..")
  for k,_ in pairs(active_ailments) do
  	if baby_ailments[k] then
  	  house_check()
  	  print(formatted_baby[k])
  	  pcall(baby_ailments[k])
  	  Cooldown.init_baby_autofarm = 0
  	  return
  	end
  end
  Cooldown.init_baby_autofarm = 15
end
local function init_lurebox_farm() 
  if count(ClientData.get("lures_2023_lure_manager").lures_map) == 0 then 
  	safeInvoke("HousingAPI/ActivateFurniture",
  	  LocalPlayer,
  	  furn.lurebox.unique,
  	  "UseBlock",
  	  {
  	  	bait_unique = inv_get_category_unique("food", "ice_dimension_2025_ice_soup_bait") 
  	  },
  	  LocalPlayer.Character
  	)
  	task.wait(1)
  	local l = ClientData.get("lures_2023_lure_manager").lures_map.BasicLure
  	if l and l.bait_kind then
  	  print("🪤 Bait placed:", l.bait_kind)
  	else
  	  print("❌ Bait not placed. Repeating after [5]s.")
  	  Cooldown.init_lurebox_farm = 5
  	  return
  	end
  	task.wait(1)
  	local tmps = ClientData.get("lures_2023_lure_manager").lure_start_timestamp
  	if tmps then 
  	  local tms = LiveOpsTime.get_time_until(tmps) 
  	  if tms then
  	  	task.wait(tms)
  	  else
  	  	task.wait(2)
  	  end
  	  local tmps = ClientData.get("lures_2023_lure_manager").lure_start_timestamp
  	  if tmps then 
  	  	local tms = LiveOpsTime.get_time_until(tmps) 
  	  	if tms then
  	  	  task.wait(tms)
  	  	else 
  	  	  Cooldown.init_lurebox_farm = 120
  	  	  return
  	  	end
  	  end
  	end
  	local l = ClientData.get("lures_2023_lure_manager").lures_map.BasicLure
  	if l then
  	  if not l.finished then
  	  	repeat
  	  	  task.wait(1)
  	  	until ClientData.get("lures_2023_lure_manager").lures_map.BasicLure.finished
  	  end
  	  local reward = l.reward
  	  local deadline = os.clock() + 20
  	  repeat 
  	  	safeInvoke("HousingAPI/ActivateFurniture",
  	  	  LocalPlayer,
  	  	  furn.lurebox.unique,
  	  	  "UseBlock",
  	  	  false,
  	  	  LocalPlayer.Character
  	  	)
  	  	task.wait(1)
  	  until count(ClientData.get("lures_2023_lure_manager").lures_map) == 0 or (ClientData.get("lures_2023_lure_manager").lures_map.BasicCrib and not ClientData.get("lures_2023_lure_manager").lures_map.finished ) or os.clock() > deadline
  	  if (ClientData.get("lures_2023_lure_manager").lures_map.BasicLure and not ClientData.get("lures_2023_lure_manager").lures_map.BasicLure.finished) or os.clock() > deadline then
  	  	print("❌ Unsuccessed to get lurebox reward. Repeating after [5]s.")
  	  	Cooldown.init_lurebox_farm = 5
  	  	return
  	  elseif (not ClientData.get("lures_2023_lure_manager").lures_map.BasicLure or not ClientData.get("lures_2023_lure_manager").lures_map.BasicLure.finished) then
  	  	print(string.format("🎁 [%d %s] Found in lurebox!", reward.amount, reward.kind))
  	  else
  	  	Cooldown.init_lurebox_farm = 120
  	  	return
  	  end 
  	end
  else
  	local l = ClientData.get("lures_2023_lure_manager").lures_map.BasicLure
  	if l then
  	  if l.finished then
  	  	local reward = l.reward 
  	  	local deadline = os.clock() + 20
  	  	repeat 
  	  	  safeInvoke("HousingAPI/ActivateFurniture",
  	  	  	LocalPlayer,
  	  	  	furn.lurebox.unique,
  	  	  	"UseBlock",
  	  	  	false,
  	  	  	LocalPlayer.Character
  	  	  )
  	  	  task.wait(1)
  	  	until count(ClientData.get("lures_2023_lure_manager").lures_map) == 0 or (ClientData.get("lures_2023_lure_manager").lures_map.BasicCrib and not ClientData.get("lures_2023_lure_manager").lures_map.finished ) or os.clock() > deadline
  	  	
  	  	if (ClientData.get("lures_2023_lure_manager").lures_map.BasicLure and not ClientData.get("lures_2023_lure_manager").lures_map.BasicLure.finished) or os.clock() > deadline then
  	  	  print("❌ Unsuccessed to get lurebox reward. Repeating after [5]s.")
  	  	  Cooldown.init_lurebox_farm = 5
  	  	  return
  	  	elseif (not ClientData.get("lures_2023_lure_manager").lures_map.BasicLure or not ClientData.get("lures_2023_lure_manager").lures_map.BasicLure.finished) then
  	  	  print(string.format("🎁 [%d %s] Found in lurebox!", reward.amount, reward.kind))
  	  	else
  	  	  Cooldown.init_lurebox_farm = 120
  	  	  return
  	  	end 
  	  end
  	end
  	Cooldown.init_lurebox_farm = 2
  end
end
local function init_send_webhook() 
  webhook(
  	"Farm-Log",
  	string.format(">>> 💸 __Money Earned__ - [ %d ]\
  	📈 __Pets Full-grown__ - [ %d ]\
  	🐶 __Pet Needs Completed__ - [ %d ]\
  	🧪 __Potions Farmed__ - [ %d ]\
  	🧸 __Friendship Levels Farmed__ - [ %d ]\
  	👶 __Baby Needs Completed__ - [ %d ]\
  	🥚 __Eggs Hatched__ - [ %d ]", 
	farmed.money, farmed.pets_fullgrown, farmed.ailments, farmed.potions, farmed.friendship_levels, farmed.baby_ailments, farmed.eggs_hatched)
  )
  Cooldown.webhook_send_delay = 3600
end
local function __init_babypet_autofarm() 
    while task.wait(1) do
    if _G.InternalConfig.FarmPriority then
      if Cooldown.init_autofarm and Cooldown.init_autofarm <= 0 then
		Cooldown.init_autofarm = nil
      	local res = pcall(init_autofarm)
		if not res then
		  Cooldown.init_autofarm = 15
		end
      end
    end
    if _G.InternalConfig.BabyAutoFarm then
      if Cooldown.init_baby_autofarm and Cooldown.init_baby_autofarm <= 0 then
		Cooldown.init_baby_autofarm = nil
      	local res = pcall(init_baby_autofarm)
		if not res then
		  Cooldown.init_baby_autofarm = 15	
		end
      end
    end
  end
end
local function __init()
  while task.wait(1) do
	local cd = Cooldown
	cd.webhook_send_delay = cd.webhook_send_delay and math.max(0, cd.webhook_send_delay - 1)
	cd.watchdog = cd.watchdog and math.max(0, cd.watchdog - 1)
	cd.init_autofarm = cd.init_autofarm and math.max(0, cd.init_autofarm - 1)
	cd.init_baby_autofarm = cd.init_baby_autofarm and math.max(0, cd.init_baby_autofarm - 1)
	cd.init_lurebox_farm = cd.init_lurebox_farm and math.max(0, cd.init_lurebox_farm - 1)
	if _G.InternalConfig.DiscordWebhookURL and cd.webhook_send_delay == 0 then
	  cd.webhook_send_delay = nil
	  task.spawn(function()
	  	pcall(init_send_webhook)
	  end)
	end
	if _G.InternalConfig.LureboxFarm and cd.init_lurebox_farm == 0 then
	  cd.init_lurebox_farm = nil
	  task.spawn(function()
		  pcall(init_lurebox_farm)
	  end)
	end
	if cd.watchdog == 0 then
	  task.spawn(function() 
		pcall(function() 
		  print("[Watchdog] Lua Memory Usage:", gcinfo()/1024, "Mb")
		  print("[Watchdog] Client Memory Usage:", Stats:GetTotalMemoryUsageMb(), "Mb")
		  cd.watchdog = 60
		end)
	  end)
	end
  end
end 
local function license() 
  if loader("TradeLicenseHelper").player_has_trade_license(LocalPlayer) then
  	print("[+] License found.")
  else
  	print("[?] License not found, trying to get..")
  	safeFire("SettingsAPI/SetBooleanFlag", "has_talked_to_trade_quest_npc", true)
  	safeFire("TradeAPI/BeginQuiz")
  	task.wait(.2)
  	for _,v in pairs(ClientData.get("trade_license_quiz_manager").quiz) do
      safeFire("TradeAPI/AnswerQuizQuestion", v.answer)
  	end
  	print("[+] License received.")
  end
end
;(function() 
  for k, v in pairs(getupvalue(require(ReplicatedStorage.ClientModules.Core:WaitForChild("RouterClient"):WaitForChild("RouterClient")).init, 7)) do
  	v.Name = k
  end
  print("[+] API dehashed.")
end)()
;(function() 
  local Config = getgenv().Config
    if type(Config.FarmPriority) == "string" then
    _G.InternalConfig.AutoFarmFilter = {}
  	if not Config.FarmPriority:match("^%s*$") then 
  	  if Config.FarmPriority:lower() == "eggs" or Config.FarmPriority:lower() == "pets" then
  	  	_G.InternalConfig.FarmPriority = Config.FarmPriority
  	  	if type(Config.AutoFarmFilter.PetsToExclude) == "string" then
  	  	  _G.InternalConfig.AutoFarmFilter.PetsToExclude = {}
  	  	  if not Config.AutoFarmFilter.PetsToExclude:match("^%s*$") then 
			for v in Config.AutoFarmFilter.PetsToExclude:gmatch("([^;]+)") do
			  local found = false
			  local name = v:lower()
			  for id,tab in InventoryDB.pets do
			    if tab.name:lower() == name then
				  _G.InternalConfig.AutoFarmFilter.PetsToExclude[id] = true
				  found = true
				  break
				end 
			  end
			  if not found then
			   print(string.format("[AutoFarmFilter.PetsToExclude] Wrong [%s] name.", v))
			  end
			end
  	  	  	if count(_G.InternalConfig.AutoFarmFilter.PetsToExclude) == 0 then
  	  	  	  print("[AutoFarmFilter.PetsToExclude] No valid pet names provided. Option is disabled.")
  	  	  	  _G.InternalConfig.AutoFarmFilter.PetsToExclude = {}
  	  	  	end
  	  	  end
  	  	else
  	  	  error("[AutoFarmFilter.PetsToExclude] Wrong datatype. Exiting.")
  	  	end
  	  	if type(Config.AutoFarmFilter.PotionFarm) == "boolean" then 
  	  	  _G.InternalConfig.AutoFarmFilter.PotionFarm = false
  	  	  if Config.AutoFarmFilter.PotionFarm then	
  	  	  	if _G.InternalConfig.FarmPriority == "pets" then 
  	  	  	  _G.InternalConfig.AutoFarmFilter.PotionFarm = true
  	  	  	end
  	  	  end
  	  	else 
  	  	  error("[AutoFarmFilter.PotionFarm] Wrong datatype. Exiting.")
  	  	end
  	  	if type(Config.AutoFarmFilter.EggAutoBuy) == "string" then
  	  	  if not (Config.AutoFarmFilter.EggAutoBuy):match("^%s*$") then 
			local found = false
			local name = Config.AutoFarmFilter.EggAutoBuy:lower()
			for id,tab in InventoryDB.pets do
			  if tab.name:lower() == name then
				_G.InternalConfig.AutoFarmFilter.EggAutoBuy[id] = true
				found = true
				break
			  end 
			end
			if not found then
			  _G.InternalConfig.AutoFarmFilter.EggAutoBuy = false
			  print(string.format("[AutoFarmFilter.EggAutoBuy] Wrong [%s] name. Option is disabled.", Config.AutoFarmFilter.EggAutoBuy))
			end
		  else
			_G.InternalConfig.AutoFarmFilter.EggAutoBuy = false
		  end
  	  	else
  	  	  error("[AutoFarmFilter.EggAutoBuy] Wrong datatype. Exiting.")
  	  	end
  	  	if type(Config.AutoFarmFilter.OppositeFarmEnabled) == "boolean" then
  	  	  _G.InternalConfig.AutoFarmFilter.OppositeFarmEnabled = false
  	  	  if _G.InternalConfig.FarmPriority then
  	  	  	_G.InternalConfig.AutoFarmFilter.OppositeFarmEnabled = Config.AutoFarmFilter.OppositeFarmEnabled
  	  	  end
  	  	else
  	  	  error("[AutoFarmFilter.OppositeFarmEnabled] Wrong datatype. Exiting.")
  	  	end
  	  else
  	  	error("[FarmPriority] Wrong value. Exiting.")
  	  end
  	else 
  	  _G.InternalConfig.FarmPriority = false
  	end
  else  
  	error("[FarmPriority] Wrong datatype. Exiting.")
  end
  if type(Config.BabyAutoFarm) == "boolean" then
    _G.InternalConfig.BabyAutoFarm = Config.BabyAutoFarm
  else
    error("[BabyAutoFarm] Wrong datatype. Exiting.")
  end
  if type(Config.Disable3DRendering) == "boolean" then
    _G.InternalConfig.Disable3DRendering = Config.Disable3DRendering
  else
    error("[Disable3DRendering] Wrong datatype. Exiting.")
  end
  if type(Config.DiscordWebhookURL) == "string" then 
  	if not (Config.DiscordWebhookURL):match("^%s*$") then 
  	  local res, _ = pcall(function() 
  	  	request({
  	  	  Url = Config.DiscordWebhookURL,
  	  	  Method = "GET"
  	  	})
  	  end)
  	  if res then
  	  	_G.InternalConfig.DiscordWebhookURL = Config.DiscordWebhookURL
  	  else
  	  	_G.InternalConfig.DiscordWebhookURL = false
  	  end
  	else 
  	  _G.InternalConfig.DiscordWebhookURL = false
  	end
  else
  	error("[DiscordWebhookURL] Wrong datatype. Exiting.")
  end
end)()
local function __CONN_CLEANUP(player)
  if player == LocalPlayer then
  	for _, v in pairs(CONNECTIONS) do
  	  v:Disconnect()
  	end
	for _, v in pairs(_G.Looping) do
		v:Disconnect()
	end 
  end
end
local function __INSTANCE_CLEANUP(player)
  if player == LocalPlayer then
    for _, v in pairs(CLEANUP_INSTANCES) do
  	  v:Destroy()
	end
  end
end
addConnection("ConnectionCleanup", game.Players.PlayerRemoving:Connect(__CONN_CLEANUP))
addConnection("InstanceCleanup", game.Players.PlayerRemoving:Connect(__INSTANCE_CLEANUP))
local function check_internet()
  local ok, res = pcall(function()
  	return request({
  	  Url = "https://google.com",
  	  Method = "GET"
  	})
  end)
  if ok and res and res.Success then
  	return true
  end
  return false
end
local function on_child_removed()
  while not check_internet() do
	print("No internet. Waiting..")
	task.wait(5)
  end
  TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end
if not _G.Looping["NetworkHook"] then
  _G.Looping.NetworkHook = NetworkClient.ChildRemoved:Connect(on_child_removed)
end
addConnection("AntiAFK", LocalPlayer.Idled:Connect(function() 
  task.spawn(function() 
	VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
	task.wait(1)
	VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
  end)
end))
;(function() 
  init_part("main", parts["main"])
  init_part("_camp", parts["_camp"])
  init_part("_playground", parts["_playground"])
  init_part("_beach", parts["_beach"])
end)()
;(function()
  if LocalPlayer.Character then return end
  safeFire("SettingsAPI/SetSetting", "tutorial_completed", true)
  safeFire("SettingsAPI/SetSetting", "pet_radial_menu", true)
  safeFire("SettingsAPI/SetSetting", "use_ailments_monitor", true)
  safeFire("SettingsAPI/SetSetting", "pet_can_auto_exit_furniture", true)
  safeFire("SettingsAPI/SetSetting", "family_requests", 3)
  safeFire("SettingsAPI/SetSetting", "party_requests", 3)
  safeFire("SettingsAPI/SetSetting", "trade_requests", 3)
  safeFire("SettingsAPI/SetSetting", "background_music_volume", 0)
  repeat 
  	task.wait(1)
  until not LocalPlayer.PlayerGui.AssetLoadUI.Enabled
  safeInvoke("TeamAPI/ChooseTeam", "Parents", { source_for_logging="intro_sequence" })
  task.wait(1)
  UIManager.set_app_visibility("MainMenuApp", false)
  UIManager.set_app_visibility("NewsApp", false)
  UIManager.set_app_visibility("DialogApp", false)
  task.wait(3)
  safeInvoke("DailyLoginAPI/ClaimDailyReward")
  UIManager.set_app_visibility("DailyLoginApp", false)
  safeFire("PayAPI/DisablePopups")
  repeat 
  	task.wait(.3) 
  until LocalPlayer.Character and 
  LocalPlayer.Character.HumanoidRootPart and 
  LocalPlayer.Character.Humanoid and 
  LocalPlayer.PlayerGui
  task.wait(1)
end)()
task.spawn(function() 
  local hui = gethui()
  if hui:FindFirstChild("StatsOverlay")then
	return 
  end
  local gui = Instance.new("ScreenGui") 
  local frame = Instance.new("Frame")
  gui.Name = "StatsOverlay" 
  gui.ResetOnSpawn = false 
  gui.Parent = hui
  frame.Name = "StatsFrame"
  frame.Size = UDim2.new(0, 250, 0, 150)
  frame.Position = UDim2.new(0, 5, 0, 5)
  frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
  frame.BackgroundTransparency = 0.3
  frame.Parent = gui
  local function createLabel(name, text, order)
  	local label = Instance.new("TextLabel")
  	label.Name = name
  	label.Size = UDim2.new(1, 0, 0, 20)
  	label.Position = UDim2.new(0, 0, 0, order * 22)
  	label.BackgroundTransparency = 1
  	label.TextYAlignment = Enum.TextYAlignment.Center
  	label.TextColor3 = Color3.fromRGB(255, 255, 255)
  	label.Font = Enum.Font.SourceSans
  	label.TextSize = 18
  	label.TextXAlignment = Enum.TextXAlignment.Left
  	label.Text = text .. ": 0"
  	label.Parent = frame
  	return label
  end
  createLabel("bucks", "💸 Bucks earned", 0)
  createLabel("fullgrown", "📈 Pets full-grown", 1)
  createLabel("pet_needs", "🐶 Pet needs completed", 2)
  createLabel("potions", "🧪 Potions farmed", 3)
  createLabel("friendship", "🧸 Friendship levels farmed", 4)
  createLabel("baby_needs", "👶 Baby needs completed", 5)
  createLabel("eggs", "🥚 Eggs hatched", 6)
end) 
if not _G.InternalConfig.FarmPriority and 
not _G.InternalConfig.BabyAutoFarm and
not _G.InternalConfig.LureboxFarm then 
else
  if not HouseClient.is_door_locked() then
  	HouseClient.lock_door()
  	print("🚪 Door locked!")
  end
  init_furniture()
  print("[+] Script injected.")
end	
task.spawn(Avatar)
license()
;(function() 
  if _G.InternalConfig.BabyAutoFarm then
  	if ClientData.get("team") ~= "Babies" then
  	  safeInvoke("TeamAPI/ChooseTeam",
  	  	"Babies",
  	  	{
  	  	  dont_respawn = true,
  	  	  source_for_logging = "avatar_editor"
  	  	}
  	  )
  	end	
  end
end)()
if _G.InternalConfig.FarmPriority or _G.InternalConfig.BabyAutoFarm then 
  task.spawn(__init_babypet_autofarm)	
end
__init()
if _G.InternalConfig.Disable3DRendering then
	RunService:Set3dRenderingEnabled(false)
end 
