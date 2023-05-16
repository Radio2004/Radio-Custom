--test
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,{id,1})
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Change Attribute to EARTH
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_GRAVE,0)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x7cc))
	e2:SetValue(ATTRIBUTE_WIND)
	c:RegisterEffect(e2)	
end