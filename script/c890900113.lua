--Melirria, Episode of Fire and Ice - The Great Witch
	local s,id=GetID()
	function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x3dd),5,5)
	c:EnableReviveLimit()
	--"Melirria" can choose to not return
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(id)
	e3:SetValue(1)
	e3:SetOperation(s.asd)
	c:RegisterEffect(e3)
end
	function s.asd(c)
	if not c:IsHasEffect(890900113) then return false end
	local eff={c:GetCardEffect(890900113)}
	for i=1,#eff do
		release_param = 5
end
	