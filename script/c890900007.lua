--Melirria, Episode of Fire and Ice - Lilith
local s,id=GetID()
	function s.initial_effect(c)
	--Special Summon from hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Inflict Damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
	function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,0x3dd),tp,LOCATION_MZONE,0,1,nil)
end
	function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
	function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)>0 then
		local fid=c:GetFieldID()
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		--Return it to the hand during the End Phase
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(fid)
		e1:SetLabelObject(c)
		e1:SetCondition(s.thcon)
		e1:SetOperation(s.thop)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCondition(s.thcon1)
		e2:SetOperation(s.thop1)
		Duel.RegisterEffect(e2,tp)
	end
end
	function s.thcon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if e:GetHandler():IsHasEffect(890900013) then
	if tc:GetFlagEffectLabel(id)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
	end
	function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not e:GetHandler():IsHasEffect(890900013) then
	if tc:GetFlagEffectLabel(id)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
	end
	function s.thop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end
	end
	function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end
	function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsFaceup() and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
	function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Recover(tp,tc:GetBaseDefense(),REASON_EFFECT)
		--Destroy
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e1:SetCode(EVENT_CHANGE_POS)
		e1:SetOperation(s.desop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(id)~=1 then
		Duel.Destroy(c,REASON_EFFECT)
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	end
end