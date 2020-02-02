using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public enum EDestructRepairState
{
	Repairing,
	Repaired,
	Destructing,
	Destructed
}

public class DestructRepair : MonoBehaviour
{
	[SerializeField]
	private float m_AnimTime = .5f;
	[SerializeField]
	private EDestructRepairState m_CurrentState;

	[SerializeField]
	private UnityEvent OnDestructed;
	[SerializeField]
	private UnityEvent OnRepaired;

	MeshRenderer m_MeshRenderer;

	[SerializeField]
	private float m_CurrentTime;

	void Start()
	{
		m_MeshRenderer = GetComponent<MeshRenderer>();

		if (m_CurrentState == EDestructRepairState.Repaired || m_CurrentState == EDestructRepairState.Destructing)
		{
			m_CurrentTime = m_AnimTime;
		}
		else if (m_CurrentState == EDestructRepairState.Destructed || m_CurrentState == EDestructRepairState.Repairing)
		{
			m_CurrentTime = 0f;
		}
	}
	
	void Update()
	{
		if (m_CurrentState == EDestructRepairState.Destructing)
		{
			m_CurrentTime -= Time.deltaTime;
			if (m_CurrentTime <= 0f)
			{
				m_CurrentTime = 0f;
				m_CurrentState = EDestructRepairState.Destructed;
				OnDestructed.Invoke();
			}
			m_MeshRenderer.material.SetFloat("_DissolveValue", m_CurrentTime / m_AnimTime);
		}
		else if (m_CurrentState == EDestructRepairState.Repairing)
		{
			m_CurrentTime += Time.deltaTime;
			if (m_CurrentTime >= m_AnimTime)
			{
				m_CurrentTime = m_AnimTime;
				m_CurrentState = EDestructRepairState.Repaired;
				OnRepaired.Invoke();
			}
			m_MeshRenderer.material.SetFloat("_DissolveValue", m_CurrentTime / m_AnimTime);
		}
	}

	public void SetStateRepairing()
	{
		m_CurrentState = EDestructRepairState.Repairing;
	}

	public void SetStateDestructing()
	{
		m_CurrentState = EDestructRepairState.Destructing;
	}

	public void SetStateDestructed()
	{
		m_CurrentState = EDestructRepairState.Destructed;
	}

	public void SetStateRepaired()
	{
		m_CurrentState = EDestructRepairState.Repaired;
	}
}
