---
name: roblox-systems
description: >
  Diseña e implementa sistemas de juego para Roblox en Luau. Usa para
  crear sistemas de crafting, trading, inventario, raridades, economía,
  daily rewards, leaderboards, o cualquier mecánica de gameplay.
allowed-tools: Read, Write, Bash, Grep, Glob
---

# Roblox Game Systems Skill

## Patrones de arquitectura

### Patrón Service-Controller
```lua
-- ServerScriptService/Services/CraftingService.lua (SERVIDOR)
local CraftingService = {}

function CraftingService:Init()
    -- Conectar RemoteEvents
end

function CraftingService:Craft(player: Player, recipeId: string): boolean
    -- Validar, ejecutar, notificar
end

return CraftingService

-- StarterPlayerScripts/Controllers/CraftingController.lua (CLIENTE)
local CraftingController = {}

function CraftingController:RequestCraft(recipeId: string)
    -- Llamar RemoteEvent, actualizar UI
end

return CraftingController
```

### Patrón de datos persistentes
```lua
-- Siempre en servidor
local DataStoreService = game:GetService("DataStoreService")
local playerStore = DataStoreService:GetDataStore("PlayerData_v1")

-- Guardar con retry
local function saveData(player: Player, data: {[string]: any})
    local success, err
    for attempt = 1, 3 do
        success, err = pcall(function()
            playerStore:SetAsync(tostring(player.UserId), data)
        end)
        if success then break end
        task.wait(1)
    end
    if not success then
        warn("[SERVER] Fallo al guardar datos de", player.Name, err)
    end
end
```

## Sistema de raridades estándar
```lua
local RARITIES = {
    Common    = { weight = 60, color = Color3.fromRGB(180, 180, 180) },
    Uncommon  = { weight = 25, color = Color3.fromRGB(30, 200, 30)  },
    Rare      = { weight = 10, color = Color3.fromRGB(30, 100, 255) },
    Epic      = { weight = 4,  color = Color3.fromRGB(160, 30, 255) },
    Legendary = { weight = 1,  color = Color3.fromRGB(255, 200, 0)  },
}

-- Selección ponderada
local function rollRarity(): string
    local total = 0
    for _, data in RARITIES do
        total += data.weight
    end
    local roll = math.random() * total
    local cumulative = 0
    for name, data in RARITIES do
        cumulative += data.weight
        if roll <= cumulative then
            return name
        end
    end
    return "Common"
end
```

## Seguridad (CRÍTICO)
- Toda lógica de economía, crafting, trading en SERVIDOR
- RemoteEvents: validar que el jugador puede hacer la acción
- Rate limiting: máximo N requests por segundo por jugador
- Sanity checks: ¿tiene los materiales? ¿el trade es justo?
- Nunca enviar datos sensibles al cliente (inventario de otros, probabilidades exactas)

## Anti-patrones Roblox
- `wait()` — usar `task.wait()` (más preciso)
- Strings para identificar instancias — usar CollectionService tags
- Datos en el cliente — toda verdad en el servidor
- Scripts en Workspace — usar ServerScriptService
- Polling — usar eventos y signals
