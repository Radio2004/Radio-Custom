--Friendship of Melirria - Felix, Alice and Leo
local s,id=GetID()
function s.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function s.cfilter(c)
	return c:IsSetCard(0x1fa3) and not c:IsPublic()
end
	function s.spfilter(c,e,tp,att)
	return c:IsSetCard(0x1fa3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and c:IsAttribute(att)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,3,nil) end
	local ft=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_HAND,0,nil,0x1fa3)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,3,ft,nil)
	e:SetLabel(g:GetFirst():GetAttribute())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dtab={}
	local b1=e:GetLabel()&ATTRIBUTE_FIRE >0
	local b2=e:GetLabel()&ATTRIBUTE_WATER >0
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT) > 0 then
	if b1 then
		table.insert(dtab,aux.Stringid(id,2))
	end
	if b2 then
		table.insert(dtab,aux.Stringid(id,3))
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVEEFFECT)
	local op=Duel.SelectOption(tp,table.unpack(dtab))+1
	if not b2 then op=1 end
	if not b1 then op=2 end
	if (b1 and b3 and not b2 and op==2) then op=3 end
	if (b2 and b3 and not b1) then op=op+1 end
	if op==1 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	if Duel.Remove(g,POS_FACEUP,REASON_COST)>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,ATTRIBUTE_FIRE)
	if #tc>0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
	elseif op==2 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	if Duel.Remove(g,POS_FACEUP,REASON_COST)>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,ATTRIBUTE_WATER)
	if #tc>0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
   end
end
	end