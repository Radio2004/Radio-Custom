--Novella's Attention
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={0x1BC}

function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1BC) and c:IsAttribute(ATTRIBUTE_WATER+ATTRIBUTE_WIND+ATTRIBUTE_DARK+ATTRIBUTE_EARTH)
end


function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end


function s.cfilter2(c,att)
	return c:IsFaceup() and c:IsAttribute(att) and c:IsSetCard(0x1BC)
end


function s.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x1BC)
end


function s.cfilter3(c)
	return c:IsFaceup() and c:IsSetCard(0x1BC) and c:IsLinkMonster() and c:IsLinkAbove(1)
end


function s.filter1(c)
	return c:IsPosition(POS_FACEUP_ATTACK)
	end


function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
local g1=Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_WIND)
local g2=Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_WATER)
		and Duel.IsExistingMatchingCard(s.cfilter3,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
local g3=Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_DARK)
		and Duel.IsExistingTarget(aux.FaceupFilter(Card.IsCanTurnSet),tp,0,LOCATION_MZONE,1,nil)
local g4=Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_EARTH)
		and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,nil)
local b1=g1  
local b2=g2
local b3=g3
local b4=g4	 
	if chk==0 then return b1 or b2 or b3 or b4 end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)},
		{b3,aux.Stringid(id,2)},
		{b4,aux.Stringid(id,3)})
		e:SetLabel(op)
	if op==1 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectTarget(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_MZONE,0,1,1,nil)
	elseif op==2 then
		e:SetCategory(CATEGORY_ATKCHANGE)
	elseif op==3 then
		e:SetCategory(CATEGORY_POSITION)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local g=Duel.SelectTarget(tp,aux.FaceupFilter(Card.IsCanTurnSet),tp,0,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	else
		e:SetCategory(CATEGORY_TOHAND)
		local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_MZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	local tc=Duel.GetFirstTarget()
	if op==1 then
	if tc and tc:IsRelateToEffect(e) then
	--Cannot be destroyed by card effects
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(3001)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
elseif op==2 then
	local g=Duel.GetMatchingGroup(s.filter1,tp,0,LOCATION_MZONE,nil)
	local lk=Duel.GetMatchingGroup(s.cfilter3,tp,LOCATION_MZONE,0,nil)
	local sg=lk:GetMaxGroup(Card.GetLink)
	if #sg>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		sg=sg:Select(tp,1,1,nil)
	end
	local ct=sg:GetFirst()
	for tg in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-500*ct:GetLink())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tg:RegisterEffect(e1)
end
	elseif op==3 then
	if not tc:IsRelateToEffect(e) then return end
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	else
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end