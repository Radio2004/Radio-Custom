--Cyberse Melirria
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3dd))
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(s.sumcon)
	e3:SetOperation(s.sumsuc)
	c:RegisterEffect(e3)
	--cannot target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(s.indtg)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--Effects
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,4))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetCost(s.cost)
	e5:SetTarget(s.target)
	e5:SetOperation(s.operation)
	c:RegisterEffect(e5)
end
s.listed_series={0x3dd,0x22cd}
function s.filter(c)
	return c:IsFaceup() and c:IsLinkMonster() and c:IsSetCard(0x3dd)
end
function s.indtg(e,c)
	local tp=e:GetHandlerPlayer()
	local tg=Group.CreateGroup()
	local lg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(lg) do
		tg:Merge(tc:GetLinkedGroup())
	end
	return c:IsFaceup() and tg:IsContains(c) and c:IsSetCard(0x3dd)
end
function s.limfilter(c)
	return c:GetSummonType()==SUMMON_TYPE_LINK and c:IsSetCard(0x3dd)
end
function s.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.limfilter,1,nil)
end
function s.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
function s.costfilter(c)
	return c:IsSetCard(0x3dd) and c:IsDiscardable()
end
	function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,s.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x38d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function s.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x3dd) and c:IsAbleToHand() and not (c:IsType(TYPE_FIELD) and c:IsSetCard(0x3dd))
end
function s.tdfilter(c)
	return c:IsSetCard(0x22cd) and c:IsAbleToDeck()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=true
	local g2=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	local g3=Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE,0,1,nil)
	local b1=g1
	local b2=g2
	local b3=g3
	if chk==0 then return b1 or b2 or b3 end
	local op=aux.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)},
		{b3,aux.Stringid(id,2)})
	e:SetLabel(op)
	if op==2 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_TODECK)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	if op==1 then
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,3))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.atcon)
	e1:SetOperation(s.atop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	elseif op==2 then
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	else
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local td=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #td>0 then
		Duel.SendtoDeck(td,nil,2,REASON_EFFECT)
		end
	end
end
function s.atcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return end
	if d:IsControler(tp) then
		e:SetLabelObject(a)
		return d:IsSetCard(0x3dd) and d:IsFaceup()
			and a:IsRelateToBattle() and a:IsLocation(LOCATION_ONFIELD)
	elseif a:IsControler(tp) then
		e:SetLabelObject(d)
		return a:IsSetCard(0x3dd) and a:IsFaceup()
			and d:IsRelateToBattle() and d:IsLocation(LOCATION_ONFIELD)
	end
	return false
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=e:GetLabelObject()
	if tc and tc:IsRelateToBattle() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end