-- Virtuality Force - Earth
local s,id=GetID()
function s.initial_effect(c)
--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_ADD_ATTRIBUTE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetValue(ATTRIBUTE_EARTH)
	e4:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e4)
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

function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOriginalAttribute()
end

function s.xyzcon(e)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_XYZ)
end

