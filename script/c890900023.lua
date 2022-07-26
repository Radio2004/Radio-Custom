--Future of Melirria - Mena Sakamotou
	local s,id=GetID()
	function s.initial_effect(c)
	c:EnableCounterPermit(0x382)
	--link summon
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x3dd),2,2,s.lcheck)
	c:EnableReviveLimit()
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.ctcon)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--Remove all counter
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,{id,1})
	e4:SetTarget(s.tgtg)
	e4:SetOperation(s.tgop)
	c:RegisterEffect(e4)
end
s.counter_place_list={0x382}
	function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsSetCard,1,nil,0x38d,lc,sumtype,tp)
end
	function s.cfilter(c,ec)
	if c:IsLocation(LOCATION_MZONE) then
		return c:IsSetCard(0x3dd) and c:IsFaceup() and ec:GetLinkedGroup():IsContains(c)
	else
		return c:IsPreviousSetCard(0x3dd) and c:IsPreviousPosition(POS_FACEUP)
			and bit.extract(ec:GetLinkedZone(c:GetPreviousControler()),c:GetPreviousSequence())~=0
	end
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,e:GetHandler())
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x382,5)
end
	function s.schfilter(c)
	return c:IsSetCard(0x3dd) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
	function s.atkfilter(c)
	return c:IsSetCard(0x3dd) and c:IsFaceup() and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
	function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x382)
	local ct1=c:GetCounter(0x382)
	local g1=Duel.IsCanRemoveCounter(tp,1,0,0x382,1,REASON_COST) and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil)
	local g2=Duel.IsCanRemoveCounter(tp,1,0,0x382,3,REASON_COST) and Duel.IsExistingMatchingCard(s.atkfilter,tp,LOCATION_MZONE,0,1,nil)
	local g3=Duel.IsCanRemoveCounter(tp,1,0,0x382,5,REASON_COST) and Duel.IsExistingMatchingCard(s.schfilter,tp,LOCATION_DECK,0,1,nil)
	local b1=g1  
	local b2=g2
	local b3=g3 
	if chk==0 then return b1 or b2 or b3 end
	local op=aux.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)},
		{b3,aux.Stringid(id,2)})
		e:SetLabel(op)
	local g=(op==1 and g1 or g2 or g3)
		Duel.SetTargetParam(ct)
		Duel.RemoveCounter(tp,1,0,0x382,ct,REASON_COST)
	end
	function s.filter(c)
	return c:IsSetCard(0x3dd) and c:IsAbleToGrave() 
end
   function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	local ct=c:GetCounter(0x42)
	if not c:IsRelateToEffect(e) then return end
	if op==1 then
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		end
	elseif op==2 then
		local atkg=Duel.GetMatchingGroup(aux.FilterFaceupFunction(Card.IsSetCard,0x3dd),tp,LOCATION_MZONE,0,nil)
		for tc in aux.Next(atkg) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(ct*200)
		tc:RegisterEffect(e1)
		end
	else
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.schfilter,tp,LOCATION_DECK,0,e:GetLabel(),math.floor(e:GetLabel()/2),nil)
		if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
	end