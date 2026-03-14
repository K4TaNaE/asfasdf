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
  webhook_send_delay = 3600,
  Event = {
    marshmallow_autocollect = 0,
	daily_dice_cooldown = 0,
	daily_rewards_cooldown = 0,
	try_use_inventory_dices = 0
  }
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
local marshmallow = {
"{46dca2e4-1ac9-4859-942b-f1c80b6d070b}",
"{45f636ca-5b3b-43b7-ba2b-fe68568b6c41}",
"{bfbfac00-a715-44a6-a32d-b02fb4fc71d7}",
"{e838c521-7f7a-4307-b2a1-333a47485eaf}",
"{dda99337-dec1-4e4c-b10c-4cab4e29f014}",
"{65dff08c-c13a-4483-bc8e-b8246d2944f5}",
"{b12eacc6-a77c-408d-bf3d-3fa6ec22b864}",
"{b8af299f-f9e3-4c9b-8d9b-c90ab67e05ef}",
"{d53bcd3e-e8c5-46d5-814d-c531af19b313}",
"{ffbaad1b-d694-484a-8d21-338564b913f8}",
"{503633c5-07a4-4452-9923-7d959fcc84bb}",
"{392f996d-3dde-47fe-84a5-0a8989d38a24}",
"{6793647b-8deb-47c6-8341-985cae96da9c}",
"{fb1162cc-45ff-4e33-bf12-59399c4053a4}",
"{cb24b90b-41ef-4062-8290-5c3daa9f0ebb}",
"{ed56c5a7-6e5f-4923-9e33-386863295295}",
"{722590bd-f2e4-40f9-9764-064e188da384}",
"{13f51cec-d29b-4aff-90d0-f272f971c345}",
"{84cc461f-f18c-486a-b52b-c02fd5d14951}",
"{39d7a4a8-76bf-4f68-9705-d92b6ab4fd70}",
"{1a0f3a77-adb7-45b4-9168-e27643493e42}",
"{0104d31d-2ccc-41e4-b415-4ed1dde10312}",
"{94a2c2bd-d22f-4819-a058-faa3021bdaad}",
"{3203fbe6-7723-4378-9bf6-5c8a24ab1be2}",
"{14619336-a4d1-4bee-960c-69aa204626db}",
"{6ea7b899-4b3b-4a1a-899e-27afddae023a}",
"{026ade17-6e94-4c22-83d7-425d99ab7e66}",
"{6de1b526-6b01-4ff9-811b-687b4c0b9b3e}",
"{64085bd1-e20e-4998-86e8-f67a478939e9}",
"{6f897409-0177-458c-b377-4569e997a13a}",
"{8e34db76-d4b2-4a40-9167-31d0d5470ee4}",
"{87d1777e-38f8-43d0-a564-c5c7f6e22203}",
"{42307410-1e97-4ba2-9096-20dd1c51a63d}",
"{a00bb1d2-97c0-462b-a66c-c1049eb973a3}",
"{16f59f0c-ed14-45cf-a6f9-51f9c051f7e0}",
"{a734bf4b-be08-4038-a0c3-7eb3c6111fdb}",
"{f34ed415-d405-4579-ab1f-8fbe53aa22f2}",
"{9d205f01-ae45-4559-baac-4cb6c0c8993d}",
"{bf5eb2a3-d2c8-4f6e-a7cb-7e724b12c5ae}",
"{bd281fb7-d03f-4f28-9fd3-2d4eea36e743}",
"{06407d28-82ad-442b-96bb-818f907493ff}",
"{65e6b558-5220-435c-a805-513095676aa9}",
"{0bc92778-87f1-4409-a54a-cf9178964b1f}",
"{b9daf426-92c1-49b4-abca-c58ca5d9e0a9}",
"{78710ec1-0493-4748-a610-83fee2716624}",
"{a3c7f548-e41a-46b1-8d87-c5de3a566148}",
"{e02061cb-cf98-4fe4-9802-145c98c0867b}",
"{2babb231-7601-41bf-bbb4-f0edf5a1747d}",
"{83e6fdda-ad9a-4528-9520-479b5852a361}",
"{5d94b1f9-e1f8-447e-aacc-7433703547e9}",
"{88b29049-39c6-455e-be1f-75530cf110aa}",
"{d5bc0c47-1580-4fdd-9cf3-102f7843c39e}",
"{ee4b4ef5-09b8-4bdd-805c-c1fd20f9bae0}",
"{cb1c2f4a-34d0-4685-a6cf-01a4d20bfd2d}",
"{1dc10d7d-c04a-48f6-a823-54bca1f2be3d}",
"{cb955dfc-093d-4001-b5b0-ef6b175072a1}",
"{bee31fae-6a2e-4c95-a673-36b275c75949}",
"{25a67c29-8c07-4065-9a77-73c34f2f0a0e}",
"{8dd0d543-1617-4bdf-a26a-53cd87610262}",
"{30fb32a8-4d35-4093-875f-a62aa5e51417}",
"{00449e7d-6dd4-4d3b-a884-924e79e7d545}",
"{168b3ef7-1333-4dac-a725-c1e9b3f1b2f0}",
"{f7a4b382-bf78-4be3-928b-dff5b4c2e72f}",
"{c75165b8-a8b8-4759-831e-1ea6022688c7}",
"{8d7ca87b-3661-4cc9-b205-089c357b17dc}",
"{1282b867-96a8-4267-8582-2e91712478af}",
"{4584035e-483d-4297-88ac-8c2e8661ec5d}",
"{9a5b0a26-3b95-49b7-828d-3813b71c4e3e}",
"{68f85bed-4a19-4d73-a7f8-951335ba9355}",
"{e7f5681d-0b3a-42ff-9cf1-eaec59b64672}",
"{bd307b69-7ce4-48df-a067-c80979c4dc94}",
"{0fcc587a-22ed-4ae2-888d-97fefe2fb869}",
"{a4a8791f-e993-44e2-87e4-0031fc210d18}",
"{8215710d-9345-43c3-892e-bac765ea2d4b}",
"{226038b9-cd4e-4746-a8f0-6087f75d08b5}",
"{68d47ab1-dc88-4cf2-ac32-d172b5a084fa}",
"{29633ad0-9a26-49bf-84c1-4326bd105bff}",
"{2b42e6ef-7ce6-4e79-baa9-c6ddafd0aae7}",
"{0fb7de61-82ba-47a5-bfbb-882751320ef0}",
"{836ebd89-fb1e-4209-bbd9-8a72a33b7cdc}",
"{e0bb09bf-53b8-4e10-9dbd-e1958731cc7a}",
"{ce58a7ce-11de-4dc8-a707-3547974c122c}",
"{31ddd2ed-0d40-4282-9d1e-91171f623ef2}",
"{471f1636-cb7d-41d4-96ca-2e14c1a2f183}",
"{34d7d7ee-54e2-4d06-bb00-69fd5e39beb1}",
"{e9466b21-fe37-40f0-ba35-66a9567396a8}",
"{5f692b00-a30a-4fce-8e5a-f6d3dd7e2916}",
"{cddabde9-0758-40b9-bb11-6962a4722a57}",
"{50feac33-9eee-4588-afc3-97df922e3f00}",
"{e650261b-64fc-4c08-a75a-3b2a4082d014}",
"{6285ff12-7e0d-4ea3-bfac-b708f7365d54}",
"{0a62702e-2eb4-4628-b128-25bd9bc24f0e}",
"{3ef891aa-e19e-4d17-842c-93af4177ca35}",
"{b8da90f7-bc29-4d4d-8d78-900a2e2c3e37}",
"{4a056f1a-37d8-4d4f-94b7-b82b62336853}",
"{92d40e4b-7b11-40e5-b2ae-4b3026e02817}",
"{b350cb36-9362-4f0f-a211-64401bcfbf07}",
"{c5ad92df-018c-4c5a-ad06-deab43d0061c}",
"{01d591d9-b992-42be-9414-baf55b410727}",
"{3d111c0e-23ea-441e-b2b1-3000b2d1abe8}",
"{680e7b63-a67f-4cc0-be71-887b85ebfef6}",
"{97b8ced9-a518-46b4-89ac-db4c7bf1ada2}",
"{68a61a0d-ade1-48c9-9f94-0aa4ed75342b}",
"{9b8a54ab-0ceb-4da5-a631-47453d887121}",
"{a2a0075b-47a9-4e0c-9a36-10e6608175d9}",
"{74df0f87-4ccc-485c-8cba-d265b28cbac4}",
"{0d988090-c906-4cb5-95d9-f0de8bba141e}",
"{1e0a75f5-a635-463d-8cec-2345e852b85c}",
"{6505337b-0020-466c-89a0-051118c7902b}",
"{943a378c-45ca-4beb-82c4-4bd9f19dfcad}",
"{95e065db-b9f1-4a29-9cc9-d8c6db795ef2}",
"{0411269e-69f3-4e27-8a05-b0299da87394}",
"{3753c264-3548-4afa-b355-5722f90f6a69}",
"{b5fe9857-95cf-4a77-aba2-c633d77698cf}",
"{642e8389-1353-417a-ab9c-940876373917}",
"{5f4c7e43-2c1a-4c12-8cf2-b34bceb7af70}",
"{054f97cb-753c-4d8c-9281-930418b5f5ec}",
"{896d9f21-776f-4dee-b22c-11ecab9b6c9b}",
"{dd025eb2-10b6-46d3-8468-994282cd29ab}",
"{2085eb60-8b89-456d-a7ab-70e54ccbf346}",
"{414ac687-fb44-45ca-ac90-526f5ae22057}",
"{b9ce37d2-fd61-4fe2-b513-e0314fe79514}",
"{db50e49e-6354-4597-af0a-9b9b7e0cfbe8}",
"{d7c51b61-218b-4c1d-8e24-16b16dd38dba}",
"{dd4e80a1-a8bc-43a6-a18d-07e0e9cdebb8}",
"{c8093c22-2a65-46a5-bd5b-ce7e207a6e86}",
"{4a221530-7fcf-480a-bc29-c210511b7ff2}",
"{886df299-df87-4c08-b244-78af0c59c27e}",
"{18e0c4cc-3d06-4331-b73b-cae5ef2e6715}",
"{0c87b405-232b-48d7-b7b7-0c0636899a33}",
"{203064f6-2485-483b-bfb7-ef35465465fe}",
"{6b627e9b-ee52-456b-833e-4c59d522510e}",
"{2c5411a9-693e-415d-b7e9-03cf06bf99b1}",
"{3f22d40a-4ee0-44da-8adf-1ea0fbbb340d}",
"{436438e8-983d-47bd-92cf-035bbcbb1de5}",
"{b38f85d7-e7da-4ed1-979a-cc39ac61c5f5}",
"{4796c501-7172-465d-acfe-07140c2cb8f6}",
"{a84c8c62-f11c-4c1d-a297-1bed6d880054}",
"{087cca29-ac27-403a-a9db-06fd353f0145}",
"{008581c8-0479-4fbe-9034-c2a42c7e5d25}",
"{c874f7e6-c67c-4e40-a645-bbba707c34e1}",
"{dab729ce-1a78-44d8-b8e6-873ec5c49f4e}",
"{d00b5a85-9d9c-413d-8da4-7134d96c9919}",
"{a629e0da-32cb-46dd-8e33-e8c4238c539e}",
"{9525ebe4-fc85-4024-9ae4-5994fd6e7788}",
"{eb2318a3-3e2f-42de-b3ab-7474ee12d9d9}",
"{85dba3ea-fa05-4652-916c-02c2d5cf31de}",
"{21840898-ee73-4bdf-8a94-5338f290d9e0}",
"{08e4d9b6-cd7e-4005-91b1-cfde5cd50a14}",
"{2bf4ce11-5905-4c97-ab4f-298025e5b4e0}",
"{721f5ad8-453b-4a32-a8f8-8a2bf5704db2}",
"{30d06033-95f8-43a1-a311-dcde2dfd6a34}",
"{2b5ccdab-832d-40ba-ad3b-460452445b67}",
"{2cadac03-4f42-43f6-b4b3-c3764848ef08}",
"{f9463560-7550-40d5-9cee-b47f1e1d5ff6}",
"{8ab0c870-bc05-4b8a-9e85-2c60dc0b156d}",
"{00ffe177-bae9-4b56-a6cf-57a0bfa59f04}",
"{993b0fb9-f6f2-4542-867a-e7ae76b0bc00}",
"{c171242e-1662-43ef-a7a6-ef6ed4c16929}",
"{ae5b4d83-c5f6-48bd-9072-d6607145caf4}",
"{6dc84eed-c94b-4cca-af77-a83e15f8a3f2}",
"{8900eea5-fccc-4d0c-8b55-3cb4e2991261}",
"{6662d503-755c-40cc-89fd-6fa237616470}",
"{2b9bb081-9fd8-481c-b49a-2f93110083d6}",
"{ceb96285-96c9-4b0a-99d4-8d07bc9e6a1f}",
"{b1c79cc8-86e4-43c8-a67b-221a4a8f3546}",
"{454c9f46-b453-4d56-8621-9bfdac448523}",
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
local Event = {}
Event.starter_value = ClientData.get("eggs_2026") or 0
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
  Event.calculate_currency()
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
    local event_currency = ClientData.get("eggs_2026")
    if event_currency then
        update_gui("event_currency", event_currency)
    end
  	farmed.ailments += 1
  	update_gui("pet_needs", farmed.ailments) 
  else
  	enstat(age, friendship, nil, ailment)
  end
end
local function enstat_baby(money, ailment, pet_has_ailment, petData) 
  Event.calculate_currency()
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
  	🥚 __Eggs Hatched__ - [ %d ]\
	🍡 __Candy Eggs__ - [ %d]", 
	farmed.money, farmed.pets_fullgrown, farmed.ailments, farmed.potions, farmed.friendship_levels, farmed.baby_ailments, farmed.eggs_hatched, ClientData.get("eggs_2026"))
  )
  Cooldown.webhook_send_delay = 3600
