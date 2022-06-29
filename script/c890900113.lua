--Melirria, Episode of Fire and Ice - The Great Witch
	Duel.LoadScript("manytributes.lua")
	local s,id=GetID()
	function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x3dd),5,3)
	c:EnableReviveLimit()
	--double xyz material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(id)
	e2:SetValue(2)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_RANK_LEVEL_S)
	c:RegisterEffect(e5)
end