---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by ricashao.
--- DateTime: 2020/4/16 15:03
---
local Warrior = BaseClass("Warrior", Character)

local function Parse(self, fightInfo, pos, dir)
    self.maxhp = fightInfo.maxhp
    self.hp = fightInfo.hp
    self.hide = false
end

local function SetBornPos(self)
    local battleScene = BattleManager:GetInstance():GetBattle():GetMapInfo()
    local screenPt = battleScene:GetBattlePosBySlot(self.pos.x, self.pos.y)
    self:SetLocalPosition(Vector3.New(screenPt.x, screenPt.y, 0))
end

local function Initialize(self, fighterInfo, pos, dir, cb)
    self:Parse(fighterInfo, pos, dir)
    self.layer = SceneLayer.Battler
    Character.Initialize(self, fighterInfo, pos, dir, cb)
    SetBornPos(self)
end
------------- get set end --------------
local function GetType(self)
    return CHARACTER_TYPE.WARRIOR
end

local function SetFighterId(self, fighterId)
    self.fighterId = fighterId;
end

local function GetBattlePos(self)
    return self.pos
end

local function SetBattlePos(self, pos)
    self.pos = pos
end

------------- get set end --------------

local function GetOffsetByPointType(self, pointType)
    pointType = (pointType + self.d) % 4 + 1
    if (pointType == BattleArrivePointType.Front) then
        return { x = 0.25, y = 0.12 }
    elseif (pointType == BattleArrivePointType.Behind) then
        return { x = 0.25, y = -0.12 }
    elseif (pointType == BattleArrivePointType.Left) then
        return { x = -0.25, y = -0.12 }
    else
        return { x = -0.25, y = 0.12 }
    end
end

------------ 移动相关 Begin -----------
--- 战斗中进行移动
local function MoveInBattle(self, movePaths, cb)
    local action = require "Unit.Actions.WalkSlgAction".New(movePaths)
    self:StartUnitAction(action, false, cb)
end

--- 被动移动时使用
local function MoveByTime(self, destpos, time, cb)
    TweenNano.Create(time, unit, { x = destpos.x, y = destpos.y }, "linear", nil, cb)
end

local function GetPosByIdAndArrivePointType(self, pointType, xishu)
    local pos = self:GetRealPos()
    local dir = GetOffsetByPointType(self, pointType)
    return { x = pos.x + dir.x * xishu, y = pos.y + dir.y * xishu }
end

------------  移动相关 End   ----------

Warrior.MoveInBattle = MoveInBattle
Warrior.MoveByTime = MoveByTime
Warrior.Initialize = Initialize
Warrior.GetType = GetType
Warrior.SetFighterId = SetFighterId
Warrior.Parse = Parse
Warrior.GetBattlePos = GetBattlePos
Warrior.SetBattlePos = SetBattlePos
Warrior.GetPosByIdAndArrivePointType = GetPosByIdAndArrivePointType
return Warrior