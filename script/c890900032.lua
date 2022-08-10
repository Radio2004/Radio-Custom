--Future of Melirria - Shizuka Tiba
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x3dd),1)
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_RANK_LEVEL_S)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(s.xyzlv)
		c:RegisterEffect(e1)
end
	function s.xyzlv(e,c,rc)
	return c:GetLink()
end