end
function Event.marshmallow_autocollect() 
  for _,v in ipairs(marshmallow) do
    ReplicatedStorage.adoptme_new_net["adoptme_legacy_shared.ContentPacks.Sugarfest2026.ChocolateRiver.ChocolateRiverNet:6"]:FireServer(unpack({
      [1] = {
        ["interior_name"] = "MainMap!Sugarfest2026",
        ["marshmallow_ids"] = {
          [1] = v
        }
      }
    }))
    task.wait(.26)
  end
  task.wait(.5)
  ReplicatedStorage.adoptme_new_net["adoptme_legacy_shared.ContentPacks.Sugarfest2026.ChocolateRiver.ChocolateRiverNet:14"]:FireServer()
  print("[+] Successfully collected marshmallow.")
  task.wait(.7)
  Event.calculate_currency()
  Cooldown.Event.marshmallow_autocollect = 120
end
function Event.calculate_currency()
  update_gui("event_currency", (ClientData.get("eggs_2026") or 0) - Event.starter_value)
end
function Event.get_sugar_dices() 
  local dices = {}
  local gifts = ClientData.get("inventory").gifts
  for _,v in gifts do
	if v.id == "sugarfest_2026_dice" or v.id == "sugarfest_2026_custom_dice" then
      dices[v.unique] = v
	end
  end
  if count(dices) == 0 then return nil end
  return dices
