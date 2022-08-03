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
	function s.regfilter(c,attr)
	return c:GetAttribute()&attr~=0
end
	function s.tgfilter(c)
	return c:IsFaceup()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,3,nil) end
	local ft=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_HAND,0,nil,0x1fa3)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,3,ft,nil)
	Duel.ConfirmCards(1-tp,g)
	local flag=0
	if g:IsExists(s.regfilter,1,nil,ATTRIBUTE_FIRE) then flag=flag|0x1 end
	if g:IsExists(s.regfilter,1,nil,ATTRIBUTE_WATER) then flag=flag|0x2 end
	Duel.ShuffleHand(tp)
	e:SetLabel(flag)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil) or Duel.IsExistingMatchingCard(s.tgfilter,tp,0,LOCATION_REMOVED,1,nil)  end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dtab={}
	local flag=e:GetLabel()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 then
	if flag&0x1~=0 then
		table.insert(dtab,aux.Stringid(id,2))
	end
	if flag&0x2~=0 then
		table.insert(dtab,aux.Stringid(id,3))
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVEEFFECT)
	local op=Duel.SelectOption(tp,table.unpack(dtab))+1
	if op==1 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,ATTRIBUTE_FIRE)
	if #tc>0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
	elseif op==2 then
	local tg=Duel.SelectMatchingCard(tp,s.tgfilter,tp,0,LOCATION_REMOVED,1,1,nil)
	if Duel.SendtoHand(tg,nil,REASON_EFFECT+REASON_RETURN)~=0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,ATTRIBUTE_WATER)
	if #tc>0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
   end
end
	end