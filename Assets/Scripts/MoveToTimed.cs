using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveToTimed : MonoBehaviour
{
	public enum EMoveState
	{
		AtStart,
		ToStart,
		AtEnd,
		ToEnd
	}

	[SerializeField]
	private Transform m_StartPos;
	[SerializeField]
	private Transform m_EndPos;
	[SerializeField]
	private float m_MoveTime;
	[SerializeField]
	private EMoveState m_MoveState;

	private float m_CurrentTime = 0f;

	void Update()
	{
		if (m_MoveState == EMoveState.ToEnd)
		{
			transform.position = Vector3.Lerp(m_StartPos.position, m_EndPos.position, m_CurrentTime / m_MoveTime);
		}
		else if (m_MoveState == EMoveState.ToStart)
		{
			transform.position = Vector3.Lerp(m_EndPos.position, m_StartPos.position, m_CurrentTime / m_MoveTime);
		}
	}

	public void MoveToStart()
	{
		if (m_MoveState == EMoveState.AtEnd)
		{
			m_MoveState = EMoveState.ToStart;
		}
	}

	public void MoveToEnd()
	{
		if (m_MoveState == EMoveState.AtStart)
		{
			m_MoveState = EMoveState.ToEnd;
		}
	}
}
