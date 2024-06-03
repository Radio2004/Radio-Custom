--Night Slasher, Chaoseore
local s,id=GetID()
function s.initial_effect(c)
	--Enable pendulum summon
	Pendulum.AddProcedure(c)
	--Change battle position of 1 monster from each side
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(s.pentg)
	e1:SetOperation(s.penop)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	Debug.Message(Duel.GetFlagEffect(tp,2232000025))
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil)
	local atk=g:GetFirst():GetAttack()+g:GetFirst():GetDefense()
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	if atk>0 then
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
	end
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)~=0 then
		local atk=tc:GetAttack()+tc:GetDefense()
		Duel.Recover(tp,atk,REASON_EFFECT)
	end
end