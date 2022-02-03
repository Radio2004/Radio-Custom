--Alice, Novella Girl
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.condition)
	e1:SetValue(s.spval)
	c:RegisterEffect(e1)
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)	
	e2:SetCountLimit(1,id)
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
	return c:IsFaceup() and c:IsSetCard(0x1BC) and c:IsLinkMonster() and c:GetSequence()>4
end
function s.spzone(tp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil)
	local zone=0
	for c in aux.Next(g) do
		zone=zone|c:GetLinkedZone(tp)
	end
	return zone&0x1f
end
function s.condition(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	local zone=s.spzone(tp)
	return zone~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function s.spval(e,c)
	local tp=e:GetHandlerPlayer()
	local zone=s.spzone(tp)
	return 0,zone
end
function s.desfilter(c)
	return  c:IsSetCard(0x1BC)and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS
	end
	function s.filter1(c,e,tp)
	return c:IsSetCard(0x1BC) and c:IsCode(444444445)or c:IsCode(444444457) or c:IsCode(444444458)  and c:IsAbleToHand()
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
	local g=(op==1 and g1 or g2)
	local ct=Duel.GetMatchingGroupCount(aux.FilterFaceupFunction(Card.IsSetCard,0x1BC),tp,LOCATION_MZONE,0,nil)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*200)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then 
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetMatchingGroupCount(aux.FilterFaceupFunction(Card.IsSetCard,0x1BC),tp,LOCATION_MZONE,0,nil)
	Duel.Damage(p,ct*300,REASON_EFFECT)
	else
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
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
 
