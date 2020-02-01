using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class Interactable : MonoBehaviour
{
	public UnityEvent OnLeftDown;
	public UnityEvent OnLeftHeld;
	public UnityEvent OnLeftUp;

	public UnityEvent OnRightDown;
	public UnityEvent OnRightHeld;
	public UnityEvent OnRightUp;

	[SerializeField]
	private float m_TimeToDestroy;
	[SerializeField]
	private float m_TimeToRepair;

	private Animator m_Animator;
	private int m_DestructId;
	private int m_SpeedId;

	private float m_NormalizedAnimTime;

	void Start()
	{
		m_Animator = GetComponent<Animator>();
		m_SpeedId = Animator.StringToHash("Speed");
	}

	public void SetSpeed(float speed)
	{
		//Cap the time between 0 and 1
		if (m_Animator.GetCurrentAnimatorStateInfo(0).normalizedTime > 1f)
		{
			m_Animator.Play(0, 0, 1f);
		}
		else if (m_Animator.GetCurrentAnimatorStateInfo(0).normalizedTime < 0f)
		{
			m_Animator.Play(0, 0, 0f);
		}

		m_Animator.SetFloat(m_SpeedId, speed);
	}
}
