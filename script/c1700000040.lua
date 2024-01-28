--Virtuality Elemental Sword
local s,id=GetID()
function s.initial_effect(c)
	local e1=aux.AddEquipProcedure(c,nil,s.filter)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
  --Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(s.val)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(s.val)
	c:RegisterEffect(e3)
end
function s.val(e,c)
	return Duel.GetMatchingGroupCount(Card.IsSetCard,c:GetControler(),LOCATION_GRAVE,0,nil,0x7cc)*100
end
function s.filter(c)
	return c:IsSetCard(0x7cc) and c:IsType(TYPE_XYZ)
end

