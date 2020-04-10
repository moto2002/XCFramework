---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by admin.
--- DateTime: 2020/4/10 15:39
---
local HudAgent = BaseClass("HudAgent")

local function __init(self, character)
    self.character = character
    self.uiName = nil
    self.uiChat = nil
    self.uiLifeBar = nil
    self.uiState = nil

    self.battleEffs = {}
    self.battleHps = {}

end

-- 设置名字
local function SetName(self, name, cameraLayer, hudType)
    if not self.character then
        return
    end

    if (not name) and (not cameraLayer) then
        return
    end

    if not hudType then
        return
    end

    local offset
    if hudType == HUD_TYPE.TOP_NAME then
        offset = HUDTYPE_OFFSET.TOP_NAME

    elseif hudType == HUD_TYPE.BOTTOM_NAME then
        offset = HUDTYPE_OFFSET.BOTTOM_NAME
    else

    end

    if not offset then
        return
    end

    local nameColor;
    if self.character:GetType() == CHARACTER_TYPE.NPC then
        nameColor = self:GetColorValue(NPC_NAME_COLOR_ID)
    else
        nameColor = self:GetColorValue(PLAYER_NAME_COLOR_ID)
    end

    if self.uiName == nil then
        self.uiName = require "Logic.Character.UIName".New(self.character, cameraLayer, offset);
    end

    self.uiName:SetUIName(name, nameColor);
end

HudAgent.__init = __init
HudAgent.SetName = SetName
return HudAgent;