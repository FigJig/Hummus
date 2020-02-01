using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class Interactable : MonoBehaviour
{
	[SerializeField]
	private EResourceType m_ResourceType;
	[SerializeField]
	private float m_ResourceRate = 1f;
	[SerializeField]
	private float m_TotalInteractTime = 2f;

	[Tooltip("0 - fully repaired, 1 - fully destructed")]
	[Range(0, 1)]
	[SerializeField]
	private float m_StartInteractTime = 0f;

	[SerializeField]
	private EInteractType m_InteractType = EInteractType.None;

	private Animator m_Animator;
	private int m_DestructId;
	private int m_SpeedId;
	private float m_NormalizedAnimTime;

	public float CurrentInteractTime { get; private set; }
	public EResourceType ResourceType { get { return m_ResourceType; } }
	public float ResourceRate { get { return m_ResourceRate; } }

	void Start()
	{
		m_Animator = GetComponent<Animator>();
		m_SpeedId = Animator.StringToHash("Speed");

		m_Animator.enabled = true;
		m_Animator.Play(0, 0, m_StartInteractTime);
		StartCoroutine(_DisableAnimator());

		CurrentInteractTime = m_StartInteractTime;
	}

	void Update()
	{
		if (m_InteractType == EInteractType.Destruct)
		{
			if (CurrentInteractTime < 1f)
			{
				CurrentInteractTime += Time.deltaTime / m_TotalInteractTime;
			}
		}
		else if (m_InteractType == EInteractType.Repair)
		{
			if (CurrentInteractTime > 0f)
			{
				CurrentInteractTime -= Time.deltaTime / m_TotalInteractTime;
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
