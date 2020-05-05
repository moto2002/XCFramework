---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by ricashao.
--- DateTime: 2020/4/18 2:15
---
local BattleEffect = BaseClass("BattleEffect", TransformObject)

--绑定监听
local function StartRender(self)
    self.__playcomplete = BindCallback(self, self.PlayComplete)
    self.__dispatchevent = BindCallback(self, self.DispatchEvent)

    self._uRender:AddDBEventListener(CS.DragonBones.EventObject.COMPLETE, self.__playcomplete)
    self._uRender:AddDBEventListener(CS.DragonBones.EventObject.FRAME_EVENT, self.__dispatchevent)
    self:StartUnitAction()
end

local function PlayComplete(self)
    self.curLoop = self.curLoop + 1
    if (self.loop == 0) then
        self:StartUnitAction()
    elseif (self.loop == self.curLoop) then
        if (self.eventHandler) then
            self.eventHandler()
        end
        self:Delete()
    else
        self:StartUnitAction()
    end
end

local function DispatchEvent(self, type, eventObject)
    if (self.eventHandler) then
        self.eventHandler(eventObject.name, self)
    end
end

local function Init(self, uri, aniOption, create_callback, relative_order)
    self.create_callback = create_callback
    self.relative_order = relative_order or 0
    local effect_config = EffectConfig[uri]
    if (aniOption) then
        self.loop = aniOption.loop or 1--循环次数
        self.eventHandler = aniOption.handler
    else
        self.loop = 0--循环次数
    end
    self.curLoop = 0 -- 当前循环次数

    if (effect_config == nil) then
        Logger.LogError("特效配置不存在 path：" .. uri)
    end
    self.effectPath = effect_config.EffectPath
    GameObjectPool:GetInstance():GetGameObjectAsync(self.effectPath, BindCallback(self, self.EffectLoadedEnd))
end

local function EffectLoadedEnd(self, pfb)
    self.pfb = pfb
    pfb.transform:SetParent(self.transform, false)
    local trans = self.pfb.transform
    if not IsNull(trans) then
        -- 初始化
        trans.localScale = Vector3.one
        trans.localPosition = Vector3.zero
    end

    -- 获取龙骨
    self._uRender = pfb:GetComponent(typeof(CS.DragonBones.UnityArmatureComponent))
    StartRender(self)

    --self._uRender:SetOrder(self.relative_order)
    if self.create_callback ~= nil then
        self.create_callback()
    end
end

local function StartUnitAction(self)
    self._uRender.animation:Play("a0")
end

local function __delete(self)
    GameObjectPool:GetInstance():RecycleGameObject(self.effectPath, self.pfb)
    self._uRender:RemoveDBEventListener(CS.DragonBones.EventObject.COMPLETE, self.__playcomplete)
    self._uRender:RemoveDBEventListener(CS.DragonBones.EventObject.FRAME_EVENT, self.__dispatchevent)
    self.__playcomplete = nil
    self.__dispatchevent = nil
    self.pfb = nil
    self.effectPath = nil
    self._uRender = nil
    self.eventHandler = nil
    self.create_callback = nil
end

BattleEffect.Init = Init
BattleEffect.StartUnitAction = StartUnitAction
BattleEffect.PlayComplete = PlayComplete
BattleEffect.DispatchEvent = DispatchEvent
BattleEffect.EffectLoadedEnd = EffectLoadedEnd
BattleEffect.__delete = __delete
return BattleEffect
