--Bella von Meller, Novella Girl - Challenger
local s,id=GetID()
function s.initial_effect(c)
--Link summon 
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x1BC),2,2)
	 -- Effects
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.descost)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
end
function s.filter(c,g,att)
	return c:IsFaceup() and c:IsAttribute(att) and g:IsContains(c) 
end


function s.confilter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end


function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(9)
	return true
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lg=e:GetHandler():GetLinkedGroup()
	local g1=Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,lg,ATTRIBUTE_WATER) and Duel.IsExistingTarget(s.confilter,tp,0,LOCATION_MZONE,1,nil)
	local g2=nil
	if e:GetLabel()==9 then
		g2=Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,lg,ATTRIBUTE_WIND)
	else
		g2=Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,lg,ATTRIBUTE_WIND)
end
	local b1=g1
	local b2=g2
	if chk==0 then e:SetLabel(0) return b1 or b2 end
	local op=aux.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)})
	if op==1 then
		e:SetCategory(CATEGORY_CONTROL)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g=Duel.SelectTarget(tp,s.confilter,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	else
		if e:GetLabel()==9 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil)
			tc=g:GetFirst()
			Duel.BreakEffect()
			aux.RemoveUntil(tc,POS_FACEUP,REASON_COST,PHASE_END,id,e,tp,function(rg)Duel.SendtoHand(rg,tp,REASON_EFFECT) end)
		end
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
	end
	e:SetLabel(op)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if e:GetLabel()==1 then
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.GetControl(tc,tp,PHASE_END,1)
end
	else
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	if #g==0 then return end
	local rg=g:RandomSelect(tp,1)
	local tc=rg:GetFirst()
	Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	aux.RemoveUntil(tc,POS_FACEUP,REASON_EFFECT,PHASE_END,id,e,1-tp,function(rg) Duel.SendtoHand(rg,REASON_EFFECT) end)
	end
end