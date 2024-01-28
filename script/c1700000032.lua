-- Virtuality Force - Earth
local s,id=GetID()
function s.initial_effect(c)
	-- Activate
	-- Overley
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	aux.GlobalCheck(s,function()
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_ADD_TYPE)
		ge1:SetTargetRange(LOCATION_OVERLAY,LOCATION_OVERLAY)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,1700000032))
		ge1:SetValue(TYPE_MONSTER)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect()
		ge2:SetType(EFFECT_TYPE_FIELD)
		ge2:SetCode(EFFECT_ADD_ATTRIBUTE)
		ge2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		ge2:SetTarget(aux.TargetBoolFunction(Card.IsCode,1700000032))
		ge2:SetValue(ATTRIBUTE_EARTH)
		ge2:SetRange(LOCATION_OVERLAY,LOCATION_OVERLAY)
		c:RegisterEffect(ge2,0)
	end)
end

function s.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) and c:IsRelateToEffect(e) then
		c:CancelToGrave()
		Duel.Overlay(tc,c)
	end
end


function s.monval(e,c)
	if c:IsLocation(LOCATION_OVERLAY) then
		return TYPE_MONSTER
	else
		return 0
	end
end


