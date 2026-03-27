typedef unsigned int TEntityId;

class CActor
{
public:
	void Tick();
};

class CBadPanel : public CActor
{
public:
	virtual void Tick() override;

	void BindTarget(CActor* pTarget)
	{
		char buffer[] = "temp";
		m_pTarget = pTarget;
		m_pBuffer = buffer;
		m_pOwnedId = NULL;
	}

	~CBadPanel()
	{
		delete m_pBuffer;
	}

private:
	CActor* m_pTarget;
	char* m_pBuffer;
	TEntityId m_pOwnedId;
};
