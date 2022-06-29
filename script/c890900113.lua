--Melirria, Episode of Fire and Ice - The Great Witch
	local s,id=GetID()
	function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x3dd),5,5)
	c:EnableReviveLimit()
	--"Melirria" can choose to not return
	local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DOUBLE_TRIBUTE)
			e2:SetValue(6)
			c:RegisterEffect(e2)
end
	
	