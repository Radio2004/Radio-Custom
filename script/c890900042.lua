--Philosopher of Melirria - Yoko Hosino
local s,id=GetID()
function s.initial_effect(c)
	--fusion substitute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_FUSION_SUBSTITUTE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
	e2:SetValue(s.subval)
	c:RegisterEffect(e2)
end
s.listed_series={0x3dd}
function s.subcon(e)
	return e:GetHandler():IsLocation(LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
end
function s.subval(e,c)
	return c:IsSetCard(0x3dd)
end