end
function Event.try_use_dices()
  local sugar_dices = Event.get_sugar_dices()
  if not sugar_dices then return end
  emulate_location("MainMap", LocalPlayer, "Sugarfest2026")
  for k,v in sugar_dices do
	if v.id == "sugarfest_2026_dice" then
	  ReplicatedStorage.adoptme_new_net["adoptme_legacy_shared.ContentPacks.Sugarfest2026.Game.BoardGame.BoardGameNetService:10"]:FireServer({["dice_item_unique"] = k})	
	else
	  ReplicatedStorage.adoptme_new_net["adoptme_legacy_shared.ContentPacks.Sugarfest2026.Game.BoardGame.BoardGameNetService:10"]:FireServer({dice_item_unique = k, supplied_distance = 6})
	end
	print("🎲 Sugar dice used.")
	task.wait(1.5)
  end
  Event.calculate_currency()
end
function Event.collect_dailies_rewards()
  print("📋 Looking and processing sugarfest dailies..")
  ReplicatedStorage.adoptme_new_net["adoptme_new.modules.Dailies.DailiesNetService:9"]:FireServer("sugarfest")
  ReplicatedStorage.adoptme_new_net["adoptme_new.modules.Dailies.DailiesNetService:15"]:FireServer("sugarfest") -- custom dice
  local sugarfest = ClientData.get("dailies_manager")['serialized_tabs']['sugarfest']
  if not sugarfest.active_dailies or count(sugarfest.active_dailies) == 0 then
	print("📋 All sugarfest dailies completed.")
	local tms = LiveOpsTime.get_time_until(sugarfest.bext_distribution_timestamp) or 3600
	Cooldown.Event.daily_rewards_cooldown = tms + 5
	return
  end
  Cooldown.Event.daily_rewards_cooldown = 300
