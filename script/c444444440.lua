--Alice, Novella Girl
local s,id=GetID()
function s.initial_effect(c)
   --Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,{id,0})
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)	
	e2:SetCountLimit(1,{id,1})
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(s.tg)  
	e2:SetOperation(s.op)
	c:RegisterEffect(e2,false,REGISTER_FLAG_NOVELLA)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	end
	s.listed_series={0x1BC}
function s.filter(c)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0x1bc) and c:IsFaceup() and c:GetSequence()>4
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zones=aux.GetMMZonesPointedTo(tp,nil,LOCATION_MZONE,0)
	if chk==0 then return zones>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zones) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local zones=aux.GetMMZonesPointedTo(tp,nil,LOCATION_MZONE,0)
	if not e:GetHandler():IsRelateToEffect(e) or zones==0 then return end
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP,zones)
end
function s.desfilter(c)
	return c:IsSetCard(0x1BC) and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and c:IsFaceup() and c:IsDestructable()
	end
	function s.filter1(c,e,tp)
	return c:IsSetCard(0x1BC) and c:IsCode(444444445)or c:IsCode(444444457) or c:IsCode(444444458) and c:IsAbleToHand() 
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g1=Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsSetCard,0x1BC),tp,LOCATION_MZONE,0,1,nil)
	local g2=Duel.IsExistingTarget(s.desfilter,tp,LOCATION_SZONE,0,1,nil)and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_DECK,0,1,nil,e,tp)
	local b1=g1
	local b2=g2
	if chk==0 then return b1 or b2 end
	local op=aux.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)})
	e:SetLabel(op)
   if op==1 then
	local ct=Duel.GetMatchingGroupCount(aux.FilterFaceupFunction(Card.IsSetCard,0x1BC),tp,LOCATION_MZONE,0,nil)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*200)
  else
	local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
	end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then 
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetMatchingGroupCount(aux.FilterFaceupFunction(Card.IsSetCard,0x1BC),tp,LOCATION_MZONE,0,nil)
	Duel.Damage(p,ct*300,REASON_EFFECT)
	else
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_SZONE,0,1,1,nil)
	if #dg==0 then return end
	if Duel.Destroy(dg,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
 
