--Melirria, Episode of Fire and Ice - The Great Witch
	local s,id=GetID()
	function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x3dd),5,5)
	c:EnableReviveLimit()
	--"Melirria" can choose to not return
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(id)
	e3:SetRange(LOCATION_MZONE)
	e3:value(s.asd)
	c:RegisterEffect(e3)
end
	function s.asd(e,c)
	return e:SetTargetParam(GetOverlayCount())
end
	
	