end
function list_candy_chisel()
  local chisels = {}
  local gifts = ClientData.get("inventory").gifts
  for _, v in gifts do
	if v.id == "sugarfest_2026_candy_chisel" then
	  chisels[v.unique] = v
	end	
  end
  if count(chisels) == 0 then return nil end
  return chisels
end
function Event.get_daily_dice()
  local tms = LiveOpsTime.get_time_until(ClientData.get("board_game_daily_refresh_cycle_timestamp").timestamp)
  if ClientData.get("board_game_manager").free_dice_claimed then
    print("🎲 Daily sugar dice is already collected.")
	Cooldown.Event.daily_dice_cooldown = (tms + 5) or 3600
	return
  end
  ReplicatedStorage.adoptme_new_net["adoptme_legacy_shared.ContentPacks.Sugarfest2026.Game.BoardGame.BoardGameNetService:23"]:FireServer()
  print("🎲 Daily sugar dice collected.")
  Cooldown.Event.daily_dice_cooldown = tms + 5
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
	cd.Event.marshmallow_autocollect = cd.Event.marshmallow_autocollect and math.max(0, cd.Event.marshmallow_autocollect - 1)
	cd.Event.daily_dice_cooldown = cd.Event.daily_dice_cooldown and math.max(0, cd.Event.daily_dice_cooldown - 1)
	cd.Event.daily_rewards_cooldown = cd.Event.daily_rewards_cooldown and math.max(0, cd.Event.daily_rewards_cooldown - 1)
	cd.Event.try_use_inventory_dices = cd.Event.try_use_inventory_dices and math.max(0, cd.Event.try_use_inventory_dices - 1)
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
	if Cooldown.Event.try_use_inventory_dices and Cooldown.Event.try_use_inventory_dices == 0 then
	  Cooldown.Event.try_use_inventory_dices = nil
	  task.spawn(function() 
		pcall(Event.try_use_dices)
		Cooldown.Event.try_use_inventory_dices = 300 -- специально убрал if not res потоучто и так и так кулдаун 300 секунд.
	  end)
	end
	if cd.Event.daily_dice_cooldown == 0 then
	  cd.Event.daily_dice_cooldown = nil
	  task.spawn(function() 
	  	pcall(Event.get_daily_dice)
	  end)
	end
	if cd.Event.daily_rewards_cooldown == 0 then
	  cd.Event.daily_rewards_cooldown = nil
	  task.spawn(function() 
	  	pcall(Event.collect_dailies_rewards)
	  end)
	end
    if cd.Event.marshmallow_autocollect == 0 then
      cd.Event.marshmallow_autocollect = nil
      task.spawn(function()
        pcall(Event.marshmallow_autocollect)
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
  frame.Size = UDim2.new(0, 250, 0, 175)
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
  createLabel("event_currency", "🍡 Candy eggs", 7)
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
