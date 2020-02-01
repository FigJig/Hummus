using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class Interactable : MonoBehaviour
{
	[SerializeField]
	private EResourceType m_ResourceType;
	[SerializeField]
	private float m_ResourceValue = 1f;
	
	[SerializeField]
	private EInteractType m_StartState = EInteractType.Destruct;

	[SerializeField]
	private EInteractType m_InteractType = EInteractType.None;

	private Animator m_Animator;
	private int m_DestructId;
	private int m_SpeedId;
	private float m_NormalizedAnimTime;
	
	public EResourceType ResourceType { get { return m_ResourceType; } }
	public float ResourceValue { get { return m_ResourceValue; } }

	void Start()
	{
		m_Animator = GetComponent<Animator>();
		m_SpeedId = Animator.StringToHash("Speed");

		m_Animator.enabled = true;
		if (m_StartState == EInteractType.Destruct)
		{
			m_Animator.Play(0, 0, 1f);
		}
		else if (m_StartState == EInteractType.Repair)
		{
			m_Animator.Play(0, 0, 0f);
		}
		StartCoroutine(_DisableAnimator());
	}

	void Update()
	{
		if (m_InteractType == EInteractType.Destruct)
		{
			if (m_Animator.GetAnimatorTransitionInfo(0).normalizedTime >= 1f)
			{
				m_InteractType = EInteractType.None;
				m_Animator.enabled = false;
			}
		}
		else if (m_InteractType == EInteractType.Repair)
		{
			if (m_Animator.GetAnimatorTransitionInfo(0).normalizedTime <= 0f)
			{
				m_InteractType = EInteractType.None;
				m_Animator.enabled = false;
			}
		}
	}

	private IEnumerator _DisableAnimator()
	{
		yield return null;
		m_Animator.enabled = false;
	}

	public void StartDestruct()
	{
		m_InteractType = EInteractType.Destruct;
		m_Animator.enabled = true;
		SetSpeed(1f);
	}

	public void StopDestruct()
	{
		m_InteractType = EInteractType.None;
		m_Animator.enabled = false;
	}

	public void StartRepair()
	{
		m_InteractType = EInteractType.Repair;
		m_Animator.enabled = true;
		SetSpeed(-1f);
	}

	public void StopRepair()
	{
		m_InteractType = EInteractType.None;
		m_Animator.enabled = false;
	}

	public void StopInteract()
	{
		m_InteractType = EInteractType.None;
		m_Animator.enabled = false;
	}

	public void StartInteract(EInteractType interactType)
	{
		m_InteractType = interactType;
		m_Animator.enabled = true;

		if (interactType == EInteractType.Destruct)
		{
			SetSpeed(1f);
		}
		else if (interactType == EInteractType.Repair)
		{
			SetSpeed(-1f);
		}
	}

	private void SetSpeed(float speed)
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
