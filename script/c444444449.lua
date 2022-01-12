--Saber Hunter Ly, Novella Girl--

local s,id=GetID()
function s.initial_effect(c)
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x1BC),1,1)
	--SS
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.sscost(c))
	e1:SetTarget(s.sstg)
	e1:SetOperation(s.ssop(c))
	c:RegisterEffect(e1)
end

function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsSetCard,1,nil,0x1bc,lc,sumtype,tp)
end
function merge(t1, t2, filter)
	filter=filter or false
	if filter==true then
		local dup=false
		for _, i in ipairs(t2) do
			for _, j in ipairs(t1) do
				dup = (i == j)
				if dup then break end
			end
			if not dup then
				table.insert(t1, i)
			end
		end
	else
		for _, i in ipairs(t2) do
			table.insert(t1, i)
		end
	end
end
--SS

function s.filter(c,e,tp)
	return c:IsSetCard(0x1BC)and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLocation(LOCATION_GRAVE)
end

function s.sscost(c)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local ctm,dtg,drem,mz=c:GetMaterial():FilterCount(s.filter,nil,e,tp),Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_DECK,0,nil),Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_DECK,0,nil),Duel.GetLocationCount(tp,LOCATION_MZONE)
		if chk==0 then 
			if ctm==0 then return false end
			return ctm>0 and #dtg>=ctm and #drem>=ctm and mz>0
		end
		local ct=math.min(ctm,#dtg,#drem,mz)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=dtg:Select(tp,1,ct,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rem=drem:Select(tp,#tg,#tg,tg)
		Duel.SendtoGrave(tg,REASON_COST)
		Duel.Remove(rem,POS_FACEUP,REASON_COST)
		e:SetLabel(#tg)
	end
end

function s.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,e:GetLabel(),tp,LOCATION_GRAVE)
end

function s.ssop(c)
	return function(e,tp,eg,ep,ev,re,r,rp)
		if c:GetMaterial():IsExists(aux.NOT(s.filter),1,nil,e,tp) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=c:GetMaterial():FilterSelect(tp,s.filter,e:GetLabel(),e:GetLabel(),nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local effs,acteffs,desc={},{},{}
		for tc in aux.Next(g) do
			merge(desc,{tc:GetCardEffect(id)},true)
		end
		local cost,con,tg
		for _,eff in ipairs(effs) do
			con,tg=eff:GetCondition(),eff:GetTarget()
			if (not con or con(e,tp,eg,ep,ev,re,r,rp)) and (not cost or cost(e,tp,eg,ep,ev,re,r,rp,0)) and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)) then
				table.insert(acteffs,eff:GetLabelObject())
				table.insert(desc,eff:GetLabelObject():GetDescription())
			end
		end
		while #acteffs>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) do
			local i=Duel.SelectOption(tp,table.unpack(desc))
			local eff=acteffs[i+1]
			if cost then cost(e,tp,eg,ep,ev,re,r,rp,1) end
			if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
			local op=eff:GetOperation()
			op(e,tp,eg,ep,ev,re,r,rp)
			table.remove(acteffs,eff)
			table.remove(desc,desc[i+1])
		end
	end
end